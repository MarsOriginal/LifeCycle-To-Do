//
//  TodayTableViewController.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 23/4/21.
//

import UIKit
import FirebaseAuth

class TodayTableViewController: UITableViewController, DatabaseListener {
    weak var databaseController: DatabaseProtocol?
    var listenerType = ListenerType.all
    
    let SECTION_MANAGE = 0
    let SECTION_HABIT = 1
    let SECTION_REMINDER = 2
    
    let CELL_MANAGE = "manageCell"
    let CELL_HABIT = "habitCell"
    let CELL_TASK = "taskCell"
    
    var current_habits: [Habit] = []
    var current_tasks: [Task] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SECTION_MANAGE {
            return 1
        }
        else if section == SECTION_HABIT {
            return self.current_habits.count
        }
        else {
            return self.current_tasks.count
        }
    }
    
    
    func onHabitChange(change: DatabaseChange, currentHabits: [Habit]) {
        let handle = Auth.auth().addStateDidChangeListener { [self] (auth, user) in
            if Auth.auth().currentUser != nil {
              // User is signed in.
                let user = Auth.auth().currentUser
                print(user?.uid)
                current_habits = currentHabits.filter({(myHabit) -> Bool in
                                                        return myHabit.ownerId == user?.uid})
                tableView.reloadData()
            } else {
              // No user is signed in.
            }
        }

    }
    
    func onTaskChange(change: DatabaseChange, currentTasks: [Task]) {
        let handle = Auth.auth().addStateDidChangeListener { [self] (auth, user) in
            if Auth.auth().currentUser != nil {
              // User is signed in.
                let user = Auth.auth().currentUser
                current_tasks = currentTasks.filter({(myTask) -> Bool in
                                                        return myTask.ownerId == user?.uid})
                tableView.reloadData()
            } else {
              // No user is signed in.
            }
        }
        
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case SECTION_HABIT:
            return "Habit"
        case SECTION_REMINDER:
            return "Reminder"
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == SECTION_MANAGE {
            let manageCell = tableView.dequeueReusableCell(withIdentifier: CELL_MANAGE, for: indexPath)
            return manageCell
        }
        else if indexPath.section == SECTION_HABIT {
            let habitCell = tableView.dequeueReusableCell(withIdentifier: CELL_HABIT, for: indexPath)
            let habit = current_habits[indexPath.row]
            
            habitCell.textLabel?.text = habit.name
            habitCell.detailTextLabel?.text = "Keep Days: \(String(describing: habit.days!))"
            return habitCell
        }
 
        let taskCell = tableView.dequeueReusableCell(withIdentifier: CELL_TASK, for: indexPath)
        let task = current_tasks[indexPath.row]
            
        taskCell.textLabel?.text = task.name
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy, HH:mm"
        taskCell.detailTextLabel?.text = formatter.string(for: task.dueTime)
        return taskCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            case SECTION_HABIT:
                tableView.deselectRow(at: indexPath, animated: true)
            case SECTION_REMINDER:
                tableView.deselectRow(at: indexPath, animated: true)
            default:
                tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-YYYY"
        switch indexPath.section {
        case SECTION_HABIT:
            if dateformatter.string(from: current_habits[indexPath.row].checkDate ?? Date(timeIntervalSinceReferenceDate: -100000000)) != dateformatter.string(from: Date()) {
                let action = UIContextualAction(style: .normal,
                                                title: "Check") { [weak self] (action, view, completionHandler) in
                                                    self?.handleCheckForHabit(indexPath: indexPath)
                                                    completionHandler(true)
                }
                action.backgroundColor = .systemBlue
                return UISwipeActionsConfiguration(actions: [action])
            }
            let action = UIContextualAction(style: .normal,
                                            title: "Check") { [weak self] (action, view, completionHandler) in
                                                self?.handleAlertForHabit(indexPath: indexPath)
                                                completionHandler(true)
            }
            action.backgroundColor = .systemBlue
            return UISwipeActionsConfiguration(actions: [action])
            
        case SECTION_REMINDER:
            let action = UIContextualAction(style: .destructive,
                                            title: "Check") { [weak self] (action, view, completionHandler) in
                self?.handleCheckForTask(indexPath: indexPath)
                                                completionHandler(true)
            }
            action.backgroundColor = .systemBlue
            return UISwipeActionsConfiguration(actions: [action])
        default:
            return nil
        }

    }

    private func handleCheckForTask(indexPath: IndexPath){
        let task = current_tasks[indexPath.row]
        databaseController?.deleteTask(task: task)
    }
    
    private func handleCheckForHabit(indexPath: IndexPath){
        let habit = current_habits[indexPath.row]
        current_habits[indexPath.row].checkDate = Date()
        databaseController?.addDayToHabit(habit: habit)
    }
    
    private func handleAlertForHabit(indexPath: IndexPath){
        let alert = UIAlertController(title: "Confirmation", message: "You have checked today, Do you want check this habit again?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.handleCheckForHabit(indexPath: indexPath)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }

    
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
