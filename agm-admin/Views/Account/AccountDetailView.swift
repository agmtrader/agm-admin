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
                        GroupBox {
                            VStack(alignment: .leading, spacing: 8) {
                                LabeledRow(label: "IBKR Account", value: account.ibkrAccountNumber)
                                LabeledRow(label: "Username", value: account.ibkrUsername ?? "-")
                                LabeledRow(label: "Fee Template", value: account.feeTemplate ?? "-")
                                LabeledRow(label: "Application ID", value: account.applicationId ?? "")
                                LabeledRow(label: "User ID", value: account.userId ?? "-")
                            }
                        } label: { Text("Account") }
                    }
                    .padding()
                }
            } else {
                ContentUnavailableView("Account not found", image: "xmark.circle.fill", description: Text("The requested account could not be located."))
            }
        }
        .navigationTitle("Account")
        .task { await fetch() }
    }

    private func fetch() async {
        do {
            self.account = try await AccountService.shared.readAccount(by: accountID)
        } catch {
            print("Error fetching account: \(error)")
        }
        isLoading = false
    }
}

#Preview {
    NavigationStack { AccountDetailView(accountID: "demo") }
}

private struct LabeledRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label).font(.subheadline.weight(.semibold))
            Spacer()
            Text(value).font(.subheadline).foregroundColor(.secondary)
        }
    }
}
