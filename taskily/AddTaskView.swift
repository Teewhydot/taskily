//
//  AddTaskView.swift
//  taskily
//
//  Created by Issa Abubakar on 10/05/2026.
//

import SwiftUI

struct AddTaskView: View {
    @State private var newTaskTitle = ""
    @State private var newTaskDesc = ""
    @State private var selectedDate: Date = Date.now
    @AppStorage("selectedPriority") var selectedPriority = Priority.low

    enum Priority: String, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
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
                    
                }
                Spacer()
                Text("New Task")
                Spacer()
                Button("Save") {
                    
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
