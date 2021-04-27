//
//  CoreDataController.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 27/4/21.
//
import CoreData
import UIKit

class CoreDataController: NSObject, DatabaseProtocol {
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    
    override init() {
        // Refer some line from FIT3178 week 6 starting point on moodle
        persistentContainer = NSPersistentContainer(name: "LifeCycle-DataModel")
        persistentContainer.loadPersistentStores() { (description, error ) in
            if let error = error {
                fatalError("Failed to load Core Data Stack with error: \(error)")
            }
        }
        super.init()
    }
    
    func cleanup() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save changes to Core Data with error: \(error)")
            }
        }
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
}
