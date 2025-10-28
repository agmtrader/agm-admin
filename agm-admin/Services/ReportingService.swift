import Foundation

actor ReportingService {
    static let shared = ReportingService()

    // MARK: - Endpoints
    func generateReports() async throws -> Bool {
        // Endpoint returns success? adapt if needed
        struct Response: Decodable { let ok: Bool }
        let _: Response = try await ApiClient.shared.get("/reporting/run", response: Response.self)
        return true
    }

    func readClientsReport() async throws -> [ClientReportRow] {
        return try await ApiClient.shared.get("/reporting/clients", response: [ClientReportRow].self)
    }

    func readNavReport() async throws -> [NavReportRow] {
        return try await ApiClient.shared.get("/reporting/nav", response: [NavReportRow].self)
    }

    func readClientFeesReport() async throws -> [String: Any] {
        // TODO – define model when needed
        struct Dummy: Decodable {}
        _ = try await ApiClient.shared.get("/reporting/client_fees", response: Dummy.self)
        return [:]
    }
}
