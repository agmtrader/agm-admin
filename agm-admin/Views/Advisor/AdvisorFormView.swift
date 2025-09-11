import SwiftUI

struct AdvisorFormView: View {
    var existingAdvisor: Advisor? = nil
    var onComplete: (() -> Void)? = nil

    @State private var name: String = ""
    @State private var agency: String = ""
    @State private var hierarchy1: String = ""
    @State private var hierarchy2: String = ""
    @State private var code: String = ""
    @State private var contactId: String = ""

    @State private var isSaving = false
    @Environment(\.dismiss) private var dismiss

    private var isEdit: Bool { existingAdvisor != nil }

    var body: some View {
        Form {
            Section("Advisor") {
                TextField("Name", text: $name)
                TextField("Agency", text: $agency)
                TextField("Hierarchy 1", text: $hierarchy1)
                TextField("Hierarchy 2", text: $hierarchy2)
                TextField("Code", text: $code)
                TextField("Contact ID", text: $contactId)
            }
        }
        .disabled(isSaving)
        .navigationTitle(isEdit ? "Edit Advisor" : "New Advisor")
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
        .onAppear { populateFields() }
    }

    private var isFormValid: Bool {
        !name.isEmpty &&
        !agency.isEmpty &&
        !hierarchy1.isEmpty &&
        !hierarchy2.isEmpty &&
        Int(code) != nil &&
        !contactId.isEmpty
    }

    private func populateFields() {
        guard let a = existingAdvisor else { return }
        name = a.name ?? ""
        agency = a.agency ?? ""
        hierarchy1 = a.hierarchy1 ?? ""
        hierarchy2 = a.hierarchy2 ?? ""
        if let codeInt = a.code {
            code = String(codeInt)
        }
        contactId = a.contactId ?? ""
    }

    private func payload() -> AdvisorPayload {
        AdvisorPayload(name: name,
                       agency: agency,
                       hierarchy1: hierarchy1,
                       hierarchy2: hierarchy2,
                       code: Int(code) ?? 0,
                       contactId: contactId)
    }

    private func save() async {
        isSaving = true
        do {
            if let existing = existingAdvisor {
                _ = try await AdvisorService.shared.updateAdvisor(by: existing.id, advisor: payload())
            } else {
                _ = try await AdvisorService.shared.createAdvisor(advisor: payload())
            }
            dismiss()
            onComplete?()
        } catch {
            print("Save failed: \(error)")
        }
        isSaving = false
    }
}

#Preview {
    NavigationStack { AdvisorFormView() }
}
