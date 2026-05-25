//
//  FilteredTaskilyWidget.swift
//  taskily
//
//  Created by Issa Abubakar on 23/05/2026.
//
import WidgetKit
import SwiftUI
import SwiftData
import AppIntents


struct FilteredTaskListEntry: TimelineEntry {
    let date: Date
    let tasks: [TaskModel]
    let filter: TaskFilter
}







@MainActor
struct FilteredTaskListProvider: AppIntentTimelineProvider {
    typealias Entry = FilteredTaskListEntry
    typealias Intent = SelectFilterIntent
    
    func placeholder(in context: Context) -> FilteredTaskListEntry {
        FilteredTaskListEntry(date: Date(), tasks: [], filter: .active)
    }
    
    func snapshot(for configuration: SelectFilterIntent, in context: Context) async -> FilteredTaskListEntry {
        return loadTasks(filter: configuration.filter ?? .active)
    }
    
    func timeline(for configuration: SelectFilterIntent, in context: Context) async -> Timeline<FilteredTaskListEntry> {
        let entry = loadTasks(filter: configuration.filter ?? .active)
        let refreshDate = Calendar.current.date(byAdding: .second, value: 5, to: Date())!
        return Timeline(entries: [entry], policy: .after(refreshDate))
    }
    
    private func loadTasks(filter: TaskFilter) -> FilteredTaskListEntry {
        let container = SharedModelContainer.shared
        let context = container.mainContext
        
        let predicate: Predicate<TaskModel>
        switch filter {
        case .active: predicate = #Predicate { !$0.isCompleted }
        case .completed: predicate = #Predicate { $0.isCompleted }
        }
        
        let descriptor = FetchDescriptor<TaskModel>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.dueDate)]
        )
        let tasks = (try? context.fetch(descriptor)) ?? []
        return FilteredTaskListEntry(date: Date(), tasks: Array(tasks.prefix(5)), filter: filter)
    }
}


struct FilteredTaskListView: View {
    var entry: FilteredTaskListEntry
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(entry.filter.rawValue) Tasks")
                .font(.headline)
                .padding(.bottom, 2)
            
            if entry.tasks.isEmpty {
                Text("No \(entry.filter.rawValue.lowercased()) tasks")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                ForEach(entry.tasks) { task in
                    HStack {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(task.isCompleted ? .green : .gray)
                        Text(task.title)
                            .lineLimit(1)
                        Spacer()
                    }
                    .padding(.vertical, 2)
                }
            }
        }
        .padding()
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}



struct FilterableTaskListWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: "FilterableTaskList",
            intent: SelectFilterIntent.self,
            provider: FilteredTaskListProvider()
        ) { entry in
            FilteredTaskListView(entry: entry)
        }
        .configurationDisplayName("Task List")
        .description("Show active or completed tasks.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}
