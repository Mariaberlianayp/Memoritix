//
//  MemoritixApp.swift
//  Memoritix
//
//  Created by Farrel Erson Nugroho on 19/03/23.
//

import SwiftUI

@main
struct MemoritixApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            let context = persistenceController.container.viewContext
            let dateHolder = DateHolder(context)
            
            TaskListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(dateHolder)
        }
    }
}
