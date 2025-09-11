import SwiftUI

struct UserDetailView: View {
    let userID: String
    @State private var user: User?
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let user {
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.name ?? "No name")
                            .font(.headline)
                        Text(user.email ?? "No email")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            } else {
                Text("User not found")
            }
        }
        .navigationTitle("User")
        .task { await fetch() }
    }

    private func fetch() async {
        do {
            let fetched = try await UserService.shared.readUsers()
            self.user = fetched.first { $0.id == userID }
        } catch {
            print("Failed fetch: \(error)")
        }
        isLoading = false
    }
}

#Preview {
    UserDetailView(userID: "demo")
}
