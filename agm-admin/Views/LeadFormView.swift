import SwiftUI

struct LeadFormView: View {
    var existingLead: Lead? = nil
    var onComplete: (() -> Void)? = nil

    @State private var users: [User] = []
    @State private var selectedContactIndex: Int? = nil
    @State private var selectedReferrerIndex: Int? = nil
    @State private var descriptionText: String = ""
    @State private var contactDate: Date = Date()
    @State private var closed: String = ""
    @State private var sent: String = ""

    @State private var isSaving = false
    @Environment(\.dismiss) private var dismiss

    private var isEdit: Bool { existingLead != nil }

    private var contactIndexBinding: Binding<Int> {
        Binding(
            get: { selectedContactIndex ?? 0 },
            set: { selectedContactIndex = $0 }
        )
    }
    
    private var referrerIndexBinding: Binding<Int> {
        Binding(
            get: { selectedReferrerIndex ?? 0 },
            set: { selectedReferrerIndex = $0 }
        )
    }

    var body: some View {
        Form {
            Section("Lead") {
                Picker("Contact", selection: contactIndexBinding) {
                    if users.isEmpty {
                        Text("Loading users...").tag(0)
                    } else {
                        ForEach(users.indices, id: \.self) { idx in
                            Text(users[idx].name ?? "No name").tag(idx)
                        }
                    }
                }
                .pickerStyle(.menu)
                Picker("Referrer", selection: referrerIndexBinding) {
                    if users.isEmpty {
                        Text("Loading users...").tag(0)
                    } else {
                        ForEach(users.indices, id: \.self) { idx in
                            Text(users[idx].name ?? "No name").tag(idx)
                        }
                    }
                }
                .pickerStyle(.menu)
                TextField("Description", text: $descriptionText)
                DatePicker("Contact Date", selection: $contactDate, displayedComponents: [.date, .hourAndMinute])
            }
        }
        .disabled(isSaving)
        .navigationTitle(isEdit ? "Edit Lead" : "New Lead")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isSaving {
                    ProgressView()
                } else {
                    Button("Save") { Task { await save() } }
                        .disabled(!isFormValid)
                }
            }
        }
        .onAppear {
            loadUsers()
            populateFields()
        }
    }

    private var isFormValid: Bool {
        selectedContactIndex != nil && !descriptionText.isEmpty
    }

    private func populateFields() {
        guard let l = existingLead else { return }
        descriptionText = l.description
        if let d = Self.dateFormatter.date(from: l.contactDate) {
            contactDate = d
        }
        if let cIdx = users.firstIndex(where: { $0.id == l.contactId }) {
            selectedContactIndex = cIdx
        }
        if let rIdx = users.firstIndex(where: { $0.id == l.referrerId }) {
            selectedReferrerIndex = rIdx
        }
        closed = l.closed ?? ""
        sent = l.sent ?? ""
    }

    private func payload() -> LeadPayload {
        LeadPayload(
            contactId: users[selectedContactIndex ?? 0].id,
            referrerId: users[selectedReferrerIndex ?? 0].id,
            description: descriptionText,
            contactDate: Self.dateFormatter.string(from: contactDate),
            closed: closed.isEmpty ? nil : closed,
            sent: sent.isEmpty ? nil : sent
        )
    }

    private func save() async {
        isSaving = true
        do {
            if let existing = existingLead {
                _ = try await LeadService.shared.updateLead(by: existing.id, lead: payload())
            } else {
                // For simplicity no followUps creation here
                _ = try await LeadService.shared.createLead(lead: payload(), followUps: [])
            }
            dismiss()
            onComplete?()
        } catch {
            print("Save failed: \(error)")
        }
        isSaving = false
    }

    // MARK: - Date Formatter

    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMddHHmmss"
        df.timeZone = .current
        return df
    }()

    // MARK: - Fetch Users

    private func loadUsers() {
        Task {
            do {
                let fetchedUsers = try await UserService.shared.readUsers()
                users = fetchedUsers.sorted {
                    ($0.name ?? "").localizedCaseInsensitiveCompare($1.name ?? "") == .orderedAscending
                }
                if selectedContactIndex == nil && !users.isEmpty {
                    selectedContactIndex = 0
                }
                if selectedReferrerIndex == nil && !users.isEmpty {
                    selectedReferrerIndex = 0
                }
            } catch {
                print("Failed to fetch users: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack { LeadFormView() }
}
