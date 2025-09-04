import SwiftUI

struct LeadDetailView: View {
    let leadID: String
    @State private var lead: Lead?
    @State private var followUps: [FollowUp] = []
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let lead {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Description")
                            .font(.title3.bold())
                        Text(lead.description)
                            .font(.body)
                        Divider()
                        Text("Follow-ups")
                            .font(.title3.bold())
                        ForEach(followUps) { f in
                            VStack(alignment: .leading) {
                                Text(f.date)
                                    .font(.caption)
                                Text(f.description)
                            }
                            .padding(8)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding()
                }
            } else {
                Text("Lead not found")
            }
        }
        .navigationTitle("Lead")
        .task { await fetch() }
    }

    private func fetch() async {
        isLoading = true
        do {
            let (leads, followUps) = try await LeadService.shared.readLead(by: leadID)
            self.lead = leads.first
            self.followUps = followUps
        } catch {
            print("Failed fetch: \(error)")
        }
        isLoading = false
    }
}

#Preview {
    LeadDetailView(leadID: "demo")
}
