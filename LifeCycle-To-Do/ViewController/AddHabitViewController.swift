//
//  AddHabitViewController.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 26/4/21.
//

import UIKit
import FirebaseAuth

class AddHabitViewController: UIViewController {
    // Item in view definition
    @IBOutlet weak var habitNameTextField: UITextField!
    
    // database related definiation
    weak var databaseController: DatabaseProtocol?

    // View logic definition
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
    // Action for submit the habit's information, and pass to database
    @IBAction func addHabit(_ sender: Any) {
        // Refer from Offical Website of Firebase
        if let name = habitNameTextField.text, !name.isEmpty {
            let handle = Auth.auth().addStateDidChangeListener { [self] (auth, user) in
                if Auth.auth().currentUser != nil {
                  // User is signed in.
                    let user = Auth.auth().currentUser
                    let _ = databaseController?.addHabit(name: name, ownerId: user!.uid)
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
