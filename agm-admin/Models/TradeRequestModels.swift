import Foundation

// MARK: - TradeRequestPayload
struct TradeRequestPayload: Codable {
    let side: String
    let quantity: Double
    let orderType: String
    let timeInForce: String

    enum CodingKeys: String, CodingKey {
        case side
        case quantity
        case orderType = "order_type"
        case timeInForce = "time_in_force"
    }
}

// MARK: - TradeRequest
struct TradeRequest: Codable, Identifiable {
    let id: String
    let side: String
    let quantity: Double
    let orderType: String
    let timeInForce: String
    let created: String?
    let updated: String?

    enum CodingKeys: String, CodingKey {
        case id
        case side
        case quantity
        case orderType = "order_type"
        case timeInForce = "time_in_force"
        case created
        case updated
    }
}
