import Foundation
import Combine


actor TradeTicketService {
    static let shared = TradeTicketService()

    // MARK: - CRUD for Trade Tickets

    func createTradeTicket(ticket: TradeTicketPayload) async throws -> IDResponse {
        try await ApiClient.shared.post("/trade_tickets/create", body: ticket, response: IDResponse.self)
    }

    // MARK: - List
    func listTradeTickets() async throws -> [TradeTicket] {
        try await ApiClient.shared.get("/trade_tickets/list", response: [TradeTicket].self)
    }

    @available(*, deprecated, message: "Use listTradeTickets() instead – this hits /trade_tickets/list")
    func readTradeTickets() async throws -> [TradeTicket] { try await listTradeTickets() }

    func readTradeTicket(by id: String) async throws -> TradeTicket? {
        let res: [TradeTicket] = try await ApiClient.shared.get("/trade_tickets/read?id=\(id)", response: [TradeTicket].self)
        return res.first
    }

    func updateTradeTicket(by id: String, ticket: TradeTicketPayload) async throws -> IDResponse {
        struct RequestBody: Encodable { let id: String; let trade_ticket: TradeTicketPayload }
        return try await ApiClient.shared.post("/trade_tickets/update", body: RequestBody(id: id, trade_ticket: ticket), response: IDResponse.self)
    }

    // MARK: - Additional helpers

    func fetchTrades(for ticketID: String) async throws -> [Trade] {
        var trades: [Trade] = try await ApiClient.shared.get("/trade_tickets/read?query_id=\(ticketID)", response: [Trade].self)
        trades.sort { ($0.dateTime) > ($1.dateTime) }
        return trades
    }

    func confirmationMessage(allTrades: [Trade], selected: [Trade]) async throws -> String {
        // guard validations similar to TS version
        guard let firstSymbol = selected.first?.description else { throw ApiError.unknown(-1) }
        guard selected.allSatisfy({ $0.description == firstSymbol }) else { throw ApiError.unknown(-1) }

        // Map selected to indices within allTrades
        let indices = selected.compactMap { sel in
            allTrades.firstIndex(where: { $0.dateTime == sel.dateTime && $0.description == sel.description && $0.quantity == sel.quantity })
        }
        struct Body: Encodable {
            let flex_query_dict: [Trade]
            let indices: String
        }
        struct Response: Decodable { let message: String }
        let res: Response = try await ApiClient.shared.post("/trade_tickets/confirmation_message", body: Body(flex_query_dict: allTrades, indices: indices.map(String.init).joined(separator: ",")), response: Response.self)
        return res.message
    }
}
