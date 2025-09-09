import Foundation

actor PendingTaskService {
    static let shared = PendingTaskService()

    // MARK: - CRUD for Pending Tasks

    func createTask(task: PendingTaskPayload, followUps: [PendingTaskFollowUpPayload]) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let task: PendingTaskPayload
            let follow_ups: [PendingTaskFollowUpPayload]
        }
        return try await ApiClient.shared.post("/pending_tasks/create", body: RequestBody(task: task, follow_ups: followUps), response: IDResponse.self)
    }

    func readTasks() async throws -> (tasks: [PendingTask], followUps: [PendingTaskFollowUp]) {
        struct Response: Decodable {
            let pending_tasks: [PendingTask]
            let follow_ups: [PendingTaskFollowUp]
        }
        let res = try await ApiClient.shared.get("/pending_tasks/read", response: Response.self)
        return (res.pending_tasks, res.follow_ups)
    }

    func readTask(by id: String) async throws -> (tasks: [PendingTask], followUps: [PendingTaskFollowUp]) {
        struct Response: Decodable {
            let pending_tasks: [PendingTask]
            let follow_ups: [PendingTaskFollowUp]
        }
        let res = try await ApiClient.shared.get("/pending_tasks/read?id=\(id)", response: Response.self)
        return (res.pending_tasks, res.follow_ups)
    }

    func updateTask(by id: String, task: PendingTaskPayload) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let query: Query
            let task: PendingTaskPayload
            struct Query: Encodable { let id: String }
        }
        return try await ApiClient.shared.post("/pending_tasks/update", body: RequestBody(query: .init(id: id), task: task), response: IDResponse.self)
    }

    // MARK: - Follow Up helpers

    func createFollowUp(for taskID: String, followUp: PendingTaskFollowUpPayload) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let pending_task_id: String
            let follow_up: PendingTaskFollowUpPayload
        }
        return try await ApiClient.shared.post("/pending_tasks/follow_up/create", body: RequestBody(pending_task_id: taskID, follow_up: followUp), response: IDResponse.self)
    }

    func updateFollowUp(taskID: String, followUpID: String, followUp: PendingTaskFollowUpPayload) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let pending_task_id: String
            let follow_up_id: String
            let follow_up: PendingTaskFollowUpPayload
        }
        return try await ApiClient.shared.post("/pending_tasks/follow_up/update", body: RequestBody(pending_task_id: taskID, follow_up_id: followUpID, follow_up: followUp), response: IDResponse.self)
    }

    func deleteFollowUp(taskID: String, followUpID: String) async throws -> IDResponse {
        struct RequestBody: Encodable {
            let pending_task_id: String
            let follow_up_id: String
        }
        return try await ApiClient.shared.post("/pending_tasks/follow_up/delete", body: RequestBody(pending_task_id: taskID, follow_up_id: followUpID), response: IDResponse.self)
    }
}
