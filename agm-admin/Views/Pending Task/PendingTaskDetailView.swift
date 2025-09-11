import SwiftUI

struct PendingTaskDetailView: View {
    let taskID: String
    @State private var task: PendingTask?
    @State private var followUps: [PendingTaskFollowUp] = []
    @State private var isLoading = true
    @State private var showingAddFollowUp = false

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let task {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Description")
                            .font(.headline)
                        Text(task.description)
                            .font(.body)
                        Divider()
                        Text("Follow-ups")
                            .font(.headline)
                        ForEach(followUps) { f in
                            VStack(alignment: .leading) {
                                if let date = AppDateFormatter.shared.date(from: f.date) {
                                    Text(date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.headline)
                                } else {
                                    Text(f.date)
                                        .font(.headline)
                                }
                                Text(f.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        Button("Add Follow-up") { showingAddFollowUp = true }
                            .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
            } else {
                Text("Task not found")
            }
        }
        .navigationTitle("Task")
        .task { await fetch() }
        .toolbar {
            if let task {
                NavigationLink("Edit", destination: PendingTaskFormView(existingTask: task, onComplete: { Task { await fetch() } }))
            }
        }
        .sheet(isPresented: $showingAddFollowUp) {
            if let task {
                PendingTaskFollowUpFormView(taskID: task.id, onComplete: { Task { await fetch(); showingAddFollowUp = false } })
            }
        }
    }

    private func fetch() async {
        isLoading = true
        do {
            let (tasks, followUps) = try await PendingTaskService.shared.readTask(by: taskID)
            self.task = tasks.first
            self.followUps = followUps
        } catch {
            print("Failed fetch: \(error)")
        }
        isLoading = false
    }
}

#Preview {
    PendingTaskDetailView(taskID: "demo")
}
