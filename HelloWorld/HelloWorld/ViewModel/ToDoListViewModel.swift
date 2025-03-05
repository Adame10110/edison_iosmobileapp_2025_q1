//
//  ToDoListViewModel.swift
//  HelloWorld
//
//  Created by Adam Eisert on 3/4/25.
//

import Foundation
import SwiftUI
import Combine

class ToDoListViewModel: ObservableObject {
    
    @AppStorage("toDoItems") private var toDoItemsData: Data = Data()
    
    @Published var editingItemId: UUID?
    @Published var inputTask: String = ""
    @Published var toDoItems: [ToDoItem] = []
    
    func addItem() {
        if inputTask.isEmpty { return }
        toDoItems.append(ToDoItem(title: inputTask))
        inputTask = ""
        saveToDoItems()
    }
    
    func removeItem(_ item: ToDoItem) {
        if let index = toDoItems.firstIndex(where: { $0.id == item.id}) {
            toDoItems.remove(at: index)
            saveToDoItems()
        }
    }
    
    func toggleItem(_ item: ToDoItem) {
        if let index = toDoItems.firstIndex(where: { $0.id == item.id}) {
            toDoItems[index].isComplete.toggle()
            saveToDoItems()
        }
    }
    
    func updateItemText(_ item: ToDoItem, _ newValue: String) {
        if let index = toDoItems.firstIndex(where: { $0.id == item.id}) {
            toDoItems[index].title = newValue
            saveToDoItems()
        }
    }
    
    func loadData() {
        loadToDoItems()
    }
    
    func onSubmit() {
        editingItemId = nil
        saveToDoItems()
    }
    
    func onSubmit(_ item: ToDoItem) {
        editingItemId = item.id
        saveToDoItems()
    }
    
}

extension ToDoListViewModel {
    private func saveToDoItems(){
        do {
            let data = try JSONEncoder().encode(toDoItems)
            UserDefaults.standard.set(data, forKey: "toDoItems")
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    private func loadToDoItems(){
        if let data = UserDefaults.standard.data(forKey: "toDoItems") {
            do {
                toDoItems = try JSONDecoder().decode([ToDoItem].self, from: data)
            } catch {
                print("Error loading data: \(error)")
            }
        }
    }
}
