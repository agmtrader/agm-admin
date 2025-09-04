import Foundation

actor AdvisorService {
    static let shared = AdvisorService()

    func createAdvisor(advisor: AdvisorPayload) async throws -> IDResponse {
        try await ApiClient.shared.post("/advisors/create", body: advisor, response: IDResponse.self)
    }

    func readAdvisors() async throws -> [Advisor] {
        try await ApiClient.shared.get("/advisors/read", response: [Advisor].self)
    }

    func readAdvisor(by id: String) async throws -> Advisor? {
        struct Response: Decodable { let advisor: [Advisor] }
        let res = try await ApiClient.shared.get("/advisors/read?id=\(id)", response: Response.self)
        return res.advisor.first
    }

    func updateAdvisor(by id: String, advisor: AdvisorPayload) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let query: Query
            let advisor: AdvisorPayload
            struct Query: Encodable { let id: String }
        }
        return try await ApiClient.shared.post("/advisors/update", body: RequestBody(query: .init(id: id), advisor: advisor), response: IDResponse.self)
    }
}
