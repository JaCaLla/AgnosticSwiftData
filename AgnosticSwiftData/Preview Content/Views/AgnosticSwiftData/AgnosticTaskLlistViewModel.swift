//
//  TaskLlistViewModelA.swift
//  SwiftDataTask
//
//  Created by Javier Calatrava on 7/1/25.
//

import Foundation

@MainActor
protocol AgnosticTaskLlistViewModelProtocol {
    func addTask(title: String)
    func removeTask(at offsets: IndexSet)
    func toogleTask(task: Task)
}

@MainActor
final class AgnosticTaskLlistViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    
    let dbManager = appSingletons.dbManager
    
    init() {
        dbManager.$tasks.assign(to: &$tasks)
    }
}

extension AgnosticTaskLlistViewModel: AgnosticTaskLlistViewModelProtocol {
    func addTask(title: String) {
        let task = Task(title: title)
        dbManager.addTask(task)
    }
    
    func removeTask(at offsets: IndexSet) {
        for index in offsets {
            dbManager.removeTask(tasks[index])
        }
    }
    
    func toogleTask(task: Task) {
        let task = Task(id: task.id, title: task.title, isCompleted: !task.isCompleted)
        dbManager.updateTask(task)
    }
    
    func fetchTasks() {
        _ = dbManager.fetchTasks()
    }
}
