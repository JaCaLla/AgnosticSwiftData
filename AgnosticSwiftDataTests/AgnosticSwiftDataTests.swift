//
//  AgnosticSwiftDataTests.swift
//  AgnosticSwiftDataTests
//
//  Created by Javier Calatrava on 8/1/25.
//

import Foundation
import Testing
import SwiftData
@testable import AgnosticSwiftData

extension DBManager {
    func setMemoryStorage(isStoredInMemoryOnly: Bool) {
        let configurations = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        do {
            modelContainer = try ModelContainer(for: TaskDB.self, configurations: configurations)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
}

@Suite("DBManagerTests", .serialized)
struct DBManagerTests {
    
    func getSUT() async throws -> DBManager {
        let dbManager = await DBManager.shared
        await dbManager.setMemoryStorage(isStoredInMemoryOnly: true)
        await dbManager.deleteAllData()
        return dbManager
    }
    
    @Test("Add Task")
    func testAddTask() async throws {
        let dbManager = try await getSUT()
        let task = Task(id: UUID(), title: "Test Task", isCompleted: false)
        
        await dbManager.addTask(task)
        
        let fetchedTasks = await dbManager.fetchTasks()
        #expect(fetchedTasks.count == 1)
        #expect(fetchedTasks.first?.title == "Test Task")
        
        await #expect(dbManager.tasks.count == 1)
        await #expect(dbManager.tasks[0].title == "Test Task")
        await #expect(dbManager.tasks[0].isCompleted == false)
    }
    
    @Test("Update Task")
    func testUpateTask() async throws {
        let dbManager = try await getSUT()
        let task = Task(id: UUID(), title: "Test Task", isCompleted: false)
        await dbManager.addTask(task)
        
        let newTask = Task(id: task.id, title: "Updated Task", isCompleted: true)
        await dbManager.updateTask(newTask)
        
        let fetchedTasks = await dbManager.fetchTasks()
        #expect(fetchedTasks.count == 1)
        #expect(fetchedTasks.first?.title == "Updated Task")
        #expect(fetchedTasks.first?.isCompleted == true)
        
        await #expect(dbManager.tasks.count == 1)
        await #expect(dbManager.tasks[0].title == "Updated Task")
        await #expect(dbManager.tasks[0].isCompleted == true)
    }
    
    @Test("Delete Task")
    func testDeleteTask() async throws {
        let dbManager = try await getSUT()
        let task = Task(id: UUID(), title: "Test Task", isCompleted: false)
        await dbManager.addTask(task)
        
        await dbManager.removeTask(task)
        
        let fetchedTasks = await dbManager.fetchTasks()
        #expect(fetchedTasks.isEmpty)
        
        await #expect(dbManager.tasks.isEmpty)
    }
    
    

    @Test("Fetch Tasks")
    func testFetchTasks() async throws {
        let dbManager = try await getSUT()
        let task1 = Task(id: UUID(), title: "Task 1", isCompleted: false)
        let task2 = Task(id: UUID(), title: "Task 2", isCompleted: true)
        
        await dbManager.addTask(task1)
        await dbManager.addTask(task2)
        
        let fetchedTasks = await dbManager.fetchTasks()
        #expect(fetchedTasks.count == 2)
        #expect(fetchedTasks.contains { $0.title == "Task 1" })
        #expect(fetchedTasks.contains { $0.title == "Task 2" })
        
        await #expect(dbManager.tasks.count == 2)
        await #expect(dbManager.tasks[0].title == "Task 1")
        await #expect(dbManager.tasks[0].isCompleted == false)
        await #expect(dbManager.tasks[1].title == "Task 2")
        await #expect(dbManager.tasks[1].isCompleted == true)
    }

    @Test("Delete All Data")
    func testDeleteAllData() async throws {
        let dbManager = try await getSUT()
        let task = Task(id: UUID(), title: "Test Task", isCompleted: false)
        
        await dbManager.addTask(task)
        await dbManager.deleteAllData()
        
        let fetchedTasks = await dbManager.fetchTasks()
        #expect(fetchedTasks.isEmpty)
        
        await #expect(dbManager.tasks.isEmpty)
    }
    
    @Test("Model Context Nil")
    @MainActor
    func testModelContextNil() async throws {
        let dbManager = try await getSUT()
        dbManager.modelContainer = nil
        
        dbManager.addTask(Task(id: UUID(), title: "Test", isCompleted: false))
        #expect(try dbManager.fetchTasks().isEmpty)
        
        #expect(dbManager.tasks.count == 0)
    }
    
}
