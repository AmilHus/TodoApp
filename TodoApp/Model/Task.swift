//
//  TodoItem.swift
//  TodoApp
//
//  Created by Амиль Гусейнов on 24.02.25.
//

import Foundation
import CoreData

struct Task: Codable, Equatable{
    let id: UUID
    var title: String
    var isCompleted: Bool
    
    init(id: UUID ,title: String , isCompleted: Bool = false){
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}

extension TaskEntity {
    func toTask() -> Task {
        return Task(id: self.id ?? UUID(), title: self.title ?? "", isCompleted: self.isCompleted)
    }
}
