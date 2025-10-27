// Lead, FollowUp and supporting models

import Foundation

// Shared base fields common to most backend entities (`Base` in TS)
struct Base: Codable, Identifiable {
    let id: String
    let created: String
    let updated: String

    enum CodingKeys: String, CodingKey {
        case id, created, updated
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
    let emailsToNotify: [String]?
    let filled: String?

    enum CodingKeys: String, CodingKey {
        case contactId = "contact_id"
        case referrerId = "referrer_id"
        case description
        case contactDate = "contact_date"
        case closed
        case sent
        case emailsToNotify = "emails_to_notify"
        case filled
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
    let emailsToNotify: [String]?
    let filled: String?
    let created: String
    let updated: String

    enum CodingKeys: String, CodingKey {
        case id
        case contactId = "contact_id"
        case referrerId = "referrer_id"
        case description
        case contactDate = "contact_date"
        case closed, sent
        case emailsToNotify = "emails_to_notify"
        case filled
        case created, updated
    }
}

// MARK: - Follow Up

struct FollowUpPayload: Codable {
    let leadId: String
    let date: String
    let description: String
    let completed: Bool
    let emailsToNotify: [String]?

    enum CodingKeys: String, CodingKey {
        case leadId = "lead_id"
        case date
        case description
        case completed
        case emailsToNotify = "emails_to_notify"
    }
}

struct FollowUp: Codable, Identifiable {
    let id: String
    let leadId: String
    let date: String
    let description: String
    let completed: Bool
    let emailsToNotify: [String]?
    let created: String
    let updated: String

    enum CodingKeys: String, CodingKey {
        case id
        case leadId = "lead_id"
        case date
        case description
        case completed
        case emailsToNotify = "emails_to_notify"
        case created, updated
    }
}
