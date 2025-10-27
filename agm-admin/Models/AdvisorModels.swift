import Foundation
// MARK: - AdvisorPayload
struct AdvisorPayload: Codable {
    let name: String
    let agency: String
    let hierarchy1: String
    let hierarchy2: String
    let contactId: String

    enum CodingKeys: String, CodingKey {
        case name, agency, hierarchy1, hierarchy2
        case contactId = "contact_id"
    }
}

// MARK: - Advisor
struct Advisor: Codable, Identifiable {
    // Base
    let id: String
    let created: String
    let updated: String

    // Advisor-specific fields
    let name: String
    let agency: String
    let hierarchy1: String
    let hierarchy2: String
    let code: Int
    let contactId: String?

    enum CodingKeys: String, CodingKey {
        case id, created, updated, name, agency, hierarchy1, hierarchy2, code
        case contactId = "contact_id"
    }
}
