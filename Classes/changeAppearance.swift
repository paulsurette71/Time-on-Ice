//
//  changeAppearance.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-06.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import Foundation
import UIKit

class ColourPalette {
    
    //http://www.htmlportal.net/colors/shades-of-gray.php
    
    func changeAppearance() {
        
        //UINavigationBar
        UINavigationBar.appearance().tintColor           = UIColor(named: "gryphonRed")
//        UINavigationBar.appearance().barTintColor        = UIColor(named: "gryphonBlue")
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        UINavigationBar.appearance().titleTextAttributes = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 28, weight: .heavy)]
        
        //UITabBar
        UITabBar.appearance().tintColor               = UIColor(named: "gryphonBlue")
//        UITabBar.appearance().barTintColor            = UIColor(named: "linkWater")
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        
        //UITableView
//        UITableView.appearance().backgroundColor = UIColor(named: "gryphonBlue")
//        UITableView.appearance().separatorColor  = UIColor(named: "divider")
        
        //UIButton
//        UIButton.appearance().tintColor = UIColor(named: "gryphonBlue")
        
        //UIPicker
//        UIPickerView.appearance().tintColor = UIColor(named: "gryphonBlue")
        
        //UIDatePicker
//        UIDatePicker.appearance().tintColor = UIColor(named: "gryphonBlue")
        
    }
}

