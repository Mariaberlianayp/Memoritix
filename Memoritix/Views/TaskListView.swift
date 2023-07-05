//
//  ContentView.swift
//  Memoritix
//
//  Created by Farrel Erson Nugroho on 19/03/23.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskItem.dueDate, ascending: true)],
        animation: .default)
    private var items: FetchedResults<TaskItem>
    
    // NOTIFICATION -----------------
    let notify = NotificationHandler()
    // ------------------------------

    // Homepage
    let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "E, d MMM yyyy"
            return formatter
        }()
    @State private var selectedDate = Date()

    var filteredItems: [TaskItem] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        return items.filter { $0.dueDate ?? Date() >= startOfDay && $0.dueDate ?? Date() < endOfDay }
    }

    var body: some View {
        var temp = 0
        NavigationView {
            VStack(spacing: 30) {
                Image("logo").resizable().frame(width: 210.0, height: 40.0)
                    VStack(alignment: .leading) {
                
//                        Text(dateFormatter.string(from: Date()))
//                            .fontWeight(.bold)
//                            .padding(.horizontal)
//
                        DatePicker("Filter Date", selection: $selectedDate, displayedComponents: .date).padding(.horizontal, 20.0)
                            .padding(.trailing, 20.0)
                        HStack {
                            if items.count <= 1 {
                                Text("You have \(filteredItems.count) reminder today")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .offset(x: 18, y: 10)
                            }
                            else {
                                Text("You have \(filteredItems.count) reminders today")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .offset(x: 18, y: 10)
                            }
                            Spacer()
                            AddTaskButton().environmentObject(dateHolder)
                                .offset(x: -30)
                                .padding(.top, 10)
                            
                        }.padding(.top, -20.0)
                    }.offset(x: 10, y: 10)
                    .padding(.top, -20.0)
                    
                    
                    
                    


                List {
                    
                    ForEach(filteredItems, id: \.self) { taskItem in
                        ZStack(alignment: .leading) {
                            TaskCell(passedTaskItem: taskItem)
                                    .environmentObject(dateHolder)
                            NavigationLink(destination: TaskEditView(passedTaskItem: taskItem, initialDate: Date())
                                .environmentObject(dateHolder)) {
                                
                                EmptyView()
                            }
                            .padding()
                            .cornerRadius(10)
                            .background(Color.clear)
                            .buttonStyle(PlainButtonStyle())
                            .opacity(0)
                            
                            
                            if(taskItem.dueDate ?? Date() > Date())
                            {
                                Image("Ship2")
                                    .padding(.leading, 250.0)
                                    .padding(.top, -80.0)
                                    .onChange(of: temp, perform: { value in
                                        if value == 0{
                                            temp = 1
                                        }
                                    })
                            }
                            
                            
            

                            
                        }
                        .listRowBackground(Color.clear)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        
                        Spacer()

                        .listRowBackground(Color.clear)

                        .background(Color.red)
                        
                    }
                    .onDelete(perform: deleteItems)
                    
                    
                }
                .scrollContentBackground(.hidden)
                .background{
                    Image("Daylight")
                        .resizable()
                }
                .listStyle(SidebarListStyle())
                .ignoresSafeArea()
                
                //Spacer()

//                Text("Not working?")
//                    .foregroundColor(.gray)
//                    .italic()
//                    .padding()
//                Button("Request permissions") {
//                    notify.askPermission()
//                }
//                .padding()
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            dateHolder.saveContext(viewContext)
        }
    }
    
    
    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
