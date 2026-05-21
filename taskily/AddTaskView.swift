//
//  AddTaskView.swift
//  taskily
//
//  Created by Issa Abubakar on 10/05/2026.
//

import SwiftUI
import SwiftData

struct AddTaskView: View {
    @State private var newTaskTitle = ""
    @State private var newTaskDesc = ""
    @State private var selectedDate: Date = Date.now
    @AppStorage("selectedPriority") var selectedPriority = Priority.low
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss



    enum Priority: String, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
    }
    private func saveTask() {
        let trimmedTitle = newTaskTitle.trimmingCharacters(in: .whitespaces)
        guard !trimmedTitle.isEmpty else { return }
        
        // Map your Priority enum to TaskModel's TaskPriority
        let taskPriority: TaskPriority
        switch selectedPriority {
        case .low:
            taskPriority = .low
        case .medium:
            taskPriority = .medium
        case .high:
            taskPriority = .high
        }
        
        let newTask = TaskModel(
            title: trimmedTitle,
            desc: newTaskDesc,
            dueDate: selectedDate,
            postedDate: Date(),    // current timestamp
            isCompleted: false,
            taskPriority: taskPriority
        )
        
        modelContext.insert(newTask)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save task: \(error)")
            // Show an alert if you want
        }
    }
    private func AddTaskRow<Trailing: View>(icon: String, leadingColor: Color, title: String, @ViewBuilder suffixWidget: () -> Trailing) -> some View {
        HStack(spacing: 12){
            Image(systemName: icon)
                .padding(5)
                .frame(width: 30,height: 30)
                .font(.system(size: 15))
                
                .background(leadingColor)
                .cornerRadius(8)

            Text(title)
            Spacer()
            suffixWidget()
        }.padding(8)
        
    }
    var body: some View {
        VStack{
            HStack{
                Button("Cancel") {
                    dismiss()
                }
                Spacer()
                Text("New Task")
                Spacer()
                Button("Save") {
                    saveTask()
                }
                
            }.padding()
            Divider()
            VStack{
                TextField("Title", text:  $newTaskTitle)
                    .textFieldStyle(.plain)
                    .padding(.horizontal)
                Divider()
                TextField("Description", text: $newTaskDesc,axis: .vertical)
                    .lineLimit(4, reservesSpace: true)
                    .textFieldStyle(.automatic)
                    .padding(.horizontal)
                AddTaskRow(icon: "calendar",leadingColor: .accentColor, title: "Date"){
                    DatePicker("", selection: $selectedDate)
                }
                AddTaskRow(icon: "flag",leadingColor: .accentColor, title: "Priority"){
                    
                    Picker("Appearance",systemImage: "paintpalette.fill",selection: $selectedPriority){
                        ForEach(Priority.allCases,id: \.self){ priority in
                            Text(priority.rawValue)
                            
                        }
                    }.pickerStyle(.menu)
                }
                
            }.padding()
        }
    }
}

#Preview {
    AddTaskView()
}
