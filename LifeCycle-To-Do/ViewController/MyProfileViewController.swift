//
//  MyProfileViewController.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 25/4/21.
//

import UIKit
import FirebaseAuth

class MyProfileViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let handle = Auth.auth().addStateDidChangeListener { [self] (auth, user) in
            if Auth.auth().currentUser != nil {
              // User is signed in.
                let user = Auth.auth().currentUser
                emailLabel.text = user?.email
            } else {
              // No user is signed in.
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutAction(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Sign out sucessful")
            let loginViewController = self.storyboard?.instantiateViewController(identifier: "loginVC") as? LoginTableViewController
            loginViewController?.modalPresentationStyle = .fullScreen
            self.present(loginViewController!, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
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
