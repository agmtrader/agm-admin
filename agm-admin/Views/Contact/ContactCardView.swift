import SwiftUI

struct ContactCardView: View {
    let contact: Contact

    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
            GridRow {
                Text("Name")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(contact.name ?? "-")
            }
            GridRow {
                Text("Email")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(contact.email ?? "-")
            }
            if let phone = contact.phone {
                GridRow {
                    Text("Phone")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(phone)
                }
            }
            if let country = contact.country {
                GridRow {
                    Text("Country")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(country)
                }
            }
            if let company = contact.companyName {
                GridRow {
                    Text("Company")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(company)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    ContactCardView(contact: Contact(id: "1", created: "", updated: "", name: "John Doe", email: "john@example.com", phone: "+1 555 555", image: nil, country: "USA", companyName: "ACME"))
}
