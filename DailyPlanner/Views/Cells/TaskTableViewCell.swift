//
//  TaskTableViewCell.swift
//  DailyPlanner
//
//  Created by Vic on 18.12.2024.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeStolStartLabel: UILabel!
    @IBOutlet weak var timeSlotEndLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    
    static let identifier = "TaskTableViewCell"
    
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
