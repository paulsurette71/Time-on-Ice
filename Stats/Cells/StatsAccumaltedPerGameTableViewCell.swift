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
    
    //Period
    @IBOutlet weak var stats1stPeriodLabel: UILabel!
    @IBOutlet weak var stats2ndPeriodLabel: UILabel!
    @IBOutlet weak var stats3rdPeriodLabel: UILabel!
    @IBOutlet weak var statsOvertimePeriodLabel: UILabel!
    @IBOutlet weak var stats1stPeriodPercentageLabel: UILabel!
    @IBOutlet weak var stats2ndPeriodPercentageLabel: UILabel!
    @IBOutlet weak var stats3rdPeriodPercentageLabel: UILabel!
    @IBOutlet weak var statsOTPeriodPercentageLabel: UILabel!
    
    
    
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
