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
                    NavigationLink("Applications") {
                        ApplicationsListView()
                    }
                    NavigationLink("Accounts") {
                        AccountsListView()
                    }
                    NavigationLink("Trade Requests") {
                        TradeRequestsListView()
                    }
                }
                .listStyle(.insetGrouped)
            }
            .tabItem {
                Label("Users", systemImage: "person.2.fill")
            }
        }
    }
}

#Preview {
    ContentView()
}
