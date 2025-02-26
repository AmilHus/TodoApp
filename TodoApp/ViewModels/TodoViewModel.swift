//
//  TodoViewModel.swift
//  TodoApp
//
//  Created by Амиль Гусейнов on 25.02.25.
//

import CoreData
import Foundation

protocol TodoViewModelDelegate:AnyObject{
    func didUpdateTasks(_ task: [Task])
}

class TodoViewModel {
    weak var delegate: TodoViewModelDelegate?
    
    private var tasks : [Task] = [] {
        didSet{
            delegate?.didUpdateTasks(tasks)
        }
    }
    
    private let context = CoreDataManager.shared.context
    
    
    var tasksCount: Int {
            return tasks.count
        }
        
    
    init(){
        fetchTasks()
    }
    
    func fetchTasks(){
        let request : NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        do {
            let result = try context.fetch(request)
            tasks = result.map{$0.toTask()}
        } catch {
            print("Error Fetching Task")
        }
    }
    
    func addNewTask(title:String){
        let newTask = TaskEntity(context: context)
        
        newTask.id = UUID()
        newTask.title = title
        newTask.isCompleted = false
        
        saveContext()
    }
    
    func updateTask(task:Task, newTitle: String){
        let request : NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do{
            let result = try context.fetch(request)
            if let taskEntity = result.first {
                taskEntity.title = newTitle
                taskEntity.isCompleted = task.isCompleted
                saveContext()
            }
        } catch {
            print("Error Updating Task")
        }
    }
    
    func deleteTask(task:Task){
        
        let request : NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()        
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
           
            let result = try context.fetch(request)
            if let taskEntity = result.first {
                context.delete(taskEntity)
                saveContext()
            }
        } catch {
            print("Error Deleting Task")
        }
    }
    
    private func saveContext(){
        CoreDataManager.shared.saveContext()
        fetchTasks()
    }
 
    func task(at index: Int) -> Task {
        return tasks[index]
    }
}
