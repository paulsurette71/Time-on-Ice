//
//  IsAppAlreadyLaunchedOnce.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-03-18.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import Foundation

class IsAppAlreadyLaunchedOnce {
    
    func isAppAlreadyLaunchedOnce() -> Bool{
        
        //http://stackoverflow.com/questions/9964371/how-to-detect-first-time-app-launch-on-an-iphone
        
        let defaults = UserDefaults.standard
        
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
            
            //already launced.
            
            return true
            
        } else {
            
            //launched for the first time
            
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            
            return false
        }
    }
} //class IsAppAlreadyLaunchedOnce

