import Foundation
// MARK: - AdvisorPayload
struct AdvisorPayload: Codable {
    let name: String
    let agency: String
    let hierarchy1: String
    let hierarchy2: String
    let code: Int
    let contactId: String

    enum CodingKeys: String, CodingKey {
        case name, agency, hierarchy1, hierarchy2, code
        case contactId = "contact_id"
    }
}

// MARK: - Advisor
struct Advisor: Codable, Identifiable {
    let id: String
    let name: String?
    let email: String?
    let agency: String?
    let hierarchy1: String?
    let hierarchy2: String?
    let code: Int?
    let contactId: String?
}
