import Foundation
import Combine


// MARK: - Pending Task

struct PendingTaskPayload: Codable {
    let accountId: String
    let description: String
    let closed: String?
    let tags: [String]?
    let priority: Int
    let emailsToNotify: [String]?
    let date: String

    enum CodingKeys: String, CodingKey {
        case accountId = "account_id"
        case description
        case closed
        case tags
        case priority
        case emailsToNotify = "emails_to_notify"
        case date
    }
}

struct PendingTask: Codable, Identifiable {
    let id: String
    let accountId: String
    let description: String
    let closed: Bool?
    let tags: [String]?
    let priority: Int
    let emailsToNotify: [String]?
    let date: String
    let created: String
    let updated: String

    enum CodingKeys: String, CodingKey {
        case id
        case accountId = "account_id"
        case description
        case closed
        case tags
        case priority
        case emailsToNotify = "emails_to_notify"
        case date
        case created, updated
    }
}

// MARK: - Follow Up for Pending Task

struct PendingTaskFollowUpPayload: Codable {
    let pendingTaskId: String
    let date: String
    let description: String
    let completed: Bool

    enum CodingKeys: String, CodingKey {
        case pendingTaskId = "pending_task_id"
        case date
        case description
        case completed
    }
}

struct PendingTaskFollowUp: Codable, Identifiable {
    let id: String
    let pendingTaskId: String
    let date: String
    let description: String
    let completed: Bool
    let created: String
    let updated: String

    enum CodingKeys: String, CodingKey {
        case id
        case pendingTaskId = "pending_task_id"
        case date
        case description
        case completed
        case created, updated
    }
}
