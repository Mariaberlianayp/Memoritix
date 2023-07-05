//
//  TaskItemExtension.swift
//  Memoritix
//
//  Created by Farrel Erson Nugroho on 19/03/23.
//

import SwiftUI

extension TaskItem {
    func isCompleted() -> Bool {
        return completedDate != nil
    }
}
