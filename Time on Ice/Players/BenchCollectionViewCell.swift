//
//  BenchCollectionViewCell.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-11-22.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import UIKit

class BenchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBackgroundImageView: UIImageView!
    
    @IBOutlet weak var playerNumberLabel: UILabel!
//    @IBOutlet weak var playerFirstNameLabel: UILabel!
    @IBOutlet weak var playerLastNameLabel: UILabel!
//    @IBOutlet weak var playerPositionLabel: UILabel!
//    @IBOutlet weak var timeOnIceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
