//
//  TaskEditView.swift
//  Memoritix
//
//  Created by Farrel Erson Nugroho on 19/03/23.
//

import SwiftUI

struct TaskEditView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    
    @State var selectedTaskItem: TaskItem?
    @State var name: String
    @State var desc: String
    @State var dueDate: Date
    @State var scheduleTime: Bool
    @State var selectedCategory = "General"
    
    let categoryPool = ["Workout", "Bed Time", "Security", "Online Meeting", "Learning", "General"]
    
    // NOTIFICATION -----------------
    let notify = NotificationHandler()
    // ------------------------------
    
    init(passedTaskItem: TaskItem?, initialDate: Date) {
        if let taskItem = passedTaskItem {
            _selectedTaskItem = State(initialValue: taskItem)
            _name = State(initialValue: taskItem.name ?? "")
            _desc = State(initialValue: taskItem.desc ?? "")
            _dueDate = State(initialValue: taskItem.dueDate ?? initialDate)
            _scheduleTime = State(initialValue: taskItem.scheduleTime)
            _selectedCategory = State(initialValue: taskItem.selectedCategory ?? "")
        }
        else {
            _name = State(initialValue: "")
            _desc = State(initialValue: "")
            _dueDate = State(initialValue: initialDate)
            _scheduleTime = State(initialValue: false)
            _selectedCategory = State(initialValue: "")
        }
    }
    
    var btnBack : some View { Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            }) {
                
                HStack {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color.black)
                    Text("Add Reminder").fontWeight(.bold).foregroundColor(.black).padding()
                        
                    Image("Ship")
                        .padding(.leading, 130.0)
                }

                
            }
            
        }
    
    // Edit Page
    var body: some View {

            Form {
                Section(header: Text("Title")) {
                    TextField("Add Title", text: $name)
                }.listRowBackground(Color("NeutralColor1"))
                Section(header: Text("Description")) {
                    TextField("Add Description", text: $desc)
                }.listRowBackground(Color("NeutralColor1"))
                
                Section(header: Text("Category")) {
                    Picker("Add Category", selection: $selectedCategory) {
                        ForEach(categoryPool, id: \.self) {
                            Text($0)
                        }
                    }
                }.listRowBackground(Color("NeutralColor1"))
                
                Section(header: Text("Due Date")) {
                    Toggle("Schedule Time", isOn: $scheduleTime)
                    DatePicker("Due Date", selection: $dueDate, in: Date()..., displayedComponents: displayComps())
                }.listRowBackground(Color("NeutralColor1"))
                
                if selectedTaskItem?.isCompleted() ?? false {
                    Section(header: Text("Completed")) {
                        Text(selectedTaskItem?.completedDate?.formatted(date: .abbreviated, time: .shortened) ?? "")
                            .foregroundColor(.green)
                    }.listRowBackground(Color("NeutralColor1"))
                }
                
                
                Button("Save", action: saveAction)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.white)
                    .padding(15)
                    .background(Color.black)
                    .cornerRadius(10)
                
                

                
            }.toolbarBackground(
                Color("MainColor4"),
                for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .scrollContentBackground(.hidden)
            .background{Color.white}
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
        
           
            
    }
    
    func displayComps() -> DatePickerComponents {
        return scheduleTime ? [.hourAndMinute, .date] : [.date]
    }
    
    func saveAction() {
        withAnimation {
            if selectedTaskItem == nil {
                selectedTaskItem = TaskItem(context: viewContext)
            }
            
            selectedTaskItem?.created = Date()
            selectedTaskItem?.name = name
            selectedTaskItem?.desc = desc
            selectedTaskItem?.dueDate = dueDate
            selectedTaskItem?.scheduleTime = scheduleTime
            selectedTaskItem?.selectedCategory = selectedCategory
            
            dateHolder.saveContext(viewContext)
            self.presentationMode.wrappedValue.dismiss()
            
            // NOTIFICATION --------
            notify.sendNotification(
                date: dueDate,
                type: "date",
                title: "MEMORITIX",
                body: name,
                ctgry: selectedCategory)
            { success in }
            // ---------------------
        }
    }
}

struct TaskEditView_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditView(passedTaskItem: TaskItem(), initialDate: Date())
    }
}
