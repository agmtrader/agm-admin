import SwiftUI
import Combine

struct LeadDetailView: View {
    let leadID: String
    @State private var lead: Lead?
    @State private var followUps: [FollowUp] = []
    @State private var isLoading = true
    @State private var contact: User?
    @State private var referrer: User?
    @State private var showingAddFollowUp = false

    // MARK: - Email helpers
    @State private var isEditingEmails = false
    @State private var emails: [String] = []
    @State private var users: [User] = []
    @State private var agmUsers: [User] = []
    @State private var showingAddEmailAlert = false
    @State private var newEmailText = ""

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
                        // MARK: - Emails to notify section
                        HStack {
                            Text("Emails to notify")
                                .font(.headline)
                            Spacer()
                            Button {
                                Task { await sendReminder(for: lead) }
                            } label: {
                                Image(systemName: "paperplane.fill")
                            }
                            .disabled((lead.emailsToNotify?.isEmpty ?? true))
                            if !isEditingEmails {
                                Button("Edit") { emails = lead.emailsToNotify ?? []; isEditingEmails = true }
                            }
                        }

                        if isEditingEmails {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(emails, id: \.self) { mail in
                                    HStack {
                                        Text(mail)
                                            .font(.subheadline)
                                        Spacer()
                                        Button(role: .destructive) { emails.removeAll(where: { $0 == mail }) } label: {
                                            Image(systemName: "xmark.circle.fill")
                                        }
                                    }
                                }
                                Button {
                                    showingAddEmailAlert = true
                                } label: {
                                    Label("Add email", systemImage: "plus")
                                }
                            }
                            .alert("Add Email", isPresented: $showingAddEmailAlert, actions: {
                                TextField("Email", text: $newEmailText)
                                Button("Add") {
                                    let candidate = newEmailText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                                    if !candidate.isEmpty && !emails.contains(candidate) { emails.append(candidate) }
                                    newEmailText = ""
                                }
                                Button("Cancel", role: .cancel) { newEmailText = "" }
                            })

                            HStack {
                                Button("Save") { Task { await saveEmails() } }
                                    .buttonStyle(.borderedProminent)
                                Button("Cancel", role: .cancel) { isEditingEmails = false }
                            }
                        } else {
                            if let list = lead.emailsToNotify, !list.isEmpty {
                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(list, id: \.self) { Text($0).font(.subheadline) }
                                }
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
                                HStack {
                                    Button {
                                        Task { await toggleComplete(for: f) }
                                    } label: {
                                        Image(systemName: f.completed ? "checkmark.square.fill" : "square")
                                    }
                                    if let date = AppDateFormatter.shared.date(from: f.date) {
                                        Text(date.formatted(date: .abbreviated, time: .shortened))
                                            .font(.headline)
                                    } else {
                                        Text(f.date)
                                            .font(.headline)
                                    }
                                    Spacer()
                                    Button(role: .destructive) {
                                        Task { await deleteFollowUp(f) }
                                    } label: {
                                        Image(systemName: "trash")
                                    }
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
                        Button(action: { showingAddFollowUp = true }) {
                            Image(systemName: "plus")
                        }
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

                self.users = fetched
                self.agmUsers = fetched.filter { ($0.email ?? "").contains("@agmtechnology.com") }
                self.emails = l.emailsToNotify ?? []
            }
        } catch {
            print("Failed fetch: \(error)")
        }
        isLoading = false
    }

    // MARK: - Email helpers

    private func saveEmails() async {
        guard let lead else { return }
        do {
            let payload = LeadPayload(
                contactId: lead.contactId,
                referrerId: lead.referrerId,
                description: lead.description,
                contactDate: lead.contactDate,
                closed: lead.closed,
                sent: lead.sent,
                emailsToNotify: emails,
                filled: lead.filled
            )
            _ = try await LeadService.shared.updateLead(by: lead.id, lead: payload)
            isEditingEmails = false
            await fetch() // refresh data
        } catch {
            print("Failed to update emails: \(error)")
        }
    }

    private func sendReminder(for lead: Lead?) async {
        guard let lead else { return }
        do {
            for mail in lead.emailsToNotify ?? [] {
                _ = try await EmailService.shared.sendLeadReminder(leadName: lead.description, recipient: mail)
            }
        } catch {
            print("Failed to send reminder: \(error)")
        }
    }

    // MARK: - Follow-up helpers

    private func toggleComplete(for followUp: FollowUp) async {
        guard let lead else { return }
        do {
            let payload = FollowUpPayload(
                leadId: lead.id,
                date: followUp.date,
                description: followUp.description,
                completed: !followUp.completed,
                emailsToNotify: followUp.emailsToNotify
            )
            _ = try await LeadService.shared.updateFollowUp(leadID: lead.id, followUpID: followUp.id, followUp: payload)
            // Refresh follow-ups list after successful update
            await fetch()

            // After refresh, check if all completed then mark lead closed
            if followUps.allSatisfy({ $0.completed }) && (self.lead?.closed == nil) {
                let now = AppDateFormatter.shared.string(from: Date())
                let payloadLead = LeadPayload(
                    contactId: lead.contactId,
                    referrerId: lead.referrerId,
                    description: lead.description,
                    contactDate: lead.contactDate,
                    closed: now,
                    sent: lead.sent,
                    emailsToNotify: lead.emailsToNotify,
                    filled: lead.filled
                )
                _ = try await LeadService.shared.updateLead(by: lead.id, lead: payloadLead)
                await fetch()
            }
        } catch {
            print("Failed to toggle: \(error)")
        }
    }

    private func deleteFollowUp(_ followUp: FollowUp) async {
        guard let lead else { return }
        do {
            _ = try await LeadService.shared.deleteFollowUp(leadID: lead.id, followUpID: followUp.id)
            await fetch()
        } catch {
            print("Failed delete: \(error)")
        }
    }
}

#Preview {
    LeadDetailView(leadID: "demo")
}
