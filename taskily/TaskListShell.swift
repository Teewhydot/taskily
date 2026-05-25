//
//  TaskListHome.swift
//  taskily
//
//  Created by Issa Abubakar on 08/05/2026.
//

import SwiftUI

struct TaskListShell: View {
    var body: some View {
        TabView {
            Tab("List",systemImage: "list.bullet") {
                TaskList()
            }
    
          
            Tab("Settings",systemImage: "gear") {
                SettingsView()
            }
        }
    }
}

#Preview {
    TaskListShell()
}
