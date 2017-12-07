//
//  PopoverViewController.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-01.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pickerView: Picker!
    
    var dataToPassToPicker = [Any]()
    var popoverTitle       = ""
    var sender             = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataArray = dataToPassToPicker
        pickerView.textField = sender
        titleLabel.text      = popoverTitle
        
    }  //viewDidLoad
    
}  //selectedPositionFromPicker


