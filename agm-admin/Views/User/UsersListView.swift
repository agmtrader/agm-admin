import SwiftUI
import Combine

@MainActor
final class UsersListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false

    func fetchUsers() {
        isLoading = true
        Task {
            do {
                let fetched = try await UserService.shared.readUsers()
                self.users = fetched.sorted { ($0.name ?? "") < ($1.name ?? "") }
            } catch {
                print("Failed to fetch users: \(error)")
            }
            isLoading = false
        }
    }
}

struct UsersListView: View {
    @StateObject private var vm = UsersListViewModel()
    @State private var isShowingForm: Bool = false

    private struct UserSheetItem: Identifiable { let id: String }
    @State private var sheetItem: UserSheetItem? = nil

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Loading users…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(vm.users) { user in
                    Button {
                        sheetItem = UserSheetItem(id: user.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.name ?? "No name")
                            .font(.headline)
                            Text(user.email ?? "No email")
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
        .navigationTitle("Users")
        .onAppear { vm.fetchUsers() }
        .toolbar {
            Button {
                isShowingForm = true
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(item: $sheetItem) { item in
            UserDetailView(userID: item.id)
        }
        .sheet(isPresented: $isShowingForm) {
            UserFormView(onComplete: {
                vm.fetchUsers()
                isShowingForm = false
            })
        }
    }
}

#Preview {
    UsersListView()
}
