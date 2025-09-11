// MARK: - AccountPayload
/// Properties used when creating or updating an internal IBKR account
struct AccountPayload: Codable {
    let ibkrAccountNumber: String?
    let ibkrUsername: String?
    let ibkrPassword: String?
    let temporalEmail: String?
    let temporalPassword: String?
    let applicationId: String?
    let feeTemplate: String?
    let userId: String?

    enum CodingKeys: String, CodingKey {
        case ibkrAccountNumber = "ibkr_account_number"
        case ibkrUsername = "ibkr_username"
        case ibkrPassword = "ibkr_password"
        case temporalEmail = "temporal_email"
        case temporalPassword = "temporal_password"
        case applicationId = "application_id"
        case feeTemplate = "fee_template"
        case userId = "user_id"
    }
}

// MARK: - Account
/// Read-only representation returned by backend
struct Account: Codable, Identifiable {
    let id: String
    let ibkrAccountNumber: String
    let ibkrUsername: String?
    let ibkrPassword: String?
    let temporalEmail: String?
    let temporalPassword: String?
    let applicationId: String?
    let feeTemplate: String?
    let userId: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case ibkrAccountNumber = "ibkr_account_number"
        case ibkrUsername = "ibkr_username"
        case ibkrPassword = "ibkr_password"
        case temporalEmail = "temporal_email"
        case temporalPassword = "temporal_password"
        case applicationId = "application_id"
        case feeTemplate = "fee_template"
        case userId = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
