// MARK: - TradeTicketPayload
struct TradeTicketPayload: Codable {
    let name: String
    // Add additional editable properties for a trade ticket here (e.g. description)
}

// MARK: - TradeTicket
struct TradeTicket: Codable, Identifiable {
    let id: String
    let name: String
    /// Backend flex query identifier used to retrieve trades belonging to this ticket
    let queryId: String?
    let createdAt: String?
    let updatedAt: String?
    // Same properties as backend “read” response

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case queryId = "query_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
