// MARK: - ContactService
import Foundation

actor ContactService {
    static let shared = ContactService()

    func readContacts() async throws -> [Contact] {
        return try await ApiClient.shared.get("/contacts/read", response: [Contact].self)
    }

    func createContact(contact: ContactPayload) async throws -> IDResponse {
        return try await ApiClient.shared.post("/contacts/create", body: contact, response: IDResponse.self)
    }

    func updateContact(by id: String, contact: ContactPayload) async throws -> IDResponse {
        struct UpdateBody: Encodable { let id: String; let contact: ContactPayload }
        return try await ApiClient.shared.post("/contacts/update", body: UpdateBody(id: id, contact: contact), response: IDResponse.self)
    }
}
