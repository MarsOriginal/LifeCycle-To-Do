//
//  Task+CoreDataProperties.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 1/5/21.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var toTime: Date?
    @NSManaged public var user: User?

}

extension Task : Identifiable {

}
