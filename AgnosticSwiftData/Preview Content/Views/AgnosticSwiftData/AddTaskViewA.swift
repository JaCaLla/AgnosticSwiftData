//
//  AddTaskViewA.swift
//  SwiftDataTask
//
//  Created by Javier Calatrava on 6/1/25.
//

import SwiftUI

struct AddTaskViewA: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: AgnosticTaskLlistViewModel
    
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
        viewModel.addTask(title: title)
    }
}
