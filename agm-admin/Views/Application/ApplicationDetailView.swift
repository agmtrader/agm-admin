import SwiftUI

struct ApplicationDetailView: View {
    let applicationID: String
    @State private var application: Application?
    @State private var isLoading = true
    @Environment(\.openURL) private var openURL

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let application {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        GroupBox(content: {
                            VStack(alignment: .leading, spacing: 8) {
                                LabeledRow(label: "ID", value: application.id)
                                LabeledRow(label: "Status", value: application.status ?? "-")
                                LabeledRow(label: "Created", value: formattedDate(application.created))
                                LabeledRow(label: "Lead ID", value: application.leadId ?? "-")
                            }
                        }, label: {
                            Text("Metadata")
                        })

                        GroupBox(content: {
                            VStack(alignment: .leading, spacing: 8) {
                                LabeledRow(label: "Advisor Code", value: String(application.advisorCode ?? 0))
                                LabeledRow(label: "Master Account", value: application.masterAccount ?? "-")
                            }
                        }, label: {
                            Text("Associations")
                        })
                    }
                    .padding()
                }
            } else {
                ContentUnavailableView("Application not found", image: "xmark.circle.fill", description: Text("The requested application could not be located."))
            }
        }
        .navigationTitle("Application")
        .toolbar {
            if let application {
                Button("Open in Dashboard") {
                    openURL(URL(string: "https://dashboard.agmtechnology.com/applications/\(application.id)")!)
                }
            }
        }
        .task { await fetch() }
    }

    private func fetch() async {
        do {
            self.application = try await ApplicationService.shared.readApplication(by: applicationID)
        } catch {
            print("Failed to fetch application: \(error)")
        }
        isLoading = false
    }

    private func formattedDate(_ iso: String?) -> String {
        guard let iso, let date = AppDateFormatter.shared.date(from: iso) else { return "-" }
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df.string(from: date)
    }
}

#Preview {
    NavigationStack { ApplicationDetailView(applicationID: "demo") }
}

private struct LabeledRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .font(.subheadline.weight(.semibold))
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
