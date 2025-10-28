import Foundation

// MARK: - ClientReportRow
struct ClientReportRow: Codable, Identifiable {
    // Use accountID as unique identifier
    var id: String { accountID }

    let accountID: String        // "Account ID"
    let alias: String?           // "Alias" (empty -> nil)
    let status: String           // "Status"
    let sheetName: String        // "sheet_name"

    enum CodingKeys: String, CodingKey {
        case accountID = "Account ID"
        case alias = "Alias"
        case status = "Status"
        case sheetName = "sheet_name"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accountID = try container.decode(String.self, forKey: .accountID)
        let rawAlias = try container.decodeIfPresent(String.self, forKey: .alias)?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let a = rawAlias, !a.isEmpty {
            self.alias = a
        } else {
            self.alias = nil
        }
        self.status = try container.decode(String.self, forKey: .status)
        self.sheetName = try container.decode(String.self, forKey: .sheetName)
    }
}

// MARK: - NavReportRow
struct NavReportRow: Codable {
    let clientAccountID: String  // "ClientAccountID"
    let total: Decimal           // "Total"

    enum CodingKeys: String, CodingKey {
        case clientAccountID = "ClientAccountID"
        case total = "Total"
    }
}
