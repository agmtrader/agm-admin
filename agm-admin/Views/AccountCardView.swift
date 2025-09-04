import SwiftUI

struct AccountCardView: View {
    let account: Account

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Account Information")
                .font(.headline)
            info("B2C Account #", account.b2cAccountNumber)
            info("Advisor Code", account.advisorCode)
            info("User ID", account.userID)
            info("Application ID", account.applicationID)
            info("B2X Username", account.b2xUsername)
            info("B2X Password", account.b2xPassword)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private func info(_ label: String, _ value: String?) -> some View {
        HStack {
            Text(label).font(.caption.bold())
            Spacer()
            Text(value ?? "-")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    AccountCardView(account: Account(id: "1", b2cAccountNumber: "123", advisorCode: "A100", userID: "user1", applicationID: "app1", temporalEmail: nil, temporalPassword: nil, b2xUsername: "usr", b2xPassword: "pwd", createdAt: nil, updatedAt: nil))
        .padding()
}
