//
//  Habit+CoreDataProperties.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 1/5/21.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var days: Int16
    @NSManaged public var name: String?
    @NSManaged public var user: User?

}

extension Habit : Identifiable {

}
