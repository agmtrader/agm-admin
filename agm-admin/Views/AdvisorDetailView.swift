import SwiftUI

struct AdvisorDetailView: View {
    let advisorID: String
    @State private var advisor: Advisor?
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let advisor {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        AdvisorCardView(advisor: advisor)
                    }
                    .padding()
                }
            } else {
                Text("Advisor not found")
            }
        }
        .navigationTitle("Advisor")
        .task { await fetch() }
    }

    private func fetch() async {
        isLoading = true
        do {
            advisor = try await AdvisorService.shared.readAdvisor(by: advisorID)
        } catch {
            print("Failed fetch: \(error)")
        }
        isLoading = false
    }
}

#Preview {
    AdvisorDetailView(advisorID: "demo")
}
