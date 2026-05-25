//
//  TaskDetail.swift
//  taskily
//
//  Created by Issa Abubakar on 09/05/2026.
//

import SwiftUI
import SwiftData

struct TaskDetail: View {
    @Bindable var task: TaskModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // No need for local selectedDate or selectedPriority
    
    private func toggleCompletion() {
        task.isCompleted.toggle()
        try? modelContext.save()
    }
    
    private func deleteTask() {
        // Use the task's own context if available
        if let ownContext = task.modelContext, !task.isDeleted {
            ownContext.delete(task)
            try? ownContext.save()
            dismiss()
            return
        }
        
        // Fallback: use environment context and re-fetch by ID
        let id = task.id
        let predicate = #Predicate<TaskModel> { $0.id == id }
        let descriptor = FetchDescriptor(predicate: predicate)
        guard let managedTask = try? modelContext.fetch(descriptor).first else {
            print("Could not find task to delete")
            return
        }
        modelContext.delete(managedTask)
        try? modelContext.save()
        dismiss()
    }
    
    // Helper row builder (unchanged, but works with any suffix)
    private func AddTaskRow<Trailing: View>(icon: String, leadingColor: Color, title: String, @ViewBuilder suffixWidget: () -> Trailing) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .padding(5)
                .frame(width: 30, height: 30)
                .font(.system(size: 15))
                .background(leadingColor)
                .cornerRadius(8)
            Text(title)
            Spacer()
            suffixWidget()
        }
        .padding(8)
    }
    
    var body: some View {
        VStack {
            // Custom header with back button
            HStack {
                HStack {
                    Image(systemName: "arrowshape.turn.up.left")
                    Text("Tasks").foregroundStyle(.test)
                }
                .onTapGesture {
                    dismiss()
                }
                Spacer()
                Text("Edit").foregroundStyle(.test)
            }
            .padding()
            .padding(.bottom, 30)
            .navigationBarBackButtonHidden(true)  // hide default back button
            
            Text(task.title).font(.largeTitle)
                .padding(.bottom, 30)
            
            // Mark as Completed button
            HStack {
                Image(systemName: task.isCompleted ? "circle.fill" : "circle")
                    .foregroundStyle(task.isCompleted ? .green: .primary)
                Text(task.isCompleted ? "Completed" : "Mark as Completed")
                Spacer()
            }
            .padding(10)
            .background(.gray)
            .cornerRadius(10)
            .padding()
            .onTapGesture {
                toggleCompletion()
            }
            
            // Description
            VStack(alignment: .leading) {
                Text("Description").font(.headline).foregroundStyle(.secondary)
                Text(task.desc)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(.gray)
            .cornerRadius(10)
            .padding()
            
            // Due Date & Priority rows
            VStack(alignment: .leading) {
                AddTaskRow(icon: "calendar.circle", leadingColor: .accentColor, title: "Due Date") {
                    DatePicker("", selection: $task.dueDate, displayedComponents: .date)
                        .labelsHidden()
                }
                
                AddTaskRow(icon: "flag", leadingColor: .accentColor, title: "Priority") {
                    Picker("Priority", selection: $task.taskPriority) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                            Text(priority.rawValue.capitalized).tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 150)  // adjust as needed
                }
            }
            .padding(0)
            .frame(maxWidth: .infinity)
            .background(.gray)
            .cornerRadius(10)
            .padding()
            .padding(.bottom, 30)
            
            // Delete button
            Button("Delete Task", role: .destructive) {
                deleteTask()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.button)
            .cornerRadius(10)
            .padding()
            
            Spacer()
        }
    }
}

// Make sure your TaskPriority enum in TaskModel.swift has CaseIterable
// Add this line if missing:
// enum TaskPriority: String, Codable, CaseIterable { case low, medium, high }

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TaskModel.self, configurations: config)
    let task = TaskModel(title: "Preview Task", desc: "Test description", dueDate: Date(), postedDate: Date(), isCompleted: false, taskPriority: .medium)
    return TaskDetail(task: task)
        .modelContainer(container)
}
