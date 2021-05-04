//
//  DatabaseProtocol.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 27/4/21.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case habit
    case task
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onTaskChange(change: DatabaseChange, currentTasks: [Task])
    func onHabitChange(change: DatabaseChange, currentHabits: [Habit])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)

    func addHabit(name: String) -> Habit
    func addTask(name: String, dueTime: Date) -> Task
    func deleteHabit(habit: Habit)
    func deleteTask(task: Task)
    func addDayToHabit(habit: Habit)
}
