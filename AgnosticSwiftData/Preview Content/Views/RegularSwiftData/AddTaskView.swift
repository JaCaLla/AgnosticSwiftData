//
//  AddTaskView.swift
//  SwiftDataTask
//
//  Created by Javier Calatrava on 5/1/25.
//
import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Task Title", text: $title)
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        addTask()
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }

    private func addTask() {
        let newTask = TaskDB(title: title)
        modelContext.insert(newTask)
        try? modelContext.save()
    }
}

