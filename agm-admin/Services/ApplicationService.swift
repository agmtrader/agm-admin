import Foundation

actor ApplicationService {
    static let shared = ApplicationService()

    func readApplications() async throws -> [Application] {
        return try await ApiClient.shared.get("/applications/read", response: [Application].self)
    }

    func readApplication(by id: String) async throws -> Application? {
        return try await ApiClient.shared.get("/applications/read?id=\(id)", response: Application?.self)
    }
}
