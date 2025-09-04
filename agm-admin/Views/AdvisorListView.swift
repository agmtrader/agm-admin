import SwiftUI
import Combine

@MainActor
final class AdvisorListViewModel: ObservableObject {
    @Published var advisors: [Advisor] = []
    @Published var isLoading: Bool = false

    func fetch() {
        isLoading = true
        Task {
            do {
                advisors = try await AdvisorService.shared.readAdvisors().sorted { $0.name < $1.name }
            } catch {
                print("Failed to fetch advisors: \(error)")
            }
            isLoading = false
        }
    }
}

struct AdvisorListView: View {
    @StateObject private var vm = AdvisorListViewModel()

    var body: some View {
        VStack {
            if vm.isLoading {
                ProgressView("Loading…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(vm.advisors) { adv in
                    NavigationLink(destination: AdvisorDetailView(advisorID: adv.id)) {
                        VStack(alignment: .leading) {
                            Text(adv.name)
                                .font(.headline)
                            if let code = adv.code {
                                Text(code)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Advisors")
        .onAppear { vm.fetch() }
    }
}

#Preview {
    AdvisorListView()
}
