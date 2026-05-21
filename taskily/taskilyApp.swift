//
//  taskilyApp.swift
//  taskily
//
//  Created by Issa Abubakar on 08/05/2026.
//

import SwiftUI
import SwiftData

@main
struct taskilyApp: App {
    @AppStorage("selectedTheme") var selectedTheme = "System"
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ContentView()
                    .modelContainer(for: TaskModel.self)

                    .navigationDestination(for: TaskModel.self) { task in
                        TaskDetail(task: task)
                    }
                    .preferredColorScheme(
                        selectedTheme == "Light" ? .light: selectedTheme == "Dark" ? .dark : nil )
            }
        }

    }
    }
   

