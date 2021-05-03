//
//  AddHabitViewController.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 26/4/21.
//

import UIKit

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
        if let name = habitNameTextField.text, !name.isEmpty {
            let _ = databaseController?.addHabit(name: name)
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
