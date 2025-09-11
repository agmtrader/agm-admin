// MARK: - Trade
/// Minimal trade representation used when generating trade tickets
struct Trade: Codable, Identifiable {
    let id: String // Use ExecID or TradeID from backend
    let description: String
    let assetClass: String
    let quantity: String
    let price: String
    let dateTime: String

    enum CodingKeys: String, CodingKey {
        case id = "TradeID" // back-end field name
        case description = "Description"
        case assetClass = "AssetClass"
        case quantity = "Quantity"
        case price = "Price"
        case dateTime = "Date/Time"
    }
}
