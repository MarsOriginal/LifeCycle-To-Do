//
//  Habit+CoreDataProperties.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 27/4/21.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var name: String?
    @NSManaged public var days: Int16

}

extension Habit : Identifiable {

}
