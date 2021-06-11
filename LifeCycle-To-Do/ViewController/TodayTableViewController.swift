//
//  TodayTableViewController.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 23/4/21.
//

import UIKit
import FirebaseAuth

class TodayTableViewController: UITableViewController, DatabaseListener {
    // Database related Setup
    weak var databaseController: DatabaseProtocol?
    var listenerType = ListenerType.all
    
    // Section Setup
    let SECTION_MANAGE = 0
    let SECTION_HABIT = 1
    let SECTION_REMINDER = 2
    
    // Cell Setup
    let CELL_MANAGE = "manageCell"
    let CELL_HABIT = "habitCell"
    let CELL_TASK = "taskCell"
    
    /*
        Initialize arrays for habit and task, these two will record current habits and task
        for the user who login currently.
     */
    var current_habits: [Habit] = []
    var current_tasks: [Task] = []

    
    // View Logic Setup
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
    
    // TableView Setup
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
            // Swipe process of Habit cell
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
            // Swipe process of task cell
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
    
    
    // Tracking habits from firebase
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
    
    // Tracking tasks from firebase
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

    // Enable the check task process, invoke it by left swipe
    private func handleCheckForTask(indexPath: IndexPath){
        let task = current_tasks[indexPath.row]
        databaseController?.deleteTask(task: task)
    }
    
    // Enable the check habit process, invoke it by left swipe
    private func handleCheckForHabit(indexPath: IndexPath){
        let habit = current_habits[indexPath.row]
        current_habits[indexPath.row].checkDate = Date()
        databaseController?.addDayToHabit(habit: habit)
    }
    
    // To avoid wrong operating of mutiple checking within one day
    private func handleAlertForHabit(indexPath: IndexPath){
        let alert = UIAlertController(title: "Confirmation", message: "You have checked today, Do you want check this habit again?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.handleCheckForHabit(indexPath: indexPath)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}
