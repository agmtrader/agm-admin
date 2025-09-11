import SwiftUI
import Combine

@MainActor
final class AdvisorsListViewModel: ObservableObject {
    @Published var advisors: [Advisor] = []
    @Published var isLoading: Bool = false

    func fetchAdvisors() {
        isLoading = true
        Task {
            do {
                let fetched = try await AdvisorService.shared.readAdvisors()
                self.advisors = fetched.sorted { ($0.name ?? "") < ($1.name ?? "") }
            } catch {
                print("Failed to fetch advisors: \(error)")
            }
            isLoading = false
        }
    }
}

struct AdvisorsListView: View {
    @StateObject private var vm = AdvisorsListViewModel()

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Loading advisors…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(vm.advisors) { advisor in
                    NavigationLink(destination: AdvisorDetailView(advisorID: advisor.id)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(advisor.name ?? "No name")
                                .font(.headline)
                            Text(advisor.email ?? "No email")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Advisors")
        .onAppear { vm.fetchAdvisors() }
        .toolbar {
            NavigationLink(destination: AdvisorFormView(onComplete: { vm.fetchAdvisors() })) {
                Image(systemName: "plus")
            }
        }
    }
}

#Preview {
    AdvisorsListView()
}
