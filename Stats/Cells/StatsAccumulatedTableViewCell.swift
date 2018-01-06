//
//  StatsAccumulatedTableViewCell.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2018-01-05.
//  Copyright © 2018 Surette, Paul. All rights reserved.
//

import UIKit

class StatsAccumulatedTableViewCell: UITableViewCell {
    
    //UILabel
    @IBOutlet weak var statsTotalTimeOnIceLabel: UILabel!
    @IBOutlet weak var statsTotalShiftsLabel: UILabel!
    @IBOutlet weak var statsAverageShiftLengthLabel: UILabel!
    @IBOutlet weak var statsShortestShiftLengthLabel: UILabel!
    @IBOutlet weak var statsLongestShiftLengthLabel: UILabel!
    @IBOutlet weak var statsTotalGamesLabel: UILabel!
    
    @IBOutlet weak var statsAvgShiftsPerGameLabel: UILabel!
    @IBOutlet weak var statsAvgTimeOnIcePerGameLabel: UILabel!
    
    //UIView
    @IBOutlet weak var timeOnIceView: UIView!
    @IBOutlet weak var shiftsView: UIView!
    @IBOutlet weak var gamesView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
            
        let backgroundColour = #colorLiteral(red: 0.7725490196, green: 0.7215686275, blue: 0.6784313725, alpha: 1)
        
        //set background colour for headings
        timeOnIceView.backgroundColor = backgroundColour
        shiftsView.backgroundColor = backgroundColour
        gamesView.backgroundColor = backgroundColour
        
        // Initialization code
    }
    //
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        super.setSelected(selected, animated: animated)
    //
    //        // Configure the view for the selected state
    //    }
    
}
