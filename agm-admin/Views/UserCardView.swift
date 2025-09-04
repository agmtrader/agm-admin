import SwiftUI

struct UserCardView: View {
    let user: User
    var title: String? = nil

    private let gridItems: [GridItem] = Array(repeating: .init(.flexible(), spacing: 16), count: 2)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title ?? "Basic Information")
                .font(.headline)
            LazyVGrid(columns: gridItems, alignment: .leading, spacing: 12) {
                infoBlock(label: "Contact", value: user.name)
                infoBlock(label: "Email", value: user.email)
                infoBlock(label: "Phone", value: user.phone)
                infoBlock(label: "Country", value: user.country)
                infoBlock(label: "Company", value: user.companyName)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private func infoBlock(label: String, value: String?) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption.bold())
                .foregroundColor(.primary)
            Text(value ?? "-")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    UserCardView(user: User(id: "1", name: "John Doe", email: "john@doe.com", phone: "+1 555-555", country: "US", companyName: "Acme Inc", createdAt: nil, updatedAt: nil))
        .padding()
}
