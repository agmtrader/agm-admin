import Foundation

actor AccountService {
    static let shared = AccountService()

    func createAccount(_ account: AccountPayload) async throws -> IDResponse {
        try await ApiClient.shared.post("/accounts/create", body: account, response: IDResponse.self)
    }

    func readAccounts() async throws -> [Account] {
        try await ApiClient.shared.get("/accounts/read", response: [Account].self)
    }

    func readAccount(by id: String) async throws -> Account? {
        struct Response: Decodable { let account: [Account] }
        let res = try await ApiClient.shared.get("/accounts/read?id=\(id)", response: Response.self)
        return res.account.first
    }

    func updateAccount(id: String, account: AccountPayload) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let query: Query
            let account: AccountPayload
            struct Query: Encodable { let id: String }
        }
        return try await ApiClient.shared.post("/accounts/update", body: RequestBody(query: .init(id: id), account: account), response: IDResponse.self)
    }
}
