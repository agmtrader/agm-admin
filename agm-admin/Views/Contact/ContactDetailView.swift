import SwiftUI

struct ContactDetailView: View {
    let contactID: String
    @State private var contact: Contact?
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let contact {
                ScrollView {
                    ContactCardView(contact: contact)
                        .padding()
                }
            } else {
                Text("Contact not found")
            }
        }
        .navigationTitle("Contact")
        .task { await fetch() }
    }

    private func fetch() async {
        do {
            let fetched = try await ContactService.shared.readContacts()
            self.contact = fetched.first { $0.id == contactID }
        } catch {
            print("Failed fetch: \(error)")
        }
        isLoading = false
    }
}

#Preview {
    ContactDetailView(contactID: "demo")
}
