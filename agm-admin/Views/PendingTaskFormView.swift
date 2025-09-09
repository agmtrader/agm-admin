import SwiftUI

struct PendingTaskFormView: View {
    var existingTask: PendingTask? = nil
    var onComplete: (() -> Void)? = nil

    @State private var accountId: String = ""
    @State private var descriptionText: String = ""
    @State private var tagInput: String = ""
    @State private var tagList: [String] = []
    @State private var priority: Int = 1
    @State private var date: Date = Date()

    @State private var isSaving = false
    @Environment(\.dismiss) private var dismiss

    // Formatter for backend date string: yyyymmddhhmmss
    private static let formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMddHHmmss"
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()

    private var isEdit: Bool { existingTask != nil }

    var body: some View {
        Form {
            Section("Pending Task") {
                TextField("Account ID", text: $accountId)
                TextField("Description", text: $descriptionText)
                DatePicker("Date & Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                VStack(alignment: .leading, spacing: 8) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(tagList, id: \.self) { tag in
                                HStack(spacing: 4) {
                                    Text(tag)
                                        .font(.caption)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 8)
                                        .background(Capsule().fill(Color.gray.opacity(0.2)))
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                        .onTapGesture { removeTag(tag) }
                                }
                            }
                        }
                    }

                    HStack {
                        TextField("Add tag", text: $tagInput)
                            .textFieldStyle(.roundedBorder)
                            .onSubmit { addTag() }
                        Button("Add") { addTag() }
                            .disabled(tagInput.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
                Stepper(value: $priority, in: 1...3) {
                    Text("Priority: \(priority)")
                }
            }
        }
        .disabled(isSaving)
        .navigationTitle(isEdit ? "Edit Task" : "New Task")
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
        .onAppear { populateFields() }
    }

    private var isFormValid: Bool {
        !accountId.isEmpty && !descriptionText.isEmpty && (1...3).contains(priority)
    }

    private func populateFields() {
        guard let t = existingTask else { return }
        accountId = t.accountId
        descriptionText = t.description
        tagList = t.tags ?? []
        tagInput = ""
        priority = t.priority
        if let parsed = Self.formatter.date(from: t.date) {
            date = parsed
        }
    }

    private func payload() -> PendingTaskPayload {
        PendingTaskPayload(
            accountId: accountId,
            description: descriptionText,
            closed: nil,
            tags: tagList,
            priority: priority,
            emailsToNotify: nil,
            date: Self.formatter.string(from: date)
        )
    }

    private func save() async {
        isSaving = true
        do {
            if let existing = existingTask {
                _ = try await PendingTaskService.shared.updateTask(by: existing.id, task: payload())
            } else {
                _ = try await PendingTaskService.shared.createTask(task: payload(), followUps: [])
            }
            dismiss()
            onComplete?()
        } catch {
            print("Save failed: \(error)")
        }
        isSaving = false
    }

    private func addTag() {
        let trimmed = tagInput.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !tagList.contains(trimmed) else { return }
        tagList.append(trimmed)
        tagInput = ""
    }

    private func removeTag(_ tag: String) {
        tagList.removeAll { $0 == tag }
    }
}

#Preview {
    NavigationStack { PendingTaskFormView() }
}
