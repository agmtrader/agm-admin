import Foundation

// MARK: - Account Payload
struct AccountPayload: Codable {
    let b2cAccountNumber: String?
    let advisorCode: String?
    let userID: String?
    let applicationID: String?
    let temporalEmail: String?
    let temporalPassword: String?
    let b2xUsername: String?
    let b2xPassword: String?

    enum CodingKeys: String, CodingKey {
        case b2cAccountNumber = "b2c_account_number"
        case advisorCode = "advisor_code"
        case userID = "user_id"
        case applicationID = "application_id"
        case temporalEmail = "temporal_email"
        case temporalPassword = "temporal_password"
        case b2xUsername = "b2x_username"
        case b2xPassword = "b2x_password"
    }
}

// MARK: - Account entity
struct Account: Codable, Identifiable {
    let id: String
    let b2cAccountNumber: String?
    let advisorCode: String?
    let userID: String?
    let applicationID: String?
    let temporalEmail: String?
    let temporalPassword: String?
    let b2xUsername: String?
    let b2xPassword: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case b2cAccountNumber = "b2c_account_number"
        case advisorCode = "advisor_code"
        case userID = "user_id"
        case applicationID = "application_id"
        case temporalEmail = "temporal_email"
        case temporalPassword = "temporal_password"
        case b2xUsername = "b2x_username"
        case b2xPassword = "b2x_password"
        case createdAt = "created"
        case updatedAt = "updated"
    }
}
