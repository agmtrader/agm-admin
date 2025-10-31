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
    private struct TicketSheetItem: Identifiable { let id: String; let title: String }
    @State private var sheetItem: TicketSheetItem? = nil

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Loading tickets…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(vm.tickets) { ticket in
                    Button {
                        sheetItem = TicketSheetItem(id: ticket.id, title: ticket.name)
                    } label: {
                        Text(ticket.name)
                    }
                    .buttonStyle(.plain)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Trade Tickets")
        .onAppear { vm.fetchTickets() }
        .sheet(item: $sheetItem) { item in
            TradeTicketTradesView(ticketID: item.id, title: item.title)
        }
        // no toolbar; read-only list
    }
}

#Preview {
    NavigationStack {
        TradeTicketsView()
    }
}
