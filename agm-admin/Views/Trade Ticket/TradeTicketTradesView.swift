import SwiftUI
import Combine


// MARK: - ViewModel
@MainActor
final class TradeTicketTradesViewModel: ObservableObject {
    @Published var trades: [Trade] = []
    @Published var isLoading = false

    func fetchTrades(ticketID: String) {
        isLoading = true
        Task {
            do {
                let fetched = try await TradeTicketService.shared.fetchTrades(for: ticketID)
                self.trades = fetched
            } catch {
                print("Failed to fetch trades: \(error)")
            }
            isLoading = false
        }
    }
}

// MARK: - TradeTicketTradesView
struct TradeTicketTradesView: View {
    let ticketID: String
    let title: String
    @StateObject private var vm = TradeTicketTradesViewModel()

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if vm.trades.isEmpty {
                ContentUnavailableView("No trades", image: "tray", description: Text("No trades available for this ticket."))
            } else {
                List(vm.trades) { trade in
                    VStack(alignment: .leading) {
                        Text(trade.description).font(.headline)
                        Text(trade.dateTime).font(.caption).foregroundColor(.secondary)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(title)
        .onAppear { vm.fetchTrades(ticketID: ticketID) }
    }
}

#Preview {
    NavigationStack {
        TradeTicketTradesView(ticketID: "demo", title: "Demo Ticket")
    }
}
