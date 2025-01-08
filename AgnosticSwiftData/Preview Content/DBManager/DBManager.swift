//
//  LocationManager.swift
//  LocationSampleApp
//
//  Created by Javier Calatrava on 30/11/24.
//

import SwiftData
import SwiftUI
import Foundation

@MainActor
protocol DBManagerProtocol {
    func addTask(_ task: Task)
    func updateTask(_ task: Task)
    func removeTask(_ task: Task)
    func fetchTasks() -> [Task]
}

@MainActor
class DBManager: NSObject, ObservableObject {

    @Published var tasks: [Task] = []


    static let shared = DBManager()

    var modelContainer: ModelContainer? = nil

    var modelContext: ModelContext? {
        modelContainer?.mainContext
    }

    private init(isStoredInMemoryOnly: Bool = false) {
        let configurations = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        do {
            modelContainer = try ModelContainer(for: TaskDB.self, configurations: configurations)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
}

extension DBManager: DBManagerProtocol {

    func removeTask(_ task: Task) {
        guard let modelContext,
            let taskDB = fetchTask(by: task.id) else { return }

        modelContext.delete(taskDB)

        do {
            try modelContext.save()
        } catch {
            print("Error on deleting task: \(error)")
        }
    }

    func updateTask(_ task: Task) {
        guard let modelContext,
            let taskDB = fetchTask(by: task.id) else { return }

        taskDB.title = task.title
        taskDB.isCompleted = task.isCompleted

        do {
            try modelContext.save()
        } catch {
            print("Error on updating task: \(error)")
        }
        return
    }

    private func fetchTask(by id: UUID) -> TaskDB? {
        guard let modelContext else { return nil }

        let predicate = #Predicate<TaskDB> { task in
            task.id == id
        }

        let descriptor = FetchDescriptor<TaskDB>(predicate: predicate)

        do {
            let tasks = try modelContext.fetch(descriptor)
            return tasks.first
        } catch {
            print("Error fetching task: \(error)")
            return nil
        }
    }

    func addTask(_ task: Task) {
        guard let modelContext else { return }
        let taskDB = task.toTaskDB()
        modelContext.insert(taskDB)
        do {
            try modelContext.save()
            tasks = fetchTasks()
        } catch {
            print("Error addig tasks: \(error.localizedDescription)")
        }
    }

    func fetchTasks() -> [Task] {
        guard let modelContext else { return [] }

        let fetchRequest = FetchDescriptor<TaskDB>()

        do {
            let tasksDB = try modelContext.fetch(fetchRequest)
            tasks = tasksDB.map { .init(taskDB: $0) }
            return tasks 
        } catch {
            print("Error fetching tasks: \(error.localizedDescription)")
            return []
        }
    }

    func deleteAllData() {
        guard let modelContext else { return }
        do {
            try modelContext.delete(model: TaskDB.self)
        } catch {
            print("Error on removing all data: \(error)")
        }
        tasks = fetchTasks()
    }
}
