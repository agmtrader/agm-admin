import SwiftUI

struct UserFormView: View {
    var existingUser: User? = nil
    var onComplete: (() -> Void)? = nil

    @State private var name: String = ""
    @State private var email: String = ""

    @State private var isSaving = false
    @Environment(\.dismiss) private var dismiss

    private var isEdit: Bool { existingUser != nil }

    var body: some View {
        Form {
            Section("User") {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
        }
        .disabled(isSaving)
        .navigationTitle(isEdit ? "Edit User" : "New User")
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
        guard let u = existingUser else { return }
        name = u.name ?? ""
        email = u.email ?? ""
    }

    private func payload() -> UserPayload {
        UserPayload(name: name, email: email)
    }

    private func save() async {
        isSaving = true
        do {
            if let existing = existingUser {
                _ = try await UserService.shared.updateUser(by: existing.id, user: payload())
            } else {
                _ = try await UserService.shared.createUser(user: payload())
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
    NavigationStack { UserFormView() }
}
