import SwiftUI

struct FollowUpFormView: View {
    let leadID: String
    var onComplete: (() -> Void)? = nil

    @State private var date: Date = Date()
    @State private var descriptionText: String = ""
    @State private var completed: Bool = false
    @State private var isSaving = false
    @Environment(\.dismiss) private var dismiss

    private var isFormValid: Bool {
        !descriptionText.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                TextField("Description", text: $descriptionText)
                Toggle("Completed", isOn: $completed)
            }
            .disabled(isSaving)
            .navigationTitle("New Follow-up")
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
        }
    }

    private func save() async {
        isSaving = true
        do {
            let payload = FollowUpPayload(
                leadId: leadID,
                date: AppDateFormatter.shared.string(from: date),
                description: descriptionText,
                completed: completed,
                emailsToNotify: []
            )
            _ = try await LeadService.shared.createFollowUp(for: leadID, followUp: payload)
            dismiss()
            onComplete?()
        } catch {
            print("Failed to save follow-up: \(error)")
        }
        isSaving = false
    }
}

#Preview {
    FollowUpFormView(leadID: "demo")
}
