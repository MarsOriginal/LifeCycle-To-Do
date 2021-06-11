//
//  FirebaseController.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 3/5/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseController: NSObject, DatabaseProtocol {
    let DEFAULT_HABIT_NAME = "Habit"
    let DEFAULT_TASK_NAME = "Name"
    var listeners = MulticastDelegate<DatabaseListener>()
    var habitList: [Habit]
    var taskList: [Task]
    
    // Firebase
    var authController: Auth
    var database: Firestore
    var habitsRef: CollectionReference?
    var tasksRef: CollectionReference?
    
    // Method Stubs
    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        habitList = [Habit]()
        taskList = [Task]()
        
        super.init()
        authController.signInAnonymously() { (authResult, error) in
            guard authResult != nil else {
                fatalError("Firebase Authentication Failed with Error \(String(describing: error))")
            }
            self.setupTaskListener()
            self.setupHabitListener()
        }
        
    }
    
    // Listener Setup
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == ListenerType.habit ||
            listener.listenerType == ListenerType.all {
            listener.onHabitChange(change: .update, currentHabits: habitList)
        }
        
        if listener.listenerType == ListenerType.task ||
            listener.listenerType == ListenerType.all {
            listener.onTaskChange(change: .update, currentTasks: taskList)
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func cleanup() {}
    
    // CRUD Method: addHabit, addTask, deleteHabit, deleteTask, addDayToHabit, getHabitIndexByID, getHabitByID, getTaskIndexByID, getTaskByID
    func addHabit(name: String, ownerId: String) -> Habit{
        let habit = Habit()
        habit.name = name
        habit.days = 0
        habit.ownerId = ownerId
        
        do {
            if let habitRef = try habitsRef?.addDocument(from: habit) {
                habit.id = habitRef.documentID
            }
        } catch {
            print("Failed to serialize habit")
        }
        return habit
    }
    func addTask(name: String, dueTime: Date, ownerId: String) -> Task{
        let task = Task()
        task.name = name
        task.dueTime = dueTime
        task.ownerId = ownerId
        
        do {
            if let taskRef = try tasksRef?.addDocument(from: task) {
                task.id = taskRef.documentID
            }
        } catch {
            print("Failed to serialize task")
        }
        return task
    }
    func deleteHabit(habit: Habit) {
        if let habitID = habit.id {
            habitsRef?.document(habitID).delete()
        }
    }
    func deleteTask(task: Task) {
        if let taskID = task.id {
            tasksRef?.document(taskID).delete()
        }
    }
    
    func addDayToHabit(habit: Habit) {
        let changedHabit = habit
        changedHabit.days = habit.days! + 1
        if let habitID = habit.id {
            do {
                try habitsRef?.document(habitID).setData(from: changedHabit)
            } catch {
                print("Failed to adding keep day")
            }
        }
    }
    
    
    // Firebase Controller
    func getHabitIndexByID(_ id: String) -> Int? {
        if let habit = getHabitByID(id) {
            return habitList.firstIndex(of: habit)
        }
        return nil
    }
    func getHabitByID(_ id: String) -> Habit? {
        for habit in habitList {
            if habit.id == id {
                return habit
            }
        }
        return nil
    }
    func getTaskIndexByID(_ id: String) -> Int? {
        if let task = getTaskByID(id) {
            return taskList.firstIndex(of: task)
        }
        return nil
    }
    func getTaskByID(_ id: String) -> Task? {
        for task in taskList {
            if task.id == id {
                return task
            }
        }
        return nil
    }
    func setupHabitListener() {
        habitsRef = database.collection("habits")
        habitsRef?.addSnapshotListener() { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            self.parseHabitsSnapshot(snapshot: querySnapshot)
        }
    }
    func setupTaskListener() {
        tasksRef = database.collection("tasks")
        tasksRef?.addSnapshotListener() { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            self.parseTasksSnapshot(snapshot: querySnapshot)
        }

    }
    func parseHabitsSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            let habitID = change.document.documentID
            print(habitID)
            
            var parsedHabit: Habit?
            
            do {
                parsedHabit = try change.document.data(as: Habit.self)
            } catch {
                print("Unable to decode habit. Is the hero malformed?")
                return
            }
            
            guard let habit = parsedHabit else {
                print("Document doesn't exist")
                return;
            }
            
            habit.id = habitID
            if change.type == .added {
                habitList.append(habit)
            }
            else if change.type == .modified {
                let index = getHabitIndexByID(habitID)!
                habitList[index] = habit
            }
            else if change.type == .removed {
                if let index = getHabitIndexByID(habitID) {
                    habitList.remove(at: index)
                }
            }
        }
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.habit ||
                listener.listenerType == ListenerType.all {
                listener.onHabitChange(change: .update, currentHabits: habitList)
            }
        }
    }
    func parseTasksSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            let taskID = change.document.documentID
            print(taskID)
            
            var parsedTask: Task?
            
            do {
                parsedTask = try change.document.data(as: Task.self)
            } catch {
                print("Unable to decode task. Is the hero malformed?")
                return
            }
            
            guard let task = parsedTask else {
                print("Document doesn't exist")
                return
            }
            
            
            if change.type == .added {
                taskList.insert(task, at: Int(change.newIndex))
            }
            else if change.type == .modified {
                taskList[Int(change.oldIndex)] = task
            }
            else if change.type == .removed {
                taskList.remove(at: Int(change.oldIndex))
            }
        }
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.task ||
                listener.listenerType == ListenerType.all {
                listener.onTaskChange(change: .update, currentTasks: taskList)
            }
        }
    }
    

}
