//
//  TaskFilterIntent.swift
//  taskily
//
//  Created by Issa Abubakar on 23/05/2026.
//
import AppIntents

struct SelectFilterIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Filter Tasks"
    
    @Parameter(title: "Show")
    var filter: TaskFilter?
}
