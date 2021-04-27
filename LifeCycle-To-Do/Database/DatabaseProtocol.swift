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
    case team
    case heroes
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onTaskChange(change: DatabaseChange, currentTask: [Task])
    func onHabitChange(change: DatabaseChange, currentHabit: [Habit])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)

}
