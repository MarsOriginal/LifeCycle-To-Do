//
//  Task.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 3/5/21.
//

import UIKit
import FirebaseFirestoreSwift

class Task: NSObject, Codable {
    @DocumentID var id: String?
    var name: String?
    var dueTime: Date?
    var ownerId: String?
}
