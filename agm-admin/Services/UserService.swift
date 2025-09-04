import Foundation

actor UserService {
    static let shared = UserService()

    func createUser(user: UserPayload) async throws -> IDResponse {
        return try await ApiClient.shared.post("/users/create", body: user, response: IDResponse.self)
    }

    func readUsers() async throws -> [User] {
        return try await ApiClient.shared.get("/users/read", response: [User].self)
    }

    func readUser(by id: String) async throws -> User? {
        struct Response: Decodable { let users: [User] }
        let res = try await ApiClient.shared.get("/users/read?id=\(id)", response: Response.self)
        return res.users.first
    }

    func updateUser(by id: String, user: UserPayload) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let query: Query
            let user: UserPayload
            struct Query: Encodable { let id: String }
        }
        return try await ApiClient.shared.post("/users/update", body: RequestBody(query: .init(id: id), user: user), response: IDResponse.self)
    }
}
