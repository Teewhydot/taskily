//
//  TaskCard.swift
//  taskily
//
//  Created by Issa Abubakar on 08/05/2026.
//

import SwiftUI
import SwiftData

struct TaskCard: View {
    let task: TaskModel
    @Environment(\.modelContext) private var modelContext
    
    
    // MARK: - Helper functions (unchanged)
    private func getPriorityString(priority: TaskPriority) -> String {
        switch priority {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
    
    private func getPriorityColor(priority: TaskPriority) -> Color {
        switch priority {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .red
        }
    }
    
    private func toggleCompletion() {
        task.isCompleted.toggle()
        try? modelContext.save()
    }
    
    private func deleteTask() {
        modelContext.delete(task)
        try? modelContext.save()
    }

    
    // MARK: - Body
    var body: some View {
            
            // Main card content (draggable)
            HStack {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(task.isCompleted ? .green : .primary)
                
                VStack(alignment: .leading) {
                    Text(task.title)
                        .font(.headline)
                        .strikethrough(task.isCompleted)
                    
                    Text(task.desc)
                        .font(.subheadline)
                        .strikethrough(task.isCompleted)
                }
                
                Spacer()
                
                Text(getPriorityString(priority: task.taskPriority))
                    .foregroundStyle(.primary)
                    .padding(8)
                    .background(getPriorityColor(priority: task.taskPriority))
                    .cornerRadius(5)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            .frame(height: 100)
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
    }     
}


#Preview {
    TaskCard(task: TaskModel(id: UUID(), title: "Let them free"))
}
