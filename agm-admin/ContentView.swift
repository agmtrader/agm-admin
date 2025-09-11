//
//  ContentView.swift
//  agm-admin
//
//  Created by Andrés on 4/9/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                List {
                    NavigationLink("Users") {
                        UsersListView()
                    }
                    NavigationLink("Advisors") {
                        AdvisorsListView()
                    }
                    NavigationLink("Leads") {
                        LeadsListView()
                    }
                    NavigationLink("Applications") {
                        ApplicationsListView()
                    }
                    NavigationLink("Accounts") {
                        AccountsListView()
                    }
                }
                .listStyle(.insetGrouped)
            }
            .tabItem {
                Label("Users", systemImage: "person.2.fill")
            }
            NavigationStack {
                List {
                    NavigationLink("Pending Tasks") {
                        PendingTaskListView()
                    }
                    NavigationLink("Pending Aliases") {
                        ContentUnavailableView("Pending Aliases", image: "exclamationmark.triangle.fill", description: Text("Pending Aliases."))
                    }
                    NavigationLink("Trade Tickets") {
                        TradeTicketsView()
                    }
                    NavigationLink("Investment Proposals") {
                        ContentUnavailableView("Investment Proposals", image: "exclamationmark.triangle.fill", description: Text("Investment Proposals."))
                    }
                    NavigationLink("Risk Profiles") {
                        ContentUnavailableView("Risk Profiles", image: "exclamationmark.triangle.fill", description: Text("Risk Profiles."))
                    }

                }
                .listStyle(.insetGrouped)
            }
            .tabItem {
                Label("Reports", systemImage: "chart.bar.fill")
            }
        }
    }
}

#Preview {
    ContentView()
}
