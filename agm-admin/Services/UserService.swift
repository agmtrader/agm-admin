import Foundation

actor UserService {
    static let shared = UserService()

    func readUsers() async throws -> [User] {
        return try await ApiClient.shared.get("/users/read", response: [User].self)
    }

    func createUser(user: UserPayload) async throws -> IDResponse {
        return try await ApiClient.shared.post("/users/create", body: user, response: IDResponse.self)
    }

    func updateUser(by id: String, user: UserPayload) async throws -> IDResponse {
        struct UpdateBody: Encodable { let id: String; let user: UserPayload }
        return try await ApiClient.shared.post("/users/update", body: UpdateBody(id: id, user: user), response: IDResponse.self)
    }
}
