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
                NavigationLink("Leads") {
                    LeadsListView()
                }
                NavigationLink("Pending Tasks") {
                    PendingTaskListView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
