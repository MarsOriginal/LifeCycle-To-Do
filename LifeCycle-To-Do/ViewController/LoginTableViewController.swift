//
//  LoginTableViewController.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 20/4/21.
//

import UIKit
import FirebaseAuth

class LoginTableViewController: UITableViewController {
    
    let SECTION_INPUT = 0
    let SECTION_BUTTON = 1
    
    let CELL_USERNAME = "userNameCell"
    let CELL_PASSWORD = "passwordCell"
    let CELL_BUTTON = "loginButtonCell"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var anonymouslyLoginButton: UIButton!
    
    var authHandle: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
//        authHandle = Auth.auth().addStateDidChangeListener() {
//            (auth, user) in
//            guard user != nil else { return }
//            self.performSegue(withIdentifier: "loginSegue", sender: nil)
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let authHandle = authHandle else { return }
        Auth.auth().removeStateDidChangeListener(authHandle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let credential = EmailAuthProvider.credential(withEmail: , password: password)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

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
                self.displayMessage(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    func anonymouslyLoginToAccount(){
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard let user = authResult?.user else { return }
            let isAnonymous = user.isAnonymous  // true
            let uid = user.uid
        }
    }
    
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
        }
    }
    
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
        debugPrint("Anonymously Login")
    }
    
    // MARK: - Table view data source

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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
