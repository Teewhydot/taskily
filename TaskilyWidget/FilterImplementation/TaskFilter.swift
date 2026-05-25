//
//  TaskFilter.swift
//  taskily
//
//  Created by Issa Abubakar on 23/05/2026.
//

import AppIntents

enum TaskFilter: String, CaseIterable, AppEnum {
    case active = "Active"
    case completed = "Completed"
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Filter"
    static var caseDisplayRepresentations: [TaskFilter: DisplayRepresentation] = [
        .active: "Active",
        .completed: "Completed"
    ]
}
