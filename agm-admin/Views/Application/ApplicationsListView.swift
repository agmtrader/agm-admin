import SwiftUI
import Combine

@MainActor
final class ApplicationsListViewModel: ObservableObject {
    @Published var applications: [Application] = []
    @Published var accounts: [Account] = []
    @Published var isLoading: Bool = false
    @Published var showWithAccounts: Bool = true {
        didSet { applyFilter() }
    }

    private var allApplications: [Application] = []

    func fetch() {
        isLoading = true
        Task {
            do {
                async let fetchedApps = ApplicationService.shared.readApplications()
                async let fetchedAccounts = AccountService.shared.readAccounts()
                let (apps, accs) = try await (fetchedApps, fetchedAccounts)
                self.accounts = accs
                self.allApplications = apps.sorted { ($0.created ?? "") > ($1.created ?? "") }
                self.applyFilter()
            } catch {
                print("Failed to fetch applications: \(error)")
            }
            isLoading = false
        }
    }

    private func applyFilter() {
        guard !allApplications.isEmpty else { applications = []; return }
        if showWithAccounts {
            applications = allApplications
        } else {
            let appIdsWithAccount = Set(accounts.map { $0.applicationId })
            applications = allApplications.filter { !appIdsWithAccount.contains($0.id) }
        }
    }
}

struct ApplicationsListView: View {
    @StateObject private var vm = ApplicationsListViewModel()

    private func title(for app: Application) -> String {
        // simplistic placeholder; backend should include summary field
        app.id
    }

    var body: some View {
        VStack {
            Toggle("Show applications with existing accounts", isOn: $vm.showWithAccounts)
                .padding()

            if vm.isLoading {
                ProgressView("Loading applications…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(vm.applications) { app in
                    NavigationLink(destination: ApplicationDetailView(applicationID: app.id)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(title(for: app))
                                .font(.headline)
                            HStack(spacing: 12) {
                                BadgeView(label: "Lead", value: app.leadId != nil)
                                BadgeView(label: "Has Account", value: vm.accounts.contains { $0.applicationId == app.id })
                            }
                            if let created = app.created, let date = AppDateFormatter.shared.date(from: created) {
                                Text(date.formatted(.dateTime))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Applications")
        .onAppear { vm.fetch() }
    }
}

#Preview {
    ApplicationsListView()
}

// Reusable badge
private struct BadgeView: View {
    let label: String
    let value: Bool

    var body: some View {
        Text(label)
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(value ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
            .foregroundColor(value ? .green : .gray)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
