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

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Loading users…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(vm.users) { user in
                    NavigationLink(destination: UserDetailView(userID: user.id)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.name ?? "No name")
                            .font(.headline)
                            Text(user.email ?? "No email")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Users")
        .onAppear { vm.fetchUsers() }
        .toolbar {
            NavigationLink(destination: UserFormView(onComplete: { vm.fetchUsers() })) {
                Image(systemName: "plus")
            }
        }
    }
}

#Preview {
    UsersListView()
}
