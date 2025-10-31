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
                    GroupBox(content: {
                        VStack(alignment: .leading, spacing: 8) {
                            LabeledRow(label: "Name", value: advisor.name)
                            LabeledRow(label: "Code", value: String(advisor.code))
                            LabeledRow(label: "Agency", value: advisor.agency)
                            LabeledRow(label: "Hierarchy 1", value: advisor.hierarchy1)
                            LabeledRow(label: "Hierarchy 2", value: advisor.hierarchy2)
                            LabeledRow(label: "Contact ID", value: advisor.contactId ?? "-")
                        }
                    })
                    .padding()
                }
            } else {
                ContentUnavailableView("Advisor not found", image: "xmark.circle.fill", description: Text("The requested advisor could not be located."))
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
