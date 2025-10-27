import SwiftUI
import Combine

@MainActor
final class AccountsListViewModel: ObservableObject {
    @Published var accounts: [Account] = []
    @Published var isLoading = false

    func fetch() {
        isLoading = true
        Task {
            do {
                let fetched = try await AccountService.shared.readAccounts()
                self.accounts = fetched.sorted { ($0.ibkrAccountNumber ?? "") < ($1.ibkrAccountNumber ?? "") }
            } catch {
                print("Failed to fetch accounts: \(error)")
            }
            isLoading = false
        }
    }
}

struct AccountsListView: View {
    @StateObject private var vm = AccountsListViewModel()

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Loading accounts…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(vm.accounts) { acc in
                        NavigationLink(destination: AccountDetailView(accountID: acc.id)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(acc.ibkrAccountNumber ?? "-")
                                    .font(.headline)
                                Text("Advisor: \(acc.advisorCode.map(String.init) ?? "-")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
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
    AccountsListView()
}
