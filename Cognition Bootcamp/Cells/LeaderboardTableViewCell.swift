//
//  LeaderboardTableViewCell.swift
//  Cognition Bootcamp
//
//  Created by Collin Browse on 11/10/21.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var initialsLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    static let reuseID = "leaderboardCell"
    
    override var canBecomeFocused: Bool {
        return false 
    }
    
    override func awakeFromNib() {
        layer.cornerRadius = 8
        clipsToBounds = true
        
    }
}
