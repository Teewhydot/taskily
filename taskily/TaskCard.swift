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
    
    // Swipe state
    @State private var offset: CGFloat = 0
    private let completeThreshold: CGFloat = -80   // swipe left to complete
    private let deleteThreshold: CGFloat = 80      // swipe right to delete
    
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
    
    private func resetSwipe() {
        withAnimation(.spring()) {
            offset = 0
        }
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Hidden background actions (revealed on swipe)
            HStack {
                // Left action (swipe right to reveal)
                Button(action: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        deleteTask()
                        resetSwipe()
                    }
                }) {
                    VStack {
                        Image(systemName: "trash.fill")
                            .font(.title2)
                        Text("Delete")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                    .frame(width: 80, height: 80)
                }
                .background(Color.red)
                
                Spacer()
                
                // Right action (swipe left to reveal)
                Button(action: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        toggleCompletion()
                        resetSwipe()
                    }
                }) {
                    VStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                        Text("Complete")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                    .frame(width: 80, height: 80)
                }
                .background(Color.green)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
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
                    .font(.caption)
                    .padding(8)
                    .background(getPriorityColor(priority: task.taskPriority))
                    .cornerRadius(5)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        let translation = gesture.translation.width
                        // Limit swipe to max 100 points each direction
                        offset = max(-100, min(100, translation))
                    }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            if offset <= completeThreshold {
                                toggleCompletion()
                                resetSwipe()
                            } else if offset >= deleteThreshold {
                                deleteTask()
                                resetSwipe()
                            } else {
                                resetSwipe()
                            }
                        }
                    }
            )
        }
        .frame(height: 100) // Adjust height as needed
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }     
}


#Preview {
    TaskCard(task: TaskModel(id: UUID(), title: "Let them free"))
}
