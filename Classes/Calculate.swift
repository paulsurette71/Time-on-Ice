//
//  Calculate.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-11-20.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import Foundation

class Calculate {
    
    //classes
    let timeFormat  = TimeFormat()
    
    func birthDate(usingThisDate: Date) -> Int {
        
        let calendar = NSCalendar.current
        
        let components = calendar.dateComponents([.year], from: usingThisDate, to: Date())
        
        return components.year!
        
    }  //birthDate
    
    func averageTimeOnIce(player: Players, timeOnIce: Int, shifts: Int) -> String {
        var returnValue = ""
        
        if shifts > 0 {
            
            let average = timeOnIce / shifts
            
            returnValue = timeFormat.mmSS(totalSeconds: average)
            
        } else {
            
            returnValue = ""
        }
        
        return returnValue
        
    }  //averageTimeOnIce
    
    func averageShiftsPerGame(games: Int, shifts:Int) -> String {
        var returnValue = ""
        
        if shifts > 0 {
            
            let average = Double(shifts) / Double(games)
            
            returnValue = String(average)
            
        } else {
            returnValue = ""
        }
        
        return returnValue
        
    }  //averageShiftsPerGame
    
    func averageTimeOnIcePerGame(timeOnInce: Int, games: Int) -> Int {
        
        var returnValue = 0
        
        if games > 0 {
            
            let average = Double(timeOnInce) / Double(games)
            
            returnValue = Int(average)
            
        } else {
            returnValue = 0
        }
        
        return returnValue
        
    }
    
    
}  //Calculate
