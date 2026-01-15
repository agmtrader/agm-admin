import Foundation

actor TradeRequestService {
    static let shared = TradeRequestService()

    func createTradeRequest(request: TradeRequestPayload) async throws -> IDResponse {
        try await ApiClient.shared.post("/trade_request/create", body: request, response: IDResponse.self)
    }

    func readTradeRequests() async throws -> [TradeRequest] {
        try await ApiClient.shared.get("/trade_request/read", response: [TradeRequest].self)
    }

    func readTradeRequest(by id: String) async throws -> TradeRequest? {
        let response: [TradeRequest] = try await ApiClient.shared.get("/trade_request/read?id=\(id)", response: [TradeRequest].self)
        return response.first
    }

    func updateTradeRequest(by id: String, request: TradeRequestPayload) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let id: String
            let trade_request: TradeRequestPayload
        }
        return try await ApiClient.shared.post("/trade_request/update", body: RequestBody(id: id, trade_request: request), response: IDResponse.self)
    }
}
