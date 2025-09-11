import SwiftUI
import Combine

// MARK: - ViewModel
@MainActor
final class TradeTicketsViewModel: ObservableObject {
    @Published var tickets: [TradeTicket] = []
    @Published var isLoading = false

    func fetchTickets() {
        isLoading = true
        Task {
            do {
                let fetched = try await TradeTicketService.shared.listTradeTickets()
                self.tickets = fetched.sorted { $0.name < $1.name }
            } catch {
                print("Failed to fetch tickets: \(error)")
            }
            isLoading = false
        }
    }
}

// MARK: - TradeTicketsView
struct TradeTicketsView: View {
    @StateObject private var vm = TradeTicketsViewModel()

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Loading tickets…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(vm.tickets) { ticket in
                    NavigationLink(destination: TradeTicketTradesView(ticketID: ticket.id, title: ticket.name)) {
                        Text(ticket.name)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Trade Tickets")
        .onAppear { vm.fetchTickets() }
        // no toolbar; read-only list
    }
}

#Preview {
    NavigationStack {
        TradeTicketsView()
    }
}
