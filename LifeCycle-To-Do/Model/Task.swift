//
//  Task.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 21/4/21.
//

import UIKit

class Task: NSObject {
    var name: String?
    var fromTime: Date?
    var toTime: Date?
    
    init(name: String, fromTime: Date, toTime: Date) {
        self.name = name
        self.fromTime = fromTime
        self.toTime = toTime
    }
}
