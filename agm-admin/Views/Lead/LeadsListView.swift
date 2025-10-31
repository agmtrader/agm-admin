import SwiftUI
import Combine

@MainActor
final class LeadsListViewModel: ObservableObject {
    @Published var leads: [Lead] = []
    @Published var followUps: [FollowUp] = []
    @Published var contacts: [Contact] = []
    @Published var isLoading: Bool = false
    @Published var showClosed: Bool = false {
        didSet { applyFilter() }
    }

    private var allLeads: [Lead] = []

    func fetchLeads() {
        isLoading = true
        Task {
            do {
                async let leadsRes = LeadService.shared.readLeads()
                async let contactsRes = ContactService.shared.readContacts()

                let ((fetchedLeads, fetchedFollowUps), fetchedContacts) = try await (leadsRes, contactsRes)

                self.followUps = fetchedFollowUps
                self.contacts = fetchedContacts
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
    @State private var isShowingForm: Bool = false

    private struct LeadSheetItem: Identifiable { let id: String }
    @State private var sheetItem: LeadSheetItem? = nil

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
                    Button {
                        sheetItem = LeadSheetItem(id: lead.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            // Contact Name
                            if let contact = vm.contacts.first(where: { $0.id == lead.contactId }) {
                                Text(contact.name ?? "No name")
                                    .font(.headline)
                            } else {
                                Text("No contact")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }

                            // Lead description
                            Text(lead.description)
                                .font(.subheadline)
                                .lineLimit(1)
                            
                            if let date = AppDateFormatter.shared.date(from: lead.contactDate) {
                                Text(date.formatted(.dateTime))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                            }
                            
                            HStack(spacing: 12) {
                                BadgeView(label: "Sent", value: lead.sent != nil)
                                BadgeView(label: "Closed", value: lead.closed != nil)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Leads")
        .onAppear { vm.fetchLeads() }
        .toolbar {
            Button {
                isShowingForm = true
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(item: $sheetItem) { item in
            LeadDetailView(leadID: item.id)
        }
        .sheet(isPresented: $isShowingForm) {
            LeadFormView(onComplete: {
                vm.fetchLeads()
                isShowingForm = false
            })
        }
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
