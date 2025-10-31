import SwiftUI
import Combine

@MainActor
final class AdvisorsListViewModel: ObservableObject {
    @Published var advisors: [Advisor] = []
    @Published var isLoading: Bool = false

    func fetchAdvisors() {
        isLoading = true
        Task {
            do {
                let fetched = try await AdvisorService.shared.readAdvisors()
                self.advisors = fetched.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            } catch {
                print("Failed to fetch advisors: \(error)")
            }
            isLoading = false
        }
    }
}

struct AdvisorsListView: View {
    @StateObject private var vm = AdvisorsListViewModel()
    @State private var isShowingForm: Bool = false

    private struct AdvisorSheetItem: Identifiable { let id: String }
    @State private var sheetItem: AdvisorSheetItem? = nil

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Loading advisors…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(vm.advisors) { advisor in
                        Button {
                            sheetItem = AdvisorSheetItem(id: advisor.id)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(advisor.name)
                                    .font(.headline)
                                Text("Agency: \(advisor.agency)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Advisors")
        .onAppear { vm.fetchAdvisors() }
        .toolbar {
            Button {
                isShowingForm = true
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(item: $sheetItem) { item in
            AdvisorDetailView(advisorID: item.id)
        }
        .sheet(isPresented: $isShowingForm) {
            AdvisorFormView(onComplete: {
                vm.fetchAdvisors()
                isShowingForm = false
            })
        }
    }
}

#Preview {
    AdvisorsListView()
}
