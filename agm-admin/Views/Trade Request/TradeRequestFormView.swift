import SwiftUI

struct TradeRequestFormView: View {
    var existingEntity: TradeRequest? = nil
    var onComplete: (() -> Void)? = nil

    @State private var side: String = "buy"
    @State private var quantity: Double = 0
    @State private var orderType: String = "limit"
    @State private var timeInForce: String = "day"

    @State private var isSaving = false
    @State private var errorMessage: String?
    @Environment(\.dismiss) private var dismiss

    private var isEdit: Bool { existingEntity != nil }

    var body: some View {
        Form {
            Section("Trade Request") {
                Picker("Side", selection: $side) {
                    Text("Buy").tag("buy")
                    Text("Sell").tag("sell")
                }
                .pickerStyle(.segmented)

                TextField("Quantity", value: $quantity, format: .number)
                    .keyboardType(.decimalPad)

                Picker("Order Type", selection: $orderType) {
                    Text("Limit").tag("limit")
                    Text("Stop").tag("stop")
                }
                .pickerStyle(.segmented)

                Picker("Time in Force", selection: $timeInForce) {
                    Text("Day").tag("day")
                    Text("GTC").tag("gtc")
                }
                .pickerStyle(.segmented)
            }
        }
        .disabled(isSaving)
        .navigationTitle(isEdit ? "Edit Trade Request" : "New Trade Request")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isSaving {
                    ProgressView()
                } else {
                    Button("Save") { Task { await save() } }
                        .disabled(!isFormValid)
                }
            }
        }
        .onAppear { populateFields() }
        .alert(
            "Unable to save",
            isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            ),
            actions: {
                Button("OK", role: .cancel) { errorMessage = nil }
            },
            message: {
                Text(errorMessage ?? "")
            }
        )
    }

    private var isFormValid: Bool {
        quantity > 0
    }

    private func populateFields() {
        guard let entity = existingEntity else { return }
        side = entity.side
        quantity = entity.quantity
        orderType = entity.orderType
        timeInForce = entity.timeInForce
    }

    private func payload() -> TradeRequestPayload {
        TradeRequestPayload(
            side: side,
            quantity: quantity,
            orderType: orderType,
            timeInForce: timeInForce
        )
    }

    private func save() async {
        isSaving = true
        errorMessage = nil
        do {
            let body = payload()
            try TradeRequestValidator.validate(body)
            if let existing = existingEntity {
                _ = try await TradeRequestService.shared.updateTradeRequest(by: existing.id, request: body)
            } else {
                _ = try await TradeRequestService.shared.createTradeRequest(request: body)
            }
            dismiss()
            onComplete?()
        } catch {
            errorMessage = error.localizedDescription
        }
        isSaving = false
    }
}

#Preview {
    NavigationStack { TradeRequestFormView() }
}
