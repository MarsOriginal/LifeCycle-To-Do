//
//  FocusViewController.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 26/4/21.
//

import UIKit

struct Advice: Codable {
    var slip: Slip
    
    private enum CodingKeys: String, CodingKey {
        case slip
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.slip = try container.decodeIfPresent(Slip.self, forKey: .slip)!
    }
    
}

struct Slip: Codable {
    var id: Int
    var advice: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case advice
    }
}

class FocusViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    
    let progress = Progress(totalUnitCount: 100)
    let IDENTIFIER = "edu.monash.LifeCycle-To-Do"
    
    var hours = 0
    var mins = 0
    let state = State.inital
    
    var timer: Timer! = nil
    let duration = 0
    
    var totalSeconds = 0
    var runningSeconds = 0
    var totalInSecs = 0
    
    var adviceString = ""
    
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
        progressView.progress = 0.0
        
        let jsonURL = URL(string: "https://api.adviceslip.com/advice")

        let session = URLSession.shared
        let dataTask = session.dataTask(with: jsonURL!) { (data, response, error) in
            if let error = error {
                print(error)
            }
            else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let setData = try decoder.decode(Advice.self, from: data)
                    
                    self.adviceString = setData.slip.advice
                    
                    DispatchQueue.main.async {
                        self.adviceLabel.text = self.adviceString
                        print(self.adviceString)
                    }
                    
                } catch {
                    print(error)
                }
            }
        }

        dataTask.resume()
    }
    
    
    // Initialize the timer duration
    @IBAction func edit(_ sender: Any) {
        var durationTextField: UITextField?
        durationTextField?.keyboardType = .numberPad
        
        let alertController = UIAlertController(
            title: "Set Tomato Clock", message: "Enter the duration that you want focus on your task", preferredStyle: UIAlertController.Style.alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: UIAlertAction.Style.default) {
            (action) -> Void in
              if let duration = durationTextField?.text {
                if Int(duration)! >= 1 && Int(duration)! <= 180 {
                    self.durationLabel.text = String(format: "%02d:%02d", Int(duration)!, 0)
                    let state = State.ready
                    self.totalSeconds = Int(duration)! * 60
                    self.totalInSecs = Int(duration)! * 60
                }
                else if Int(duration)! > 180 {
                    self.displayMessage(title: "Rome was not built in a day", message: "Take it easy and break your focus time into some smaller task")
                }
                else{
                    self.displayMessage(title: "Someting wrong", message: "Please enter valid duration")
                }

              } else {
                    self.displayMessage(title: "Someting wrong", message: "Please enter valid duration")
              }
            let runningSeconds = 0

        }
        
        alertController.addTextField {
            (textDuration) -> Void in
            durationTextField = textDuration
            durationTextField!.placeholder = "Duration"
        }
        alertController.addAction(submitAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Logic of timer running
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
            runningSeconds += 1
            if totalSeconds >= 60 {
                let hours = totalSeconds/(60*60)
                let mins = totalSeconds/60
                let secs = totalSeconds%60
                self.durationLabel.text = String(format: "%02d:%02d", mins, secs)
            }

            else {
                let mins = 0
                let secs = totalSeconds
                self.durationLabel.text = String(format: "%02d:%02d", mins, secs)
            }
            self.progressView.setProgress(Float(Float(runningSeconds)/Float(totalInSecs)), animated: true)

        }
    }
    
    @IBAction func focusAction(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: (#selector(FocusViewController.updateTimer)), userInfo: nil, repeats: true)
        let state = State.running
    }
    
    // Have refer a bit from Workshop 5
    func getAdvice(){
        
        let jsonURL = URL(string: "https://api.adviceslip.com/advice")

        let session = URLSession.shared
        let dataTask = session.dataTask(with: jsonURL!) { (data, response, error) in
            if let error = error {
                print(error)
            }
            else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let setData = try decoder.decode(Advice.self, from: data)
                    
                    let adviceString = setData.slip.advice
                    
                } catch {
                    print(error)
                }
            }
        }

        dataTask.resume()
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
