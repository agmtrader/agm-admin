// MARK: - ContactPayload
/// Properties used when creating or updating a Contact
/// Mirrors `ContactPayload` defined in backend (see `/lib/entities/contact.ts`)
struct ContactPayload: Codable {
    let name: String
    let email: String
    let phone: String?
    let image: String?
    let country: String?
    let companyName: String?

    enum CodingKeys: String, CodingKey {
        case name, email, phone, image, country
        case companyName = "company_name"
    }
}

// MARK: - Contact
/// Read-only representation of a Contact returned by backend
/// Mirrors `Contact` & `Base` in `/lib/entities/contact.ts`
struct Contact: Codable, Identifiable {
    // Base
    let id: String
    let created: String
    let updated: String

    // Core profile
    let name: String?
    let email: String?
    let phone: String?
    let image: String?
    let country: String?
    let companyName: String?

    enum CodingKeys: String, CodingKey {
        case id, created, updated, name, email, phone, image, country
        case companyName = "company_name"
    }
}
