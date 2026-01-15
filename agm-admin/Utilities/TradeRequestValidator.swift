import Foundation

enum TradeRequestValidationError: LocalizedError {
    case missingSide
    case invalidQuantity
    case missingOrderType
    case missingTimeInForce

    var errorDescription: String? {
        switch self {
        case .missingSide:
            return "Select buy or sell."
        case .invalidQuantity:
            return "Enter a quantity greater than 0."
        case .missingOrderType:
            return "Select order type."
        case .missingTimeInForce:
            return "Select time in force."
        }
    }
}

enum TradeRequestValidator {
    private static let validSides: Set<String> = ["buy", "sell"]
    private static let validOrderTypes: Set<String> = ["stop", "limit"]
    private static let validTimeInForce: Set<String> = ["day", "gtc"]

    static func validate(_ payload: TradeRequestPayload) throws {
        guard validSides.contains(payload.side.lowercased()) else { throw TradeRequestValidationError.missingSide }
        guard payload.quantity > 0 else { throw TradeRequestValidationError.invalidQuantity }
        guard validOrderTypes.contains(payload.orderType.lowercased()) else { throw TradeRequestValidationError.missingOrderType }
        guard validTimeInForce.contains(payload.timeInForce.lowercased()) else { throw TradeRequestValidationError.missingTimeInForce }
    }
}
