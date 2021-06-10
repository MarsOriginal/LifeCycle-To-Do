//
//  AddHabitViewController.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 26/4/21.
//

import UIKit
import FirebaseAuth

class AddHabitViewController: UIViewController {
    @IBOutlet weak var habitNameTextField: UITextField!
    
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
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
        // add some error Msg

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
