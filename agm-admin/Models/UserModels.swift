import Foundation

struct User: Codable, Identifiable {
    // Base
    let id: String
    let created: String
    let updated: String

    // Core profile
    let name: String?
    let email: String?
    let image: String?

    // Additional fields provided by backend session
    let phone: String?
    let country: String?
    let companyName: String?

    enum CodingKeys: String, CodingKey {
        case id, created, updated, name, email, image, phone, country
        case companyName = "company_name"
    }
}

// MARK: - UserPayload (for create / update)
struct UserPayload: Codable {
    let name: String
    let email: String
    let password: String
}
