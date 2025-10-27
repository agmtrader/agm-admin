import Combine

// MARK: - ApplicationPayload
struct ApplicationPayload: Codable {
    let advisorCode: String?
    let masterAccount: String?
    let leadId: String?
    let application: String? // JSON string or ID referencing full application
    let dateSentToIbkr: String?
    let status: String?
    let contactId: String?

    enum CodingKeys: String, CodingKey {
        case advisorCode = "advisor_code"
        case masterAccount = "master_account"
        case leadId = "lead_id"
        case application
        case dateSentToIbkr = "date_sent_to_ibkr"
        case status
        case contactId = "contact_id"
    }
}

// MARK: - Application
struct Application: Codable, Identifiable {
    // Base
    let id: String
    let created: String
    let updated: String

    // Application fields
    let advisorCode: String?
    let masterAccount: String?
    let leadId: String?
    let application: String?
    let dateSentToIbkr: String?
    let status: String?
    let contactId: String?

    enum CodingKeys: String, CodingKey {
        case id, created, updated
        case advisorCode = "advisor_code"
        case masterAccount = "master_account"
        case leadId = "lead_id"
        case application
        case dateSentToIbkr = "date_sent_to_ibkr"
        case status
        case contactId = "contact_id"
    }
}
