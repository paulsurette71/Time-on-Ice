//
//  StatsAccumaltedPerGameTableViewCell.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2018-01-06.
//  Copyright © 2018 Surette, Paul. All rights reserved.
//

import UIKit

class StatsAccumaltedPerGameTableViewCell: UITableViewCell {
    
    //UILabel
    @IBOutlet weak var statsTotalTimeOnIceLabel: UILabel!
    @IBOutlet weak var statsTotalShiftsLabel: UILabel!
    @IBOutlet weak var statsAverageShiftLengthLabel: UILabel!
    @IBOutlet weak var statsShortestShiftLengthLabel: UILabel!
    @IBOutlet weak var statsLongestShiftLengthLabel: UILabel!
    
    //UIView
    @IBOutlet weak var timeOnIceView: UIView!
    @IBOutlet weak var shiftsView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
        let backgroundColour = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        //set background colour for headings
        timeOnIceView.backgroundColor = backgroundColour
        shiftsView.backgroundColor    = backgroundColour
        
    }
    
}
