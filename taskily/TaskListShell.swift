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
            Tab("List",systemImage: "list.bullet") {}
            Tab("Feed",systemImage: "film.stack") {}
            Tab("Settings",systemImage: "gear") {}

        }
        .padding()
    }
}

#Preview {
    TaskListShell()
}
