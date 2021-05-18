//
//  FocusViewController.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 26/4/21.
//

import UIKit

class FocusViewController: UIViewController {
    
    @IBOutlet weak var durationLabel: UILabel!
    
    let IDENTIFIER = "edu.monash.LifeCycle-To-Do"
    
    var hours = 0
    var mins = 0
    let state = State.inital
    
    var timer: Timer! = nil
     let duration = 0
    
    var totalSeconds = 0
    
    enum State {
        case inital
        case ready
        case running
        case finish
    }
    
    let appDelegate = {
       return UIApplication.shared.delegate as! AppDelegate
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func edit(_ sender: Any) {
        var durationTextField: UITextField?
        
        let alertController = UIAlertController(
            title: "Set Tomato Clock", message: "Enter the duration that you want focus on your task", preferredStyle: UIAlertController.Style.alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: UIAlertAction.Style.default) {
            (action) -> Void in
              if let duration = durationTextField?.text {
                if Int(duration)! > 0 && Int(duration)! < 60 {
                    self.durationLabel.text = String(format: "%02d:%02d", 0, Int(duration)!)
                    let state = State.ready
                    self.totalSeconds = Int(duration)! * 60
                }
                else if Int(duration)! > 60 {
                    let hours = Int(duration)! / 60
                    let mins = Int(duration)! % 60
                    self.durationLabel.text = String(format: "%02d:%02d", hours, mins)
                    let state = State.ready
                    self.totalSeconds = Int(duration)! * 60
                }
                else{
                    self.displayMessage(title: "Someting wrong", message: "Please enter valid duration")
                }

              } else {
                    self.displayMessage(title: "Someting wrong", message: "Please enter valid duration")
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
    
    @objc func updateTimer() {
        if totalSeconds == 0 {
            // Stop countdown and active alarm
            self.durationLabel.text = String(format: "%02d:%02d", 0, 0)
            let state = State.finish
            if timer != nil {
                timer.invalidate()
                timer = nil
            }
            
            // Active a notification
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "Focus Done"
            notificationContent.body = "Good For You!"
            
            let timeInterval = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            let request = UNNotificationRequest(identifier: IDENTIFIER, content: notificationContent, trigger: timeInterval)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        else {
            totalSeconds -= 1
            if totalSeconds >= 3600 {
                let hours = totalSeconds/(60*60)
                let mins = (totalSeconds % (60*60))/60
                self.durationLabel.text = String(format: "%02d:%02d", hours, mins)
            }
            else if (totalSeconds < 3600) && (totalSeconds >= 60) {
                let hours = 0
                let mins = totalSeconds / 60
                self.durationLabel.text = String(format: "%02d:%02d", hours, mins)
            }
            else {
                let hours = 0
                let mins = 1
                self.durationLabel.text = String(format: "%02d:%02d", hours, mins)
            }
        }
    }
    
    @IBAction func focusAction(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: (#selector(FocusViewController.updateTimer)), userInfo: nil, repeats: true)
        let state = State.running
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
