import SwiftUI
import Combine

@MainActor
final class TradeRequestsListViewModel: ObservableObject {
    @Published var tradeRequests: [TradeRequest] = []
    @Published var isLoading: Bool = false

    func fetchTradeRequests() async {
        isLoading = true
        do {
            let fetched = try await TradeRequestService.shared.readTradeRequests()
            tradeRequests = fetched.sorted { $0.created ?? "" > $1.created ?? "" }
        } catch {
            print("Failed to fetch trade requests: \(error)")
        }
        isLoading = false
    }
}

struct TradeRequestsListView: View {
    @StateObject private var vm = TradeRequestsListViewModel()

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Loading trade requests…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if vm.tradeRequests.isEmpty {
                ContentUnavailableView("No trade requests", image: "tray", description: Text("There are no trade requests yet."))
            } else {
                List(vm.tradeRequests) { request in
                    NavigationLink(destination: TradeRequestDetailView(tradeRequestID: request.id)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(request.side.capitalized)
                                .font(.headline)
                            Text("\(request.quantity) • \(request.orderType.capitalized) • \(request.timeInForce.uppercased())")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Trade Requests")
        .task { await vm.fetchTradeRequests() }
        .toolbar {
            NavigationLink {
                TradeRequestFormView(onComplete: { Task { await vm.fetchTradeRequests() } })
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

#Preview {
    NavigationStack { TradeRequestsListView() }
}
