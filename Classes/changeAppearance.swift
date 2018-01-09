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
        UINavigationBar.appearance().tintColor           = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                                                            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 28, weight: .heavy)]
//        UINavigationBar.appearance().barTintColor        = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        //UITabBar
        UITabBar.appearance().tintColor               = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        UITabBar.appearance().barTintColor            = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)], for:.selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)], for:.normal)
    }  //changeAppearance
    
}  //ColourPalette

