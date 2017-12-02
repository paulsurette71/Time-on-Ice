//
//  PlayerInformationTableViewCell.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-02.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import UIKit

class PlayerInformationTableViewCell: UITableViewCell {
    
    //UILabel
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var playerInformationLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var totalTimeOnIceLabel: UILabel!
    @IBOutlet weak var totalShiftsLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
