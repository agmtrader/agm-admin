//
//  ContentView.swift
//  agm-admin
//
//  Created by Andrés on 4/9/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Users") {
                    UsersListView()
                }
                NavigationLink("Leads") {
                    LeadsListView()
                }
                NavigationLink("Advisors") {
                    AdvisorListView()
                }
                NavigationLink("Accounts") {
                    AccountListView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
