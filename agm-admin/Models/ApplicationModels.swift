import Combine

// MARK: - ApplicationPayload
struct ApplicationPayload: Codable {
    let advisorCode: String?
    let masterAccountId: String?
    let leadId: String?
    let userId: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case advisorCode = "advisor_code"
        case masterAccountId = "master_account_id"
        case leadId = "lead_id"
        case userId = "user_id"
        case status
    }
}

// MARK: - Application
struct Application: Codable, Identifiable {
    let id: String
    let advisorCode: String?
    let masterAccountId: String?
    let leadId: String?
    let userId: String?
    let status: String?
    let created: String?

    enum CodingKeys: String, CodingKey {
        case id
        case advisorCode = "advisor_code"
        case masterAccountId = "master_account_id"
        case leadId = "lead_id"
        case userId = "user_id"
        case status
        case created
    }
}
