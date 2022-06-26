//
//  Todo.swift
//  SQLiteSimpleTodoList
//
//  Created by TJ on 2022/06/26.
//

import Foundation

class Todo{
    var id: Int
    var description: String
    init(id: Int, description: String){
        self.id = id
        self.description = description
    }
}
