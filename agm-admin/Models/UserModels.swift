import Foundation

// MARK: - User Payload (for create/update requests)
struct UserPayload: Codable {
    let name: String
    let email: String
    let phone: String?
    let country: String?
    let companyName: String?
    let password: String

    enum CodingKeys: String, CodingKey {
        case name, email, phone, country
        case companyName = "company_name"
        case password
    }
}

// MARK: - User (full entity returned by backend)
struct User: Codable, Identifiable {
    let id: String
    let name: String
    let email: String?
    let phone: String?
    let country: String?
    let companyName: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, country
        case companyName = "company_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
