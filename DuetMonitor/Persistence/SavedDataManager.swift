//
//  SavedDataManager.swift
//  DuetMonitor
//
//  Created by Jing Wei Li on 10/16/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Cocoa

class SavedDataManager: NSObject {
    
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SavedData")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
    
    static var context = SavedDataManager.persistentContainer.viewContext
    
    static func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
