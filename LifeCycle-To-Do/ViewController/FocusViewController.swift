//
//  FocusViewController.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 26/4/21.
//

import UIKit

class FocusViewController: UIViewController {
    
    var duration: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func edit(_ sender: Any) {
        var durationTextField: UITextField?
        
        let alertController = UIAlertController(
            title: "Set Tomato Clock", message: "Enter the duration that you want focus on your task", preferredStyle: UIAlertController.Style.alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: UIAlertAction.Style.default) {
            (action) -> Void in
              if let duration = durationTextField?.text {
              } else {
                print("Please enter valid duration")
              }

        }
        
        alertController.addTextField {
            (textDuration) -> Void in
            durationTextField = textDuration
            durationTextField!.placeholder = "Duration"
        }
        
        alertController.addAction(submitAction)
        self.present(alertController, animated: true, completion: nil)
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
