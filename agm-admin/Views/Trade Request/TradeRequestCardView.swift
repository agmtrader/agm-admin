import SwiftUI

struct TradeRequestCardView: View {
    let entity: TradeRequest

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            cardRow(label: "Side", value: entity.side.capitalized)
            cardRow(label: "Quantity", value: "\(entity.quantity)")
            cardRow(label: "Order Type", value: entity.orderType.capitalized)
            cardRow(label: "Time in Force", value: entity.timeInForce.uppercased())

            if let created = entity.created, !created.isEmpty {
                cardRow(label: "Created", value: created)
            }
            if let updated = entity.updated, !updated.isEmpty {
                cardRow(label: "Updated", value: updated)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func cardRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.body)
        }
    }
}

#Preview {
    TradeRequestCardView(entity: TradeRequest(id: "1", side: "buy", quantity: 100, orderType: "limit", timeInForce: "day", created: "2025-01-01", updated: "2025-01-02"))
        .padding()
}
