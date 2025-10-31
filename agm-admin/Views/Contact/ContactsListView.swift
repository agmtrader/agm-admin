import SwiftUI
import Combine

@MainActor
final class ContactsListViewModel: ObservableObject {
    @Published var contacts: [Contact] = []
    @Published var isLoading: Bool = false

    func fetchContacts() {
        isLoading = true
        Task {
            do {
                let fetched = try await ContactService.shared.readContacts()
                self.contacts = fetched.sorted { ($0.name ?? "") < ($1.name ?? "") }
            } catch {
                print("Failed to fetch contacts: \(error)")
            }
            isLoading = false
        }
    }
}

struct ContactsListView: View {
    @StateObject private var vm = ContactsListViewModel()
    @State private var isShowingForm: Bool = false

    private struct ContactSheetItem: Identifiable { let id: String }
    @State private var sheetItem: ContactSheetItem? = nil

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Loading contacts…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(vm.contacts) { contact in
                    Button {
                        sheetItem = ContactSheetItem(id: contact.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(contact.name ?? "No name")
                                .font(.headline)
                            Text(contact.email ?? "No email")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Contacts")
        .onAppear { vm.fetchContacts() }
        .toolbar {
            Button {
                isShowingForm = true
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(item: $sheetItem) { item in
            ContactDetailView(contactID: item.id)
        }
        .sheet(isPresented: $isShowingForm) {
            ContactFormView(onComplete: {
                vm.fetchContacts()
                isShowingForm = false
            })
        }
    }
}

#Preview {
    ContactsListView()
}
