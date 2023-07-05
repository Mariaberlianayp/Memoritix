//
//  TaskCell.swift
//  Memoritix
//
//  Created by Farrel Erson Nugroho on 19/03/23.
//

import SwiftUI

struct TaskCell: View {
    
    @EnvironmentObject var dateHolder: DateHolder
    @ObservedObject var passedTaskItem: TaskItem
    
    @State var selectedTaskItem: TaskItem?
    // List Content
    var body: some View {
        
        HStack {
            CheckBoxView(passedTaskItem: passedTaskItem)
                .environmentObject(dateHolder).background(Color.white)
                .cornerRadius(50)
            
                
                VStack(alignment: .leading) {
                    Text(passedTaskItem.dueDate?.formatted(date: .omitted, time: .shortened) ?? "")
                    Text((passedTaskItem.name?.prefix(1).capitalized ?? "") + (passedTaskItem.name?.dropFirst() ?? "") ?? "")
                        .fontWeight(.bold)
                        .padding(.top, 1)
                    if(passedTaskItem.selectedCategory == nil || passedTaskItem.selectedCategory == "")
                    {
                        Text("General")
                            .foregroundColor(categoryColor())
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(categoryColor(), lineWidth: 2))
                    }
                    else{
                        Text(passedTaskItem.selectedCategory ?? "")
                            .foregroundColor(categoryColor())
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(categoryColor(), lineWidth: 2))
                    }
                    
                }
                .frame(width: 220.0, height: 120.0, alignment: .leading)
                .padding(.leading, 30.0)
                .background(Color.white)
                .cornerRadius(10)
                
                
        }
            
            
    }
    
    
    private func categoryColor()->Color{
        switch passedTaskItem.selectedCategory{
        case "Workout" : return .orange
        case "Bed Time" : return .green
        case "Security" : return .purple
        case "Online Meeting" : return .blue
        case "General" : return .gray
        default : return .red
        }
        
    }
    
}

struct TaskCell_Previews: PreviewProvider {
    static var previews: some View {
        TaskCell(passedTaskItem: TaskItem())
    }
}
