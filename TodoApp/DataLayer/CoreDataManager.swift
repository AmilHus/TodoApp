//
//  CoreDataManager.swift.swift
//  TodoApp
//
//  Created by Амиль Гусейнов on 24.02.25.
//

import CoreData

class CoreDataManager{
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init(){
        persistentContainer = NSPersistentContainer(name: "TodoApp")
        persistentContainer.loadPersistentStores {(_, error) in
            if let error = error{
                fatalError("Core Data Loading has failed: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Saving Context has failed: \(nserror)")
            }
        }
    }
}

