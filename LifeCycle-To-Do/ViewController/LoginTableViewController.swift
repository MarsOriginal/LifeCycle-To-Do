//
//  LoginTableViewController.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 20/4/21.
//

import UIKit
import FirebaseAuth

class LoginTableViewController: UITableViewController {
    // Section Definition
    let SECTION_INPUT = 0
    let SECTION_BUTTON = 1
    
    // Cell Definition
    let CELL_USERNAME = "userNameCell"
    let CELL_PASSWORD = "passwordCell"
    let CELL_BUTTON = "loginButtonCell"
    
    // Reference Outlets Definition
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var anonymouslyLoginButton: UIButton!
    
    // Firebase Auth Setup
    var authHandle: AuthStateDidChangeListenerHandle?
    
    // View Logic Setup
    override func viewWillDisappear(_ animated: Bool) {
        guard let authHandle = authHandle else { return }
        Auth.auth().removeStateDidChangeListener(authHandle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /*
        Login process, call this function by the login Button, and if the password is incorrect
        the account is not exist, there will display a message to user, and the purpose of give
        these two situation one same message is increase security level.
     */
    func loginToAccount(){
        guard let password = passwordTextField.text else {
            displayMessage(title: "Error", message: "Please enter a password")
            return
        }

        guard let email = emailTextField.text else {
            displayMessage(title: "Error", message: "Please enter an email")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) {
            (user, error) in
            if let error = error {
                self.displayMessage(title: "Login Failed", message: error.localizedDescription)
                return
            }
            
            let stepViewController = self.storyboard?.instantiateViewController(identifier: "stepVC") as? UIViewController
            stepViewController?.modalPresentationStyle = .fullScreen
            self.present(stepViewController!, animated: true, completion: nil)
        }
    }
    
    
    /*
        Same process with loginToAccount, but this method doesn't need a registered account,
        user can just click it to enter this app for convinence, but use this method may cause data lose.
     */
    func anonymouslyLoginToAccount(){
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard let user = authResult?.user else { return }
            let isAnonymous = user.isAnonymous  // true
            let uid = user.uid
            
            let stepViewController = self.storyboard?.instantiateViewController(identifier: "stepVC") as? UIViewController
            stepViewController?.modalPresentationStyle = .fullScreen
            self.present(stepViewController!, animated: true, completion: nil)
        }

    }
    
    /*
        Create a account with security rule, the rule is the length of password
        must be longer or equals to 6.
     */
    func registerAccount(){
        guard let password = passwordTextField.text else {
            displayMessage(title: "Error", message: "Please enter a password")
            return
        }

        guard let email = emailTextField.text else {
            displayMessage(title: "Error", message: "Please enter an email")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) {
            (user, error) in
            if let error = error {
                self.displayMessage(title: "Error", message: error.localizedDescription)
            }
            self.displayMessage(title: "Register Successful", message: "You can Login with your user name and password now!")
        }

    }
    
    // Button's Actions for: login, anonymouslylogin and register.
    @IBAction func login(_ sender: UIButton) {
        guard sender == loginButton else {
            debugPrint("Invalid Button!")
            return
        }
        loginToAccount()
        debugPrint("Login")
    }
    
    @IBAction func register(_ sender: UIButton) {
        guard sender == registerButton else {
            debugPrint("Invalid Button!")
            return
        }
        registerAccount()
        debugPrint("Register")
    }
    @IBAction func anonymouslyLogin(_ sender: UIButton) {
        guard sender == anonymouslyLoginButton else {
            debugPrint("Invalid Button!")
            return
        }
        anonymouslyLoginToAccount()
        debugPrint("Anonymously Login")
    }
    
    // TableView Setup
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SECTION_INPUT {
            return 2
        }
        return 1
    }
}
