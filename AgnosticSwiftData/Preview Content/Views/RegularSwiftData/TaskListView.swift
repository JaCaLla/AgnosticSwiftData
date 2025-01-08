//
//  TaskListView.swift
//  SwiftDataTask
//
//  Created by Javier Calatrava on 5/1/25.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var tasks: [TaskDB]

    @State private var showAddTaskView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(tasks) { task in
                    HStack {
                        Text(task.title)
                            .strikethrough(task.isCompleted, color: .gray)
                        Spacer()
                        Button(action: {
                            task.isCompleted.toggle()
                            try? modelContext.save()
                        }) {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .onDelete(perform: deleteTasks)
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddTaskView = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddTaskView) {
                AddTaskView()
            }
        }
    }

    private func deleteTasks(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(tasks[index])
        }
        try? modelContext.save()
    }
}

