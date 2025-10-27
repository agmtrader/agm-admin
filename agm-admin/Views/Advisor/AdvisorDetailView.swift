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
                        Text(advisor.name)
                            .font(.headline)
                        Text("Code: \(advisor.code)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
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
        do {
            let fetched = try await AdvisorService.shared.readAdvisors()
            self.advisor = fetched.first { $0.id == advisorID }
        } catch {
            print("Failed fetch: \(error)")
        }
        isLoading = false
    }
}

#Preview {
    AdvisorDetailView(advisorID: "demo")
}
