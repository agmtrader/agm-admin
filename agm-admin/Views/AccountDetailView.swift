import SwiftUI

struct AccountDetailView: View {
    let accountID: String
    @State private var account: Account?
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let account {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        AccountCardView(account: account)
                    }
                    .padding()
                }
            } else {
                Text("Account not found")
            }
        }
        .navigationTitle("Account")
        .task { await fetch() }
    }

    private func fetch() async {
        isLoading = true
        do {
            account = try await AccountService.shared.readAccount(by: accountID)
        } catch {
            print("Failed fetch: \(error)")
        }
        isLoading = false
    }
}

#Preview {
    AccountDetailView(accountID: "demo")
}
