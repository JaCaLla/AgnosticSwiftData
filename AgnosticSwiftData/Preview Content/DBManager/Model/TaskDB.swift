//
//  Task.swift
//  SwiftDataTask
//
//  Created by Javier Calatrava on 5/1/25.
//

import SwiftData
import Foundation


struct Task: Identifiable {
    let id: UUID
    let title: String
    let isCompleted: Bool
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
        self.id = id 
        self.title = title
        self.isCompleted = isCompleted
    }
}

extension Task {
    init(taskDB: TaskDB) {
        self.id = taskDB.id
        self.title = taskDB.title
        self.isCompleted = taskDB.isCompleted
    }
    
    func toTaskDB() -> TaskDB {
        TaskDB(from: self)
    }
}

@Model
class TaskDB {
    var id: UUID
    var title: String
    var isCompleted: Bool

    init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
        self.id = id // Se asigna un identificador único
        self.title = title
        self.isCompleted = isCompleted
    }
}

extension TaskDB {
    convenience init (from task: Task) {
        self.init(id: task.id, title: task.title, isCompleted: task.isCompleted)
    }
    
//    func toTask() -> Task {
//        Task(id: id, title: title, isCompleted: isCompleted)
//    }
}
