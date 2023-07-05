//
//  FloatingButton.swift
//  Memoritix
//
//  Created by Farrel Erson Nugroho on 19/03/23.
//

import SwiftUI

struct AddTaskButton: View {
    
    @EnvironmentObject var dateHolder: DateHolder
    
    var body: some View {
        VStack {
            // Add new task link (as Button)
            NavigationLink(destination: AddChatView(passedTaskItem: nil, initialDate: Date())
                .environmentObject(dateHolder)) {
                Text("+")
                        .font(.system(size: 40))
            }
                .foregroundColor(.yellow)
            
        }
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskButton()
    }
}
