import Foundation

actor AdvisorService {
    static let shared = AdvisorService()

    func readAdvisors() async throws -> [Advisor] {
        return try await ApiClient.shared.get("/advisors/read", response: [Advisor].self)
    }

    func createAdvisor(advisor: AdvisorPayload) async throws -> IDResponse {
        return try await ApiClient.shared.post("/advisors/create", body: advisor, response: IDResponse.self)
    }

    func updateAdvisor(by id: String, advisor: AdvisorPayload) async throws -> IDResponse {
        struct UpdateBody: Encodable { let id: String; let advisor: AdvisorPayload }
        return try await ApiClient.shared.post("/advisors/update", body: UpdateBody(id: id, advisor: advisor), response: IDResponse.self)
    }
}
