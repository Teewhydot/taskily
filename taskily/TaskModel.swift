//
//  TaskModel.swift
//  taskily
//
//  Created by Issa Abubakar on 08/05/2026.
//

import Foundation
import SwiftData

// Must be RawRepresentable and Codable for SwiftData
enum TaskPriority: String, Codable {
    case low
    case medium
    case high
}

@Model
final class TaskModel {
    var id: UUID
    var title: String
    var desc: String
    var dueDate: Date
    var postedDate: Date
    var isCompleted: Bool
    var taskPriority: TaskPriority
    
    // Designated initializer with all parameters
    init(id: UUID = UUID(),
         title: String,
         desc: String = "",
         dueDate: Date = Date(),
         postedDate: Date = Date(),
         isCompleted: Bool = false,
         taskPriority: TaskPriority = .medium) {
        self.id = id
        self.title = title
        self.desc = desc
        self.dueDate = dueDate
        self.postedDate = postedDate
        self.isCompleted = isCompleted
        self.taskPriority = taskPriority
    }
}
