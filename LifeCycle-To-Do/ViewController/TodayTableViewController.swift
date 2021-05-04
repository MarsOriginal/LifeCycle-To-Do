//
//  TodayTableViewController.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 23/4/21.
//

import UIKit

class TodayTableViewController: UITableViewController, DatabaseListener {
    @IBOutlet weak var stepsTextField: UITextField!
    weak var databaseController: DatabaseProtocol?
    var listenerType = ListenerType.all
    
    let SECTION_MANAGE = 0
    let SECTION_FITNESS = 1
    let SECTION_HABIT = 2
    let SECTION_REMINDER = 3
    
    let CELL_MANAGE = "manageCell"
    let CELL_FITNESS = "fitnessCell"
    let CELL_HABIT = "habitCell"
    let CELL_TASK = "taskCell"
    
    var current_habits: [Habit] = []
    var current_tasks: [Task] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SECTION_MANAGE {
            return 1
        }
        else if section == SECTION_FITNESS {
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
        current_habits = currentHabits
        tableView.reloadData()
    }
    
    func onTaskChange(change: DatabaseChange, currentTasks: [Task]) {
        current_tasks = currentTasks
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Fitness"
        case 2:
            return "Habit"
        case 3:
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
        else if indexPath.section == SECTION_FITNESS{
            let fitnessCell = tableView.dequeueReusableCell(withIdentifier: CELL_FITNESS, for: indexPath)
            return fitnessCell
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
        return taskCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            case SECTION_HABIT:
                let habit = current_habits[indexPath.row]
                databaseController?.addDayToHabit(habit: habit)
                tableView.deselectRow(at: indexPath, animated: true)
            case SECTION_REMINDER:
                let task = current_tasks[indexPath.row]
                databaseController?.deleteTask(task: task)
                tableView.deselectRow(at: indexPath, animated: true)
            default:
                tableView.deselectRow(at: indexPath, animated: true)
        }
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
