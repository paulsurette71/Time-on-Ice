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
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        UINavigationBar.appearance().titleTextAttributes = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 28, weight: .heavy)]
//        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.9215686275, green: 0.8666666667, blue: 0.7215686275, alpha: 1)
        
        //UITabBar
        UITabBar.appearance().tintColor               = UIColor(named: "gryphonBlue")
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
//        UITabBar.appearance().barTintColor = #colorLiteral(red: 0.9215686275, green: 0.8666666667, blue: 0.7215686275, alpha: 1)
        
        //UITableView
//        UITableViewHeaderFooterView.appearance().backgroundColor = #colorLiteral(red: 0.6549019608, green: 0.568627451, blue: 0.5607843137, alpha: 1)
//        UITableViewCell.appearance().backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
                
    }
}

