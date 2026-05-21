//
//  TaskDetail.swift
//  taskily
//
//  Created by Issa Abubakar on 09/05/2026.
//

import SwiftUI

struct TaskDetail: View {
    let task: TaskModel
    @Environment(\  .dismiss) private var dismiss
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
                Image(systemName: "arrowshape.turn.up.left")
                Text("Tasks").foregroundStyle(.test)
                Spacer()
                Text("Edit").foregroundStyle(.test)
                
                
            }.padding()
                .padding(.bottom,30)
            Text(task.title).font(.largeTitle)
                .padding(.bottom,30)
            HStack{
                Image(systemName: "circle")
                Text("Mark as Completed")
                Spacer()
            }.padding(10)
                .background(.gray)
                .cornerRadius(10)
                .padding()
            
            
            
            
            VStack(alignment: .leading){
                Text("Description").font(.headline).foregroundStyle(.secondary)
                Text(task.desc)
            }.padding(10)
                .frame( maxWidth: .infinity)
                .background(.gray)
                .cornerRadius(10)
                .padding()
            
            VStack(alignment: .leading, ){
                AddTaskRow(icon: "calendar.circle",leadingColor: .accentColor, title: "Due Date"){
                    DatePicker("",selection: $selectedDate)
                    
                }
                AddTaskRow(icon: "flag",leadingColor: .accentColor, title: "Priority"){
                    
                    Picker("Appearance",systemImage: "paintpalette.fill",selection: $selectedPriority){
                        ForEach(Priority.allCases,id: \.self){ priority in
                            Text(priority.rawValue)
                            
                        }
                    }.pickerStyle(.segmented)
                }
                
                
            }.padding(0)
                .frame(maxWidth: .infinity)
                .background(.gray)
                .cornerRadius(10)
                .padding()
                .padding(.bottom,30)
            Button("Delete Task",role: .destructive)
            {
                
            }.frame(maxWidth: .infinity).padding().background(.button).cornerRadius(10).padding()
            Spacer()
            
        }
    }
}


#Preview {
    TaskDetail(task: TaskModel(id: UUID(), title: "Tgdnba",))
}
