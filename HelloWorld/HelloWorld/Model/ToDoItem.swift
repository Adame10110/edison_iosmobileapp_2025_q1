//
//  ToDoItem.swift
//  HelloWorld
//
//  Created by Adam Eisert on 3/4/25.
//

import Foundation

struct ToDoItem: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var isComplete: Bool = false
    var itemPriority: Int = 1
//    var tag: String
}
