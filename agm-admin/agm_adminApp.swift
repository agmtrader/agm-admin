//
//  agm_adminApp.swift
//  agm-admin
//
//  Created by Andrés on 4/9/2025.
//

import SwiftUI
import UserNotifications

@main
struct agm_adminApp: App {
    // Add shared notification manager
    @StateObject private var notificationManager = NotificationManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await handleAppLaunch()
                }
        }
    }

    // MARK: - App Launch Helpers
    @MainActor
    private func handleAppLaunch() async {
        // Request notification permission on first launch (or if not determined)
        let status = await notificationManager.requestAuthorization()
        guard status == .authorized else { return }
        await scheduleOpenItemsSummary()
    }

    private func scheduleOpenItemsSummary() async {
        do {
            // Fetch open leads
            let (leads, _) = try await LeadService.shared.readLeads()
            let openLeads = leads.filter { $0.closed == nil }

            // Fetch open pending tasks
            let (tasks, _) = try await PendingTaskService.shared.readTasks()
            let openTasks = tasks.filter { ($0.closed ?? false) == false }

            // Only send notification if there are open items
            guard !openLeads.isEmpty || !openTasks.isEmpty else { return }

            let bodyParts: [String] = [
                openLeads.isEmpty ? nil : "\(openLeads.count) open leads",
                openTasks.isEmpty ? nil : "\(openTasks.count) pending tasks"
            ].compactMap { $0 }
            let body = bodyParts.joined(separator: " and ")

            await notificationManager.sendNotification(
                title: "You have work to do!",
                body: body,
                after: 3 // show shortly after launch
            )
        } catch {
            print("Failed to schedule open items notification: \(error)")
        }
    }
}
