// Lead, FollowUp and supporting models

import Foundation

// Shared base fields common to most backend entities
struct Base: Codable, Identifiable {
    let id: String
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Lead

struct LeadPayload: Codable {
    let contactId: String
    let referrerId: String
    let description: String
    let contactDate: String
    let closed: String?
    let sent: String?

    enum CodingKeys: String, CodingKey {
        case contactId = "contact_id"
        case referrerId = "referrer_id"
        case description
        case contactDate = "contact_date"
        case closed
        case sent
    }
}

struct Lead: Codable, Identifiable {
    let id: String
    let contactId: String
    let referrerId: String
    let description: String
    let contactDate: String
    let closed: String?
    let sent: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case contactId = "contact_id"
        case referrerId = "referrer_id"
        case description
        case contactDate = "contact_date"
        case closed
        case sent
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Follow Up

struct FollowUpPayload: Codable {
    let leadId: String
    let date: String
    let description: String
    let completed: Bool

    enum CodingKeys: String, CodingKey {
        case leadId = "lead_id"
        case date
        case description
        case completed
    }
}

struct FollowUp: Codable, Identifiable {
    let id: String
    let leadId: String
    let date: String
    let description: String
    let completed: Bool
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case leadId = "lead_id"
        case date
        case description
        case completed
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Generic Responses

struct IDResponse: Codable {
    let id: String
}
