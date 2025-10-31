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
                    GroupBox(content: {
                        VStack(alignment: .leading, spacing: 8) {
                            LabeledRow(label: "Name", value: contact.name ?? "-")
                            LabeledRow(label: "Email", value: contact.email ?? "-")
                            LabeledRow(label: "Phone", value: contact.phone ?? "-")
                            LabeledRow(label: "Country", value: contact.country ?? "-")
                            LabeledRow(label: "Company", value: contact.companyName ?? "-")
                        }
                    })
                        .padding()
                }
            } else {
                ContentUnavailableView("Contact not found", image: "xmark.circle.fill", description: Text("The requested contact could not be located."))
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
