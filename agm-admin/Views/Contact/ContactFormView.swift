import SwiftUI

struct ContactFormView: View {
    var existingContact: Contact? = nil
    var onComplete: (() -> Void)? = nil

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var country: String = ""
    @State private var companyName: String = ""

    @State private var isSaving = false
    @Environment(\.dismiss) private var dismiss

    private var isEdit: Bool { existingContact != nil }

    var body: some View {
        Form {
            Section("Contact") {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                TextField("Phone", text: $phone)
                TextField("Country", text: $country)
                TextField("Company", text: $companyName)
            }
        }
        .disabled(isSaving)
        .navigationTitle(isEdit ? "Edit Contact" : "New Contact")
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
        !name.isEmpty && !email.isEmpty && email.contains("@")
    }

    private func populateFields() {
        guard let c = existingContact else { return }
        name = c.name ?? ""
        email = c.email ?? ""
        phone = c.phone ?? ""
        country = c.country ?? ""
        companyName = c.companyName ?? ""
    }

    private func payload() -> ContactPayload {
        ContactPayload(
            name: name,
            email: email,
            phone: phone.isEmpty ? nil : phone,
            image: nil,
            country: country.isEmpty ? nil : country,
            companyName: companyName.isEmpty ? nil : companyName
        )
    }

    private func save() async {
        isSaving = true
        do {
            if let existing = existingContact {
                _ = try await ContactService.shared.updateContact(by: existing.id, contact: payload())
            } else {
                _ = try await ContactService.shared.createContact(contact: payload())
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
    NavigationStack { ContactFormView() }
}
