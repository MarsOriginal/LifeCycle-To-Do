//
//  User.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 21/4/21.
//

import UIKit

class User: NSObject {
    var userName: String
    var numOfTask: Int
    var numOfStep: Int
    var numOfMins: Int
    
    init(userName: String) {
        self.userName = userName
        self.numOfTask = 0
        self.numOfStep = 0
        self.numOfMins = 0
    }
}
