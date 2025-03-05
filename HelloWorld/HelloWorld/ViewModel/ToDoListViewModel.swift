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
    
    private let repository: ToDoListRepository = ToDoListRepositoryImpl()
        
    @Published var editingItemId: UUID?
    @Published var inputTask: String = ""
    @Published var toDoItems: [ToDoItem] = []
    
    private var stupidPriority = 0
    
    func addItem(_ priority: Priority, _ tag: String) {
        if inputTask.isEmpty { return }
        
        if (priority.rawValue == "Urgent") {
            stupidPriority = 0
        }
        if (priority.rawValue == "Soon") {
            stupidPriority = 1
        }
        if (priority.rawValue == "Whenever") {
            stupidPriority = 2
        }
        
        toDoItems.append(ToDoItem(title: inputTask, itemPriority: stupidPriority, itemTag: tag))
        inputTask = ""
        repository.saveToDoItems(toDoItems)
    }
    
    func removeItem(_ item: ToDoItem) {
        if let index = toDoItems.firstIndex(where: { $0.id == item.id}) {
            toDoItems.remove(at: index)
            repository.saveToDoItems(toDoItems)
        }
    }
    
    func toggleItem(_ item: ToDoItem) {
        if let index = toDoItems.firstIndex(where: { $0.id == item.id}) {
            toDoItems[index].isComplete.toggle()
            repository.saveToDoItems(toDoItems)
        }
    }
    
    func sortList() {
        toDoItems.sort { (item1, item2) -> Bool in
            return item1.itemPriority < item2.itemPriority
        }
        repository.saveToDoItems(toDoItems)
    }
    
    func updateItemText(_ item: ToDoItem, _ newValue: String) {
        if let index = toDoItems.firstIndex(where: { $0.id == item.id}) {
            toDoItems[index].title = newValue
            repository.saveToDoItems(toDoItems)
        }
    }
    
    func loadData() {
        toDoItems = repository.loadToDoItems()
    }
    
    func onSubmit() {
        editingItemId = nil
        repository.saveToDoItems(toDoItems)
    }
    
    func onSubmit(_ item: ToDoItem) {
        editingItemId = item.id
        repository.saveToDoItems(toDoItems)
    }
    
}
