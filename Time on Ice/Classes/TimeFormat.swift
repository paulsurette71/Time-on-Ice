//
//  TimeFormat.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-11-27.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import Foundation

class TimeFormat {
    
    func mmSS(totalSeconds: Int) -> String {
        
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60

        let timeAsString = String(format:"%02d:%02ds", minutes, seconds)
        
        return timeAsString
        
    }  //mmSS
    
}  //TimeFormat
