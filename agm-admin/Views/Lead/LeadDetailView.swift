import SwiftUI

struct LeadDetailView: View {
    let leadID: String
    @State private var lead: Lead?
    @State private var followUps: [FollowUp] = []
    @State private var isLoading = true
    @State private var contact: User?
    @State private var referrer: User?
    @State private var showingAddFollowUp = false

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let lead {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if let contact {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Contact")
                                    .font(.headline)
                                Text(contact.name ?? "No name")
                                    .font(.headline)
                                Text(contact.email ?? "No email")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        if let referrer {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Referrer")
                                    .font(.headline)
                                Text(referrer.name ?? "No name")
                                    .font(.headline)
                                Text(referrer.email ?? "No email")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Divider()
                        Text("Description")
                            .font(.headline)
                        Text(lead.description)
                            .font(.body)
                        Divider()
                        Text("Follow-ups")
                            .font(.headline)
                        ForEach(followUps) { f in
                            VStack(alignment: .leading) {
                                if let date = AppDateFormatter.shared.date(from: f.date) {
                                    Text(date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.headline)
                                } else {
                                    Text(f.date)
                                        .font(.headline)
                                }
                                Text(f.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        Button("Plus", systemImage: "plus") { showingAddFollowUp = true }
                            .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
            } else {
                Text("Lead not found")
            }
        }
        .navigationTitle("Lead")
        .task { await fetch() }
        .toolbar {
            if let lead {
                NavigationLink("Edit", destination: LeadFormView(existingLead: lead, onComplete: { Task { await fetch() } }))
            }
        }
        .sheet(isPresented: $showingAddFollowUp) {
            if let lead {
                FollowUpFormView(leadID: lead.id, onComplete: { Task { await fetch(); showingAddFollowUp = false } })
            }
        }
    }

    private func fetch() async {
        isLoading = true
        do {
            let (leads, followUps) = try await LeadService.shared.readLead(by: leadID)
            self.lead = leads.first
            self.followUps = followUps
            if let l = self.lead {
                async let users = UserService.shared.readUsers()
                let fetched = try await users
                self.contact = fetched.first(where: { $0.id == l.contactId })
                self.referrer = fetched.first(where: { $0.id == l.referrerId })
            }
        } catch {
            print("Failed fetch: \(error)")
        }
        isLoading = false
    }
}

#Preview {
    LeadDetailView(leadID: "demo")
}
