import SwiftUI
import Combine

struct TradeRequestDetailView: View {
    let tradeRequestID: String
    @State private var tradeRequest: TradeRequest?
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let tradeRequest {
                ScrollView {
                    TradeRequestCardView(entity: tradeRequest)
                        .padding()
                }
            } else {
                ContentUnavailableView("Not found", image: "exclamationmark.triangle", description: Text("Unable to load this trade request."))
            }
        }
        .navigationTitle("Trade Request")
        .task { await fetch() }
        .toolbar {
            if let tradeRequest {
                NavigationLink("Edit", destination: TradeRequestFormView(existingEntity: tradeRequest, onComplete: { Task { await fetch() } }))
            }
        }
    }

    private func fetch() async {
        isLoading = true
        do {
            tradeRequest = try await TradeRequestService.shared.readTradeRequest(by: tradeRequestID)
        } catch {
            print("Failed to fetch trade request: \(error)")
        }
        isLoading = false
    }
}

#Preview {
    NavigationStack {
        TradeRequestDetailView(tradeRequestID: "demo")
    }
}
