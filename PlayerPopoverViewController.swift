//
//  PlayerPopoverViewController.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-06.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import UIKit

class PlayerPopoverViewController: UIViewController {

    //UILabel
    @IBOutlet weak var popoverTitleLabel: UILabel!
    
    //UIPicker
    @IBOutlet weak var picker: PlayerPicker!
    
    var dataToPassToPicker = [Players]()
    var popoverTitle       = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.playersArray    = dataToPassToPicker
        popoverTitleLabel.text = popoverTitle
        
    }  //viewDidLoad


}  //PlayerPopoverViewController
