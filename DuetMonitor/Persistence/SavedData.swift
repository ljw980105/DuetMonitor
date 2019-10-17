//
//  SavedData.swift
//  DuetMonitor
//
//  Created by Jing Wei Li on 10/16/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import CoreData

class SavedData: NSManagedObject {
    
    static let fetchedResultsController: NSFetchedResultsController<SavedData> = {
        let request: NSFetchRequest<SavedData> = SavedData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "type", ascending: true)]
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: SavedDataManager.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return frc
    }()
    
    // inject a key-value pair of data into the database
    class func set(type: String, value: String, context: NSManagedObjectContext = SavedDataManager.context) {
        let request: NSFetchRequest<SavedData> = SavedData.fetchRequest()
        request.predicate = NSPredicate(format: "type = %@", type)
        if let data = try? context.fetch(request) {
            if data.isEmpty {
                let savedData = SavedData(context: context)
                savedData.type = type
                savedData.value = value
            } else {
                if let first = data.first, data.count > 1 {
                    first.value = value
                }
            }
        }
    }
    
    class func savedData(context: NSManagedObjectContext = SavedDataManager.context) -> [SavedData] {
        let request: NSFetchRequest<SavedData> = SavedData.fetchRequest()
        request.predicate = NSPredicate(value: true)
        if let data = try? context.fetch(request) {
            return data
        }
        return []
    }
    
    class func deleteAll(context: NSManagedObjectContext = SavedDataManager.context) {
        let request: NSFetchRequest<SavedData> = SavedData.fetchRequest()
        request.predicate = NSPredicate(value: true)
        if let data = try? context.fetch(request) {
            data.forEach { entry in
                context.delete(entry)
            }
        }
    }
    
}
