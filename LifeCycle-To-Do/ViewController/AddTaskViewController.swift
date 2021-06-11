//
//  AddTaskViewController.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 26/4/21.
//

import UIKit
import FirebaseAuth

class AddTaskViewController: UIViewController {
    // Item in view definition
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    // database related definiation
    weak var databaseController: DatabaseProtocol?
    
    // View logic definition
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        dueDatePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        dueDatePicker.minimumDate = Date()
    }
    
    // Action for submit the task's information, and pass to database
    @IBAction func addTaskAction(_ sender: Any) {
        let dueTime = dueDatePicker.date
        if let name = taskNameTextField.text, !name.isEmpty {
            let handle = Auth.auth().addStateDidChangeListener { [self] (auth, user) in
                if Auth.auth().currentUser != nil {
                  // User is signed in.
                    let user = Auth.auth().currentUser
                    let _ = databaseController?.addTask(name: name, dueTime: dueTime, ownerId: user!.uid)
                } else {
                  // No user is signed in.
                }
            }
            
            navigationController?.popViewController(animated: true)
            return
        }
        let errorMessage = "Please Enter A Name"
        displayMessage(title: "Not all fields filled", message: errorMessage)
    }
}
