import Foundation

enum ApiError: Error, LocalizedError {
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case unknown(Int)
    case noSession
    case invalidToken
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .unauthorized: return "Unauthorized request."
        case .forbidden: return "Forbidden request."
        case .notFound: return "Resource not found."
        case .serverError: return "Server error occurred."
        case .unknown(let status): return "Unknown error with status code \(status)."
        case .noSession: return "No session found."
        case .invalidToken: return "Unable to retrieve authentication token."
        case .decoding(let err): return "Failed to decode response: \(err.localizedDescription)"
        }
    }
}

/// Generic API client mirroring the logic in digest.txt
actor ApiClient {
    static let shared = ApiClient()

    private let baseURL = URL(string: "https://api.agmtechnology.com")!

    private var cachedToken: String?
    private var tokenExpiry: Date?

    // MARK: - Public helpers

    func get<T: Decodable>(_ path: String, response: T.Type) async throws -> T {
        let token = try await getToken()
        // Build the request URL preserving query parameters (appendingPathComponent would percent-escape "?" and "=")
        guard let requestURL = URL(string: path, relativeTo: baseURL) else {
            throw ApiError.unknown(-1)
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return try await perform(request: request)
    }

    func post<T: Decodable, P: Encodable>(_ path: String, body: P?, response: T.Type) async throws -> T {
        let token = try await getToken()
        // Build the request URL preserving query parameters (appendingPathComponent would percent-escape "?" and "=")
        guard let requestURL = URL(string: path, relativeTo: baseURL) else {
            throw ApiError.unknown(-1)
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        return try await perform(request: request)
    }

    // MARK: - Token logic

    private func getToken() async throws -> String {
        // Reuse token if still valid (simple expiry guard of 5 minutes for demo)
        if let token = cachedToken, let expiry = tokenExpiry, expiry > Date() {
            return token
        }

        guard let sessionToken = await currentSessionToken() else {
            throw ApiError.noSession
        }

        struct TokenRequest: Encodable {
            let token: String
            let scopes: String
        }
        struct AuthResponse: Decodable { let access_token: String; let expires_in: Int }

        let requestURL = baseURL.appendingPathComponent("token")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.httpBody = try JSONEncoder().encode(TokenRequest(token: sessionToken, scopes: "all"))

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw ApiError.unknown(-1) }
        try handleStatus(http.statusCode)

        do {
            let auth = try JSONDecoder().decode(AuthResponse.self, from: data)
            cachedToken = auth.access_token
            tokenExpiry = Date().addingTimeInterval(TimeInterval(auth.expires_in))
            return auth.access_token
        } catch {
            throw ApiError.decoding(error)
        }
    }

    // Placeholder for your session management
    private func currentSessionToken() async -> String? {
        // TODO: Replace with secure storage or dynamic retrieval as needed.
        // Currently returning a hardcoded session token for development purposes.
        return "all"
    }

    // MARK: - Low-level perform

    private func perform<T: Decodable>(request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw ApiError.unknown(-1) }
        try handleStatus(http.statusCode)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw ApiError.decoding(error)
        }
    }

    private func handleStatus(_ status: Int) throws {
        switch status {
        case 200...299: return
        case 400: throw ApiError.unknown(status)
        case 401: throw ApiError.unauthorized
        case 403: throw ApiError.forbidden
        case 404: throw ApiError.notFound
        case 500: throw ApiError.serverError
        default: throw ApiError.unknown(status)
        }
    }
}
