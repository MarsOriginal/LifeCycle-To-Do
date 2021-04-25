//
//  Habit.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 23/4/21.
//

import UIKit

class Habit: NSObject {
    var name: String
    var days: Int
    
    init(name: String) {
        self.name = name
        self.days = 0
    }
}
