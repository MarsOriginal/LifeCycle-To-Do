//
//  Task+CoreDataProperties.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 27/4/21.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var fromTime: Date?
    @NSManaged public var toTime: Date?

}

extension Task : Identifiable {

}
