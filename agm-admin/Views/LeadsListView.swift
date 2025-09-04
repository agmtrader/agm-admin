import SwiftUI
import Combine

@MainActor
final class LeadsListViewModel: ObservableObject {
    @Published var leads: [Lead] = []
    @Published var followUps: [FollowUp] = []
    @Published var isLoading: Bool = false
    @Published var showClosed: Bool = false {
        didSet { applyFilter() }
    }

    private var allLeads: [Lead] = []

    func fetchLeads() {
        isLoading = true
        Task {
            do {
                let (fetchedLeads, fetchedFollowUps) = try await LeadService.shared.readLeads()
                self.followUps = fetchedFollowUps
                self.allLeads = fetchedLeads.sorted { $0.contactDate > $1.contactDate }
                self.applyFilter()
            } catch {
                // TODO: proper error handling / toast
                print("Failed to fetch leads: \(error)")
            }
            self.isLoading = false
        }
    }

    private func applyFilter() {
        if showClosed {
            leads = allLeads
        } else {
            leads = allLeads.filter { $0.closed == nil }
        }
    }
}

struct LeadsListView: View {
    @StateObject private var vm = LeadsListViewModel()

    var body: some View {
        VStack {
            // Toggle for closed leads
            Toggle("Show closed leads", isOn: $vm.showClosed)
                .padding()

            if vm.isLoading {
                ProgressView("Loading leads…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(vm.leads) { lead in
                    NavigationLink(destination: LeadDetailView(leadID: lead.id)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(lead.description)
                                .font(.headline)
                                .lineLimit(1)
                            Text("Contact: \(lead.contactDate)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            HStack(spacing: 12) {
                                BadgeView(label: "Sent", value: lead.sent != nil)
                                BadgeView(label: "Closed", value: lead.closed != nil)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Leads")
        .onAppear { vm.fetchLeads() }
    }
}

#Preview {
    LeadsListView()
}

// Simple badge visual helper
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
