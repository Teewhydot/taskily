//
//  TaskList.swift
//  taskily
//
//  Created by Issa Abubakar on 08/05/2026.
//

import SwiftUI
import SwiftData

struct TaskList: View {

    @Query(sort: \TaskModel.postedDate, order: .reverse) private var tasks: [TaskModel]

    
    
    @State private var sheetOn = false
    @State private var searchText: String = ""
    @State private var selected: String = "All"
    let filters  = ["All", "Active", "Completed"]
    
  
    private var filteredTasks: [TaskModel] {
        tasks.filter { task in
            switch selected {
            case "Active":
                return !task.isCompleted
            case "Completed":
                return task.isCompleted
                
                
            default: return true
                
            }
        
        }.filter {
            task in
            searchText.isEmpty || task.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
      
            VStack {
            HStack {
                Spacer()
                Text("Tasks")
                    .font(.title)
                    .bold()
                Spacer()
                Image(systemName: "plus.app")
                    .font(.system(size: 32))
                    .foregroundStyle(.blue)
                    .onTapGesture {
                        sheetOn = true
                    }
                    .sheet(isPresented: $sheetOn, content: {
                        AddTaskView().presentationDetents([.medium])
                    })
            }.padding()
            
            ZStack(alignment: .leading) {
                // Fixed search text tracking (binding to searchText variable instead of a constant)
                TextField("             Search tasks", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    
                HStack {
                    Image(systemName: "magnifyingglass").padding(.leading, 28)
                    Spacer()
                    Image(systemName: "mic.fill").padding(.trailing, 28)
                }
            }.padding(.top, 30)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(filters, id: \.self) { filter in
                        Text(filter)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selected == filter ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundStyle(selected == filter ? .white : .primary)
                            .cornerRadius(20)
                            .onTapGesture {
                                selected = filter
                            }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.horizontal)
            }.padding(.top, 16)
            
                if (tasks.isEmpty) {
                    VStack{
                        Text(
                            "No tasks added yet"
                        )
                    }.frame(maxWidth: .infinity,maxHeight: .infinity)} else {
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
                            ForEach(filteredTasks, id: \.id) { task in
                                NavigationLink(value: task) {
                                    TaskCard(task: task)
                                }.tint(.primary)
                            }
                        }
                    }
                }
        }
    }

   
}
#Preview {
    TaskList()
}
