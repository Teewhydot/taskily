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
    @State private var showingAddTask = false

    let modelContainer = SharedModelContainer.shared

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("selectedTheme") var selectedTheme = "System"
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ContentView()
                    .modelContainer(modelContainer)
                    .onOpenURL { url in
                                       if url.scheme == "taskily" && url.host == "add" {
                                           showingAddTask = true
                                       }
                                   }
                                   .sheet(isPresented: $showingAddTask) {
                                       AddTaskView()
                                   }

                    .navigationDestination(for: TaskModel.self) { task in
                        TaskDetail(task: task)
                    }
                    .preferredColorScheme(
                        selectedTheme == "Light" ? .light: selectedTheme == "Dark" ? .dark : nil )
            }
        }

    }
    }
   

