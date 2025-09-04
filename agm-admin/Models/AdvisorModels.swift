import Foundation

// MARK: - Advisor Payload
struct AdvisorPayload: Codable {
    let name: String
    let contextID: String?
    let agency: String?
    let hierarchy2: String?
    let hierarchy1: String?
    let code: String?

    enum CodingKeys: String, CodingKey {
        case name
        case contextID = "context_id"
        case agency, hierarchy2, hierarchy1, code
    }
}

// MARK: - Advisor entity
struct Advisor: Codable, Identifiable {
    let id: String
    let name: String
    let contextID: String?
    let agency: String?
    let hierarchy2: String?
    let hierarchy1: String?
    let code: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case contextID = "context_id"
        case agency, hierarchy2, hierarchy1, code
        case createdAt = "created"
        case updatedAt = "updated"
    }

    // Custom init to tolerate numeric values for `code`
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.contextID = try container.decodeIfPresent(String.self, forKey: .contextID)
        self.agency = try container.decodeIfPresent(String.self, forKey: .agency)
        self.hierarchy2 = try container.decodeIfPresent(String.self, forKey: .hierarchy2)
        self.hierarchy1 = try container.decodeIfPresent(String.self, forKey: .hierarchy1)

        // Attempt to decode `code` as String first, fall back to Int
        if let stringCode = try? container.decode(String.self, forKey: .code) {
            self.code = stringCode
        } else if let intCode = try? container.decode(Int.self, forKey: .code) {
            self.code = String(intCode)
        } else {
            self.code = nil
        }

        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
    }

    // Explicit encode to preserve Codable conformance
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(contextID, forKey: .contextID)
        try container.encodeIfPresent(agency, forKey: .agency)
        try container.encodeIfPresent(hierarchy2, forKey: .hierarchy2)
        try container.encodeIfPresent(hierarchy1, forKey: .hierarchy1)
        try container.encodeIfPresent(code, forKey: .code)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }
}
