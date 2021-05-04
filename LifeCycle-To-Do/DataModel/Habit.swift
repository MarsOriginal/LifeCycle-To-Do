//
//  Habit.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 3/5/21.
//

import UIKit
import FirebaseFirestoreSwift

class Habit: NSObject, Codable {
    @DocumentID var id: String?
    var name: String?
    var days: Int?
}
