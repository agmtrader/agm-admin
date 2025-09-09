import SwiftUI

struct PendingTaskDetailView: View {
    let taskID: String
    @State private var task: PendingTask?
    @State private var followUps: [PendingTaskFollowUp] = []
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let task {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Description")
                            .font(.title3.bold())
                        Text(task.description)
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
