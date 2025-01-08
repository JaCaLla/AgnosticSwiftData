//
//  TaskListViewA.swift
//  SwiftDataTask
//
//  Created by Javier Calatrava on 6/1/25.
//

import SwiftUI

struct AgnosticTaskListView: View {
    @StateObject private var viewModel: AgnosticTaskLlistViewModel = .init()
    
    @State private var showAddTaskView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.tasks) { task in
                    HStack {
                        Text(task.title)
                            .strikethrough(task.isCompleted, color: .gray)
                        Spacer()
                        Button(action: {
                            viewModel.toogleTask(task: task)
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
                AddTaskViewA()
                    .environmentObject(viewModel)
            }
        }.onAppear {
            viewModel.fetchTasks()
        }
    }
    
    private func deleteTasks(at offsets: IndexSet) {
        viewModel.removeTask(at: offsets)
    }
}
