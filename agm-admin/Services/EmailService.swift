// MARK: - EmailService
import Foundation

actor EmailService {
    static let shared = EmailService()

    // MARK: - Generic helper
    private func postEmail<P: Encodable>(endpoint: String, body: P) async throws -> IDResponse {
        try await ApiClient.shared.post("/email/send_email/\(endpoint)", body: body, response: IDResponse.self)
    }

    // MARK: - Lead Reminder
    func sendLeadReminder(leadName: String, recipient: String) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let agm_user_email: String
            let content: Content
            struct Content: Encodable { let lead_name: String }
        }
        return try await postEmail(endpoint: "lead_reminder", body: RequestBody(agm_user_email: recipient, content: .init(lead_name: leadName)))
    }

    // MARK: - Task Reminder
    func sendTaskReminder(taskName: String, recipient: String) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let agm_user_email: String
            let content: Content
            struct Content: Encodable { let task_name: String }
        }
        return try await postEmail(endpoint: "task_reminder", body: RequestBody(agm_user_email: recipient, content: .init(task_name: taskName)))
    }

    // MARK: - Trade Ticket
    func sendTradeTicket(message: String, clientEmail: String) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let client_email: String
            let content: Content
            struct Content: Encodable { let message: String }
        }
        return try await postEmail(endpoint: "trade_ticket", body: RequestBody(client_email: clientEmail, content: .init(message: message)))
    }

    // MARK: - Application Link
    func sendApplicationLink(name: String, link: String, clientEmail: String, language: String) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let client_email: String
            let content: Content
            let lang: String
            struct Content: Encodable { let name: String; let application_link: String }
        }
        return try await postEmail(endpoint: "application_link", body: RequestBody(client_email: clientEmail, content: .init(name: name, application_link: link), lang: language))
    }

    // MARK: - Credentials
    func sendCredentials(username: String, password: String, clientEmail: String, language: String) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let client_email: String
            let content: Content
            let lang: String
            struct Content: Encodable { let username: String; let password: String }
        }
        return try await postEmail(endpoint: "credentials", body: RequestBody(client_email: clientEmail, content: .init(username: username, password: password), lang: language))
    }

    // MARK: - Transfer Instructions
    func sendTransferInstructions(accountNumber: String, clientName: String, clientEmail: String, language: String) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let client_email: String
            let content: Content
            let lang: String
            struct Content: Encodable { let account_number: String; let client_name: String }
        }
        return try await postEmail(endpoint: "transfer_instructions", body: RequestBody(client_email: clientEmail, content: .init(account_number: accountNumber, client_name: clientName), lang: language))
    }
}
