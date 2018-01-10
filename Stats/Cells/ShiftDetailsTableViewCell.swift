//
//  ShiftDetailsTableViewCell.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2018-01-10.
//  Copyright © 2018 Surette, Paul. All rights reserved.
//

import UIKit

class ShiftDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var numberOfShiftsLabel: UILabel!
    @IBOutlet weak var timeOnIceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateDifferenceLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
