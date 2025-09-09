import Foundation

actor UserService {
    static let shared = UserService()

    func readUsers() async throws -> [User] {
        return try await ApiClient.shared.get("/users/read", response: [User].self)
    }
}
