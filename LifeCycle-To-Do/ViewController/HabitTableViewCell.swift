//
//  HabitTableViewCell.swift
//  LifeCycle-To-Do
//
//  Created by MARS on 1/5/21.
//

import UIKit

class HabitTableViewCell: UITableViewCell {

    @IBOutlet weak var habitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
