import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

// MARK: - Timeline Entry
// One snapshot of data at a specific moment
struct SimpleEntry: TimelineEntry {
    let date: Date           // when this entry should be displayed
    let pendingCount: Int
    let nextTaskTitle: String
}
 

// MARK: - Timeline Provider
// Tells WidgetKit when to show what data


@MainActor   // ← add this
struct Provider: TimelineProvider {
    // 1. Placeholder: shown while the widget is loading (skeleton UI)
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), pendingCount: 3, nextTaskTitle: "Loading...")
    }

    // 2. Snapshot: used by Xcode preview and when the widget appears for an instant
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), pendingCount: 21, nextTaskTitle: "Buy milk and drink coffee")
        completion(entry)
    }

    // 3. Timeline: the heart of the widget – produces entries and tells when to refresh
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let container = SharedModelContainer.shared
               let context = container.mainContext
               
        let descriptor = FetchDescriptor<TaskModel>(sortBy: [SortDescriptor(\.postedDate)])
               let tasks = (try? context.fetch(descriptor)) ?? []
               
               let pendingTasks = tasks.filter { !$0.isCompleted }
               let nextTask = pendingTasks.first
               
               let entry = SimpleEntry(
                   date: Date(),
                   pendingCount: pendingTasks.count,
                   nextTaskTitle: nextTask?.title ?? "No tasks"
               )
        // Ask WidgetKit to refresh after every 10 minutes
        let nextRefresh = Calendar.current.date(byAdding: .second, value: 10, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
        completion(timeline)
    }
}

// MARK: - Widget View
struct TaskWidgetEntryView: View {
    var entry: SimpleEntry

    var body: some View {
     let content =  VStack(alignment: .leading, spacing: 6) {
            Text("Tasks")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("\(entry.pendingCount) pending")
                .font(.title)
                .bold()
            
            Text("Next: \(entry.nextTaskTitle)")
                .font(.caption)
                .lineLimit(1)
         Divider().padding(.bottom,10)
         Button(intent: AddTaskIntent()) {
             Label("Add Task", systemImage: "plus")
         }
         
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        
        if #available(iOS 17.0, macOS 14.0, *) {
            content.containerBackground(for: .widget){
                Color.clear
            }
        } else {
            content.background(Color.clear)
        }
    }
}

// MARK: - Widget Configuration
struct TaskilyWidget: Widget {
    let kind: String = "TaskilyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
          let base =  TaskWidgetEntryView(entry: entry)
            if #available(iOS 17.0, macOS 14.0, *) {
                base.containerBackground(for: .widget){
                    Color.clear
                }
            } else {
                base.background(Color.clear)
            }
        }
        .configurationDisplayName("Taskily Overview")
        .description("Shows your active tasks.")
        .supportedFamilies([.systemMedium, .systemLarge, .systemExtraLarge])
        
        #if os(iOS)
        .supportedFamilies([.systemSmall, .systemMedium])
        #elseif os(macOS)
        .supportedFamilies([.systemMedium, .systemLarge, .systemExtraLarge])
        #endif
    }
}



struct TaskListEntry: TimelineEntry {
    let date: Date
    let listOfTasks: [TaskModel]
}

@MainActor
struct TaskListProvider: TimelineProvider {
    func placeholder(in context: Context) -> TaskListEntry {
        TaskListEntry(date: Date(), listOfTasks: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TaskListEntry) -> Void) {
        let container = SharedModelContainer.shared
        let context = container.mainContext
        let descriptor = FetchDescriptor<TaskModel>(sortBy: [SortDescriptor(\.dueDate, order: .forward)])
        let tasks = (try? context.fetch(descriptor)) ?? []
        let entry = TaskListEntry(date: Date(), listOfTasks: Array(tasks.prefix(5)))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<TaskListEntry>) -> Void) {
        let container = SharedModelContainer.shared
        let context = container.mainContext
        let descriptor = FetchDescriptor<TaskModel>(sortBy: [SortDescriptor(\.dueDate, order: .forward)])
        let tasks = (try? context.fetch(descriptor)) ?? []
        let entry = TaskListEntry(date: Date(), listOfTasks: Array(tasks.prefix(5)))
        
        let refreshDate = Calendar.current.date(byAdding: .second, value: 10, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }
}


struct TaskListWidgetEntryView: View {
    var entry: TaskListEntry
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
                  Text("Tasks")
                      .font(.headline)
                      .padding(.bottom, 2)
                  
                  if entry.listOfTasks.isEmpty {
                      Text("No tasks")
                          .font(.subheadline)
                          .foregroundColor(.secondary)
                  } else {
                      ForEach(entry.listOfTasks) { task in
                          HStack {
                              Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                  .foregroundColor(task.isCompleted ? .green : .gray)
                              Text(task.title)
                                  .font(.body)
                                  .strikethrough(task.isCompleted)
                                  .lineLimit(1)
                              Spacer()
                              // Optional interactive toggle (needs AppIntent)
                              // Button(intent: ToggleTaskIntent(taskID: task.id.uuidString)) {
                              //     Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                              // }
                              // .buttonStyle(.plain)
                          }
                          .padding(.vertical, 2)
                      }
                  }
              }
              .padding()
              .containerBackground(for: .widget) {
                  Color(.systemBackground)
              }.padding()
    }
}

struct TaskListWidget: Widget {
    let kind: String = "TaskListWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TaskListProvider()) { entry in
            TaskListWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Task List")
        .description("Shows your upcoming tasks in a list.")
        .supportedFamilies([.systemMedium, .systemLarge])  // list works best in medium/large
    }
}
