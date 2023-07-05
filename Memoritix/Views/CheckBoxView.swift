//
//  CheckBoxView.swift
//  Memoritix
//
//  Created by Farrel Erson Nugroho on 19/03/23.
//

import SwiftUI

struct CheckBoxView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    @ObservedObject var passedTaskItem: TaskItem
    
    // Checkbox (fill when the task done)
    var body: some View {
        Image(systemName: passedTaskItem.isCompleted() ? "checkmark" : "circle")
            .foregroundColor(passedTaskItem.isCompleted() ? .green : .secondary)
            .onTapGesture {
                withAnimation {
                    if !passedTaskItem.isCompleted() {
                        passedTaskItem.completedDate = Date()
                        dateHolder.saveContext(viewContext)
                    }
                }
            }
            .frame(width: 40.0, height: 40.0)
            .font(.system(size: 20, weight: .black))
    }
}

struct CheckBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CheckBoxView(passedTaskItem: TaskItem())
    }
}
