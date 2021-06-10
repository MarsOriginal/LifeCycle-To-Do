//
//  AddTaskViewController.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 26/4/21.
//

import UIKit
import FirebaseAuth

class AddTaskViewController: UIViewController {
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        dueDatePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        dueDatePicker.minimumDate = Date()
    }
    
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
        // add some error Msg
        var errorMessage = "Please Enter A Name"
        displayMessage(title: "Not all fields filled", message: errorMessage)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
