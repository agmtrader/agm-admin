import SwiftUI
import Combine

@MainActor
final class AccountsListViewModel: ObservableObject {
    // MARK: - Nested types
    struct ExtendedAccount: Identifiable {
        let id: String
        let created: String
        let ibkrAccountNumber: String?
        let alias: String?
        let status: String
        let nav: Decimal
        let advisorCode: Int?
        let ibkrUsername: String?

        // Convenience helpers
        var advisorName: String? {
            guard let code = advisorCode else { return nil }
            return advisorLookup?[code]
        }
        fileprivate var advisorLookup: [Int: String]? = nil
    }

    enum AdvisorFilter: Hashable {
        case all
        case unassigned
        case advisor(Int)
    }

    // MARK: - Published properties
    @Published var filteredAccounts: [ExtendedAccount] = []
    @Published var isLoading: Bool = false
    @Published var showZeroNav: Bool = false { didSet { applyFilters() } }
    @Published var selectedAdvisor: AdvisorFilter = .all { didSet { applyFilters() } }

    // MARK: - Private state
    private var allAccounts: [ExtendedAccount] = []
    private var advisors: [Advisor] = []

    // MARK: - Fetch logic
    func fetch() {
        isLoading = true
        Task {
            do {
                async let accountsTask = AccountService.shared.readAccounts()
                async let clientsTask = ReportingService.shared.readClientsReport()
                async let navTask = ReportingService.shared.readNavReport()
                async let advisorsTask = AdvisorService.shared.readAdvisors()

                let (accounts, clientRows, navRows, advisors) = try await (accountsTask, clientsTask, navTask, advisorsTask)
                self.advisors = advisors
                let advisorNameDict = Dictionary(uniqueKeysWithValues: advisors.map { ($0.code, $0.name) })

                // Build lookup tables
                let clientLookup = Dictionary(uniqueKeysWithValues: clientRows.map { ($0.accountID, $0) })
                let navLookup = Dictionary(uniqueKeysWithValues: navRows.map { ($0.clientAccountID, $0.total) })

                // Enhance
                let enhanced = accounts.map { acc -> ExtendedAccount in
                    let c = clientLookup[acc.ibkrAccountNumber ?? ""]
                    let navVal = navLookup[acc.ibkrAccountNumber ?? ""] ?? 0
                    return ExtendedAccount(
                        id: acc.id,
                        created: acc.created,
                        ibkrAccountNumber: acc.ibkrAccountNumber,
                        alias: c?.alias ?? nil,
                        status: c?.status ?? "-",
                        nav: navVal,
                        advisorCode: acc.advisorCode,
                        ibkrUsername: acc.ibkrUsername,
                        advisorLookup: advisorNameDict
                    )
                }.sorted { $0.created > $1.created }

                self.allAccounts = enhanced
                applyFilters()
            } catch {
                print("Failed to fetch accounts: \(error)")
            }
            isLoading = false
        }
    }

    // MARK: - Filtering
    private func applyFilters() {
        filteredAccounts = allAccounts.filter { acc in
            // Zero NAV filter
            if showZeroNav {
                if acc.nav != 0 { return false }
            }
            // Advisor filter
            switch selectedAdvisor {
            case .all:
                return true
            case .unassigned:
                return acc.advisorCode == nil
            case .advisor(let code):
                return acc.advisorCode == code
            }
        }
    }

    // MARK: - Helper accessors
    func advisorOptions() -> [Advisor] { advisors }
}

// MARK: - View
struct AccountsListView: View {
    @StateObject private var vm = AccountsListViewModel()

    var body: some View {
        VStack {
            // Filters
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    Toggle("Show only accounts with 0 NAV", isOn: $vm.showZeroNav)
                        .toggleStyle(.switch)

                    // Advisor picker
                    Menu {
                        Button("All Advisors") { vm.selectedAdvisor = .all }
                        Button("Unassigned") { vm.selectedAdvisor = .unassigned }
                        Divider()
                        ForEach(vm.advisorOptions().sorted(by: { $0.name < $1.name })) { adv in
                            Button(adv.name) { vm.selectedAdvisor = .advisor(adv.code) }
                        }
                    } label: {
                        HStack {
                            Text(advisorFilterLabel())
                            Image(systemName: "chevron.down")
                        }
                    }
                }
                .padding([.horizontal, .top])
            }

            // Content
            Group {
                if vm.isLoading {
                    ProgressView("Loading accounts…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(vm.filteredAccounts) { acc in
                        NavigationLink(destination: AccountDetailView(accountID: acc.id)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(acc.alias ?? acc.ibkrAccountNumber ?? "-")
                                    .font(.headline)

                                Text("NAV: \(acc.nav as NSNumber, formatter: numberFormatter)")
                                    .font(.caption)
                                        .foregroundColor(.secondary)

                                Text(acc.status)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                if let name = acc.advisorName {
                                    Text("Advisor: \(name)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
        .navigationTitle("Accounts")
        .onAppear { vm.fetch() }
    }

    private func advisorFilterLabel() -> String {
        switch vm.selectedAdvisor {
        case .all: return "All Advisors"
        case .unassigned: return "Unassigned"
        case .advisor(let code):
            return vm.advisorOptions().first { $0.code == code }?.name ?? "Advisor"
        }
    }

    private var numberFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.maximumFractionDigits = 2
        return nf
    }
}

// MARK: - Preview
#Preview {
    NavigationStack { AccountsListView() }
}
