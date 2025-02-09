//
//  AgnosticSwiftDataApp.swift
//  AgnosticSwiftData
//
//  Created by Javier Calatrava on 7/1/25.
//

import SwiftUI

@main
struct AgnosticSwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                TaskListView()
                    .tabItem {
                    Label("SwiftData", systemImage: "list.dash")
                }
                    .modelContainer(for: [TaskDB.self])
                AgnosticTaskListView()
                    .tabItem {
                    Label("Agnostic", systemImage: "list.dash")
                }
            }
        }
    }
}
