import Combine

// MARK: - ApplicationPayload
struct ApplicationPayload: Codable {
    let advisorCode: Int?
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
    let advisorCode: Int?
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Base
        id = try container.decode(String.self, forKey: .id)
        created = try container.decode(String.self, forKey: .created)
        updated = try container.decode(String.self, forKey: .updated)
        advisorCode = try container.decodeIfPresent(Int.self, forKey: .advisorCode)

        masterAccount = try container.decodeIfPresent(String.self, forKey: .masterAccount)
        leadId = try container.decodeIfPresent(String.self, forKey: .leadId)
        application = try container.decodeIfPresent(String.self, forKey: .application)
        dateSentToIbkr = try container.decodeIfPresent(String.self, forKey: .dateSentToIbkr)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        contactId = try container.decodeIfPresent(String.self, forKey: .contactId)
    }
}
