import Foundation

actor AccountService {
    static let shared = AccountService()

    // MARK: - CRUD
    func readAccounts() async throws -> [Account] {
        return try await ApiClient.shared.get("/accounts/read", response: [Account].self)
    }

    func readAccount(by id: String) async throws -> Account? {
        return try await ApiClient.shared.get("/accounts/read?id=\(id)", response: [Account]?.self)?.first
    }

    func readAccounts(for userId: String) async throws -> [Account] {
        return try await ApiClient.shared.get("/accounts/read?user_id=\(userId)", response: [Account].self)
    }

    func createAccount(_ payload: AccountPayload) async throws -> IDResponse {
        struct Body: Encodable { let account: AccountPayload }
        return try await ApiClient.shared.post("/accounts/create", body: Body(account: payload), response: IDResponse.self)
    }

    func updateAccount(id: String, payload: AccountPayload) async throws -> IDResponse {
        struct Body: Encodable { let query: Query; let account: AccountPayload; struct Query: Encodable { let id: String } }
        return try await ApiClient.shared.post("/accounts/update", body: Body(query: .init(id: id), account: payload), response: IDResponse.self)
    }
}
