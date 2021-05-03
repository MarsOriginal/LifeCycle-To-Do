//
//  CoreDataController.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 27/4/21.
//
import CoreData
import UIKit

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    
    var habitFetchedResultsController: NSFetchedResultsController<Habit>?
    var taskFetchedResultsController: NSFetchedResultsController<Task>?
    
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
    
//    lazy var defaultTask: Task = {
//        var tasks = [Task]()
//        let request: NSFetchRequest<Task> = Task.fetchRequest()
//
//        do {
//            try tasks = persistentContainer.viewContext.fetch(request)
//        } catch {
//            print("Fetch Request Failed: \(error)")
//        }
//
//        if let iniTask = tasks.first {
//            return iniTask
//        }
//        return addTask(name: "Task", dueDate: Date())
//    }()
//
//    lazy var defaultHabit: Habit = {
//        var habits = [Habit]()
//        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
//
//        do {
//            try habits = persistentContainer.viewContext.fetch(request)
//        } catch {
//            print("Fetch Request Failed: \(error)")
//        }
//
//        if let iniHabit = habits.first {
//            return iniHabit
//        }
//        return addHabit(name: "Habit")
//    }()
    
    func fetchHabit() -> [Habit] {
        // Partial reference by Week6 starting point
        if habitFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            
            habitFetchedResultsController = NSFetchedResultsController<Habit>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            habitFetchedResultsController?.delegate = self
            
            do {
                try habitFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
        }
        
        var habits = [Habit]()
        if habitFetchedResultsController?.fetchedObjects != nil {
            habits = (habitFetchedResultsController?.fetchedObjects)!
        }
        return habits
    }
    
    func fetchTask() -> [Task] {
        // Partial reference by Week6 starting point
        if taskFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            
            taskFetchedResultsController = NSFetchedResultsController<Task>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            taskFetchedResultsController?.delegate = self
            
            do {
                try taskFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
        }
        
        var tasks = [Task]()
        if taskFetchedResultsController?.fetchedObjects != nil {
            tasks = (taskFetchedResultsController?.fetchedObjects)!
        }
        return tasks
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
        
        if listener.listenerType == .habit || listener.listenerType == .all {
            listener.onHabitChange(change: .update, currentHabits: fetchHabit())
        }
        if listener.listenerType == .task || listener.listenerType == .all {
            listener.onTaskChange(change: .update, currentTasks: fetchTask())
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func addHabit(name: String) -> Habit {
        let habit = NSEntityDescription.insertNewObject(forEntityName: "Habit", into: persistentContainer.viewContext) as! Habit
        habit.name = name
        
        return habit
    }
    
    func addTask(name: String, dueDate: Date) -> Task {
        let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: persistentContainer.viewContext) as! Task
        task.name = name
        task.toTime = dueDate
        
        return task
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == habitFetchedResultsController {
            listeners.invoke() { listener in
                if listener.listenerType == .habit || listener.listenerType == .all {
                    listener.onHabitChange(change: .update, currentHabits: fetchHabit())
                }
            }
        }
        else if controller == taskFetchedResultsController {
            listeners.invoke() { listener in
                if listener.listenerType == .task || listener.listenerType == .all {
                    listener.onTaskChange(change: .update, currentTasks: fetchTask())
                }
            }
        }
    }
}
