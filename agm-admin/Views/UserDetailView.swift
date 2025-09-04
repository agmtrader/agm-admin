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
                    VStack(alignment: .leading, spacing: 16) {
                        UserCardView(user: user, title: "Basic Information")
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
        isLoading = true
        do {
            if let fetched = try await UserService.shared.readUser(by: userID) {
                self.user = fetched
            }
        } catch {
            print("Failed fetch: \(error)")
        }
        isLoading = false
    }
}

#Preview {
    UserDetailView(userID: "demo")
}
