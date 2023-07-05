//
//  TaskEditView.swift
//  Memoritix
//
//  Created by Farrel Erson Nugroho on 19/03/23.
//

import SwiftUI

struct AddChatView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    
    @State var selectedTaskItem: TaskItem?
    @State var name: String
    @State var desc: String
    @State var dueDate: Date
    @State var scheduleTime: Bool
    @State var selectedCategory: String
    
    // NOTIFICATION -----------------
    let notify = NotificationHandler()
    // ------------------------------
    
    @State private var hasilOpenAI:String = ""
    @State private var search = ""
    @State private var messageText = ""
    @State var messages: [String] = ["Welcome to MEMORITIX","Type something to remind you with format to..on..at..", "e.g. Remind me to join briefing on 28 March at 13:00"]
    
    
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
    
    // Add Page
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
    var body: some View {
 
        VStack {
           
                ScrollView {
                    ForEach(messages, id: \.self) { message in
                        // If the message contains [USER], that means it's us
                        if message.contains("[USER]") {
                            let newMessage = message.replacingOccurrences(of: "[USER]", with: "")
                            
                            // User message styles
                            HStack {
                                Spacer()
                                Text(newMessage)
                                    .padding()
                                    .foregroundColor(Color.white)
                                    .background(Color.blue.opacity(0.8))
                                    .cornerRadius(10)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 10)
                            }
                        } else {
                            
                            // Bot message styles
                            HStack {
                                Text(message)
                                    .padding()
                                    .background(Color.gray.opacity(0.15))
                                    .cornerRadius(10)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 10)
                                Spacer()
                            }
                        }
                        
                    }.rotationEffect(.degrees(180))
                }
                .rotationEffect(.degrees(180))
                .background(Color.gray.opacity(0.1))
                
                
                // Contains the Message bar
                HStack {
                    TextField("Remind me to...on...at...", text: $messageText)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .onSubmit {
                            inputDataToArray(message: messageText)
                            sendMessage(message: messageText)
                            saveAction()
                        }
                    
                    Button {
                        inputDataToArray(message: messageText)
                        sendMessage(message: messageText)
                        saveAction()
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(Color.black)
                    }
                    .font(.system(size: 26))
                    .padding(.horizontal, 10)
                }
                .padding()
            
            
        }.navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: btnBack)
                .toolbarBackground(
                    Color("MainColor4"),
                    for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        
    }
    
    //chat
    func sendMessage(message: String) {
        withAnimation {
            messages.append("[USER]" + message)
            self.messageText = ""
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    messages.append(getBotResponse(message: message))
                }
            }
        }
    }
    func inputDataToArray(message:String){
        var tempMessage = message.lowercased()
        var date:Date = Date()
        var tanggal:String = "27 March 2023 14:30"
        var title:String = ""

        if let startIndex = tempMessage.range(of: "to ")?.upperBound,
           let endIndex = tempMessage.range(of: " on ")?.lowerBound {
            name = String(tempMessage[startIndex..<endIndex])
        }
      
        if let startIndex = tempMessage.range(of: "on ")?.upperBound,
            let endIndex = tempMessage.range(of: " at ")?.lowerBound{
            tanggal = String(tempMessage[startIndex..<endIndex])
        }
        if let range = tempMessage.range(of: "at ")?.upperBound {
            tanggal = tanggal + " 2023 " + String(tempMessage[range...])
        }
        let dateFormatter = DateFormatter()
          dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
          dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
          dueDate =  dateFormatter.date(from:tanggal)!
        
        if name.contains("meet") || name.contains("online") || name.contains("zoom") || name.contains("briefing")
        {
            selectedCategory = "Online Meeting"
        }
        else if name.contains("workout") || name.contains("gym") || name.contains("sport") || name.contains("ball"){
            selectedCategory = "Workout"
        }
        else if name.contains("bed") || name.contains("sleep") || name.contains("rest"){
            selectedCategory = "Bed Time"
        }
        else if name.contains("secure") || name.contains("lock") || name.contains("safety"){
            selectedCategory = "Security"
        }
        else if name.contains("learn") || name.contains("study") || name.contains("task") || name.contains("homework") || name.contains("do"){
            selectedCategory = "Learning"
        }
        else {
            selectedCategory = "General"
        }

    }
    
    func removeSelectedWords(from text: String, wordsToRemove: [String])-> String{
        var newText = text
        
        for word in wordsToRemove{
            newText = newText.replacingOccurrences(of: word, with: "", options: [.caseInsensitive, .diacriticInsensitive])
        }
        return newText.trimmingCharacters(in: .whitespacesAndNewlines)
            
    }
    
    //
    
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
            selectedTaskItem?.dueDate = dueDate
            selectedTaskItem?.scheduleTime = scheduleTime
            selectedTaskItem?.selectedCategory = selectedCategory
            
            dateHolder.saveContext(viewContext)
//            self.presentationMode.wrappedValue.dismiss()
            
            // NOTIFICATION --------
            notify.sendNotification(
                date: dueDate,
                type: "date",
                title: "MEMORITIX",
                body: name,
                ctgry: "Learning")
            { success in }
            // ---------------------
        }
    }
}

struct addChatView_Previews: PreviewProvider {
    static var previews: some View {
        AddChatView(passedTaskItem: TaskItem(), initialDate: Date())
    }
}
