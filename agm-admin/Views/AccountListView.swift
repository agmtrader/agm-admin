import SwiftUI
import Combine

@MainActor
final class AccountListViewModel: ObservableObject {
    @Published var accounts: [Account] = []
    @Published var isLoading = false

    func fetch() {
        isLoading = true
        Task {
            do {
                accounts = try await AccountService.shared.readAccounts()
            } catch {
                print("Failed fetch: \(error)")
            }
            isLoading = false
        }
    }
}

struct AccountListView: View {
    @StateObject private var vm = AccountListViewModel()

    var body: some View {
        VStack {
            if vm.isLoading {
                ProgressView("Loading…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(vm.accounts) { acc in
                    NavigationLink(destination: AccountDetailView(accountID: acc.id)) {
                        VStack(alignment: .leading) {
                            Text(acc.b2cAccountNumber ?? "Account # \(acc.id)")
                                .font(.headline)
                            if let code = acc.advisorCode {
                                Text("Advisor: \(code)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Accounts")
        .onAppear { vm.fetch() }
    }
}

#Preview {
    AccountListView()
}
