import SwiftUI
import Combine

@MainActor
final class PendingTaskListViewModel: ObservableObject {
    @Published var tasks: [PendingTask] = []
    @Published var followUps: [PendingTaskFollowUp] = []
    @Published var isLoading: Bool = false
    @Published var showClosed: Bool = false {
        didSet { applyFilter() }
    }

    private var allTasks: [PendingTask] = []

    func fetchTasks() {
        isLoading = true
        Task {
            do {
                let (fetchedTasks, fetchedFollowUps) = try await PendingTaskService.shared.readTasks()
                self.followUps = fetchedFollowUps
                self.allTasks = fetchedTasks.sorted { $0.date > $1.date }
                self.applyFilter()
            } catch {
                print("Failed to fetch pending tasks: \(error)")
            }
            self.isLoading = false
        }
    }

    private func applyFilter() {
        if showClosed {
            tasks = allTasks
        } else {
            tasks = allTasks.filter { $0.closed == nil }
        }
    }
}

struct PendingTaskListView: View {
    @StateObject private var vm = PendingTaskListViewModel()

    var body: some View {
        VStack {
            Toggle("Show closed tasks", isOn: $vm.showClosed)
                .padding()

            if vm.isLoading {
                ProgressView("Loading tasks…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(vm.tasks) { task in
                    NavigationLink(destination: PendingTaskDetailView(taskID: task.id)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(task.description)
                                .font(.headline)
                                .lineLimit(1)
                            if let date = AppDateFormatter.shared.date(from: task.date) {
                            Text("\(task.date)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("\(task.date)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            HStack(spacing: 12) {
                                BadgeView(label: "Closed", value: task.closed != nil)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Pending Tasks")
        .onAppear { vm.fetchTasks() }
        .toolbar {
            NavigationLink(destination: PendingTaskFormView(onComplete: { vm.fetchTasks() })) {
                Image(systemName: "plus")
            }
        }
    }
}

#Preview {
    PendingTaskListView()
}

private struct BadgeView: View {
    let label: String
    let value: Bool

    var body: some View {
        Text(label)
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(value ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
            .foregroundColor(value ? .green : .gray)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
