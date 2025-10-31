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
                        GroupBox(content: {
                            VStack(alignment: .leading, spacing: 8) {
                                LabeledRow(label: "Name", value: user.name ?? "-")
                                LabeledRow(label: "Email", value: user.email ?? "-")
                            }
                        }, label: {
                            Text("User")
                        })
                    }
                    .padding()
                }
            } else {
                ContentUnavailableView("User not found", image: "xmark.circle.fill", description: Text("The requested user could not be located."))
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
