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
                    NavigationLink("Contacts") {
                        ContactsListView()
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
