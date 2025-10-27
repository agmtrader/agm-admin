// MARK: - AccountPayload
/// Properties used when creating or updating an internal IBKR account
/// Mirrors `AccountPayload` defined in backend (see `/lib/entities/account.ts`)
struct AccountPayload: Codable {
    let ibkrAccountNumber: String?
    let ibkrUsername: String?
    let ibkrPassword: String?
    let temporalEmail: String?
    let temporalPassword: String?

    enum CodingKeys: String, CodingKey {
        case ibkrAccountNumber = "ibkr_account_number"
        case ibkrUsername = "ibkr_username"
        case ibkrPassword = "ibkr_password"
        case temporalEmail = "temporal_email"
        case temporalPassword = "temporal_password"
    }
}

// MARK: - Account
/// Read-only representation of an Internal Account returned by backend
/// Mirrors `InternalAccount` & `Base` in `/lib/entities/account.ts`
struct Account: Codable, Identifiable {
    // Base
    let id: String
    let created: String
    let updated: String

    // Core account fields
    let ibkrAccountNumber: String?
    let ibkrUsername: String?
    let ibkrPassword: String?
    let temporalEmail: String?
    let temporalPassword: String?

    // Extended details
    let applicationId: String?
    let feeTemplate: String?
    let masterAccount: String?
    let managementType: String?
    let advisorCode: Int?
    let contactId: String?

    enum CodingKeys: String, CodingKey {
        case id, created, updated
        case ibkrAccountNumber = "ibkr_account_number"
        case ibkrUsername = "ibkr_username"
        case ibkrPassword = "ibkr_password"
        case temporalEmail = "temporal_email"
        case temporalPassword = "temporal_password"
        case applicationId = "application_id"
        case feeTemplate = "fee_template"
        case masterAccount = "master_account"
        case managementType = "management_type"
        case advisorCode = "advisor_code"
        case contactId = "contact_id"
    }
}
