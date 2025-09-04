import Foundation

actor LeadService {
    static let shared = LeadService()

    // MARK: - CRUD for Leads

    func createLead(lead: LeadPayload, followUps: [FollowUpPayload]) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let lead: LeadPayload
            let follow_ups: [FollowUpPayload]
        }
        return try await ApiClient.shared.post("/leads/create", body: RequestBody(lead: lead, follow_ups: followUps), response: IDResponse.self)
    }

    func readLeads() async throws -> (leads: [Lead], followUps: [FollowUp]) {
        struct Response: Decodable {
            let leads: [Lead]
            let follow_ups: [FollowUp]
        }
        let res = try await ApiClient.shared.get("/leads/read", response: Response.self)
        return (res.leads, res.follow_ups)
    }

    func readLead(by id: String) async throws -> (leads: [Lead], followUps: [FollowUp]) {
        struct Response: Decodable {
            let leads: [Lead]
            let follow_ups: [FollowUp]
        }
        let res = try await ApiClient.shared.get("/leads/read?id=\(id)", response: Response.self)
        return (res.leads, res.follow_ups)
    }

    func updateLead(by id: String, lead: LeadPayload) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let query: Query
            let lead: LeadPayload
            struct Query: Encodable { let id: String }
        }
        return try await ApiClient.shared.post("/leads/update", body: RequestBody(query: .init(id: id), lead: lead), response: IDResponse.self)
    }

    // MARK: - Follow Up helpers

    func createFollowUp(for leadID: String, followUp: FollowUpPayload) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let lead_id: String
            let follow_up: FollowUpPayload
        }
        return try await ApiClient.shared.post("/leads/follow_up/create", body: RequestBody(lead_id: leadID, follow_up: followUp), response: IDResponse.self)
    }

    func updateFollowUp(leadID: String, followUpID: String, followUp: FollowUpPayload) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let lead_id: String
            let follow_up_id: String
            let follow_up: FollowUpPayload
        }
        return try await ApiClient.shared.post("/leads/follow_up/update", body: RequestBody(lead_id: leadID, follow_up_id: followUpID, follow_up: followUp), response: IDResponse.self)
    }

    func deleteFollowUp(leadID: String, followUpID: String) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let lead_id: String
            let follow_up_id: String
        }
        return try await ApiClient.shared.post("/leads/follow_up/delete", body: RequestBody(lead_id: leadID, follow_up_id: followUpID), response: IDResponse.self)
    }
}
