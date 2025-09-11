import Foundation

struct User: Codable, Identifiable {
    let id: String
    let name: String?
    let email: String?
}

// MARK: - UserPayload (for create / update)
struct UserPayload: Codable {
    let name: String
    let email: String
}
