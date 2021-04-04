//
//  Todo.swift
//  ToDoApp
//
//  Created by Fernando Carneiro on 29/12/20.
//

import Foundation

struct Todos: Codable {
    let items: Array<Todo>
}


struct Todo: Codable {
    let item: String
    let priority: Int 
}
