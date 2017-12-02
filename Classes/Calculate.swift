//
//  Calculate.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-11-20.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import Foundation

class Calculate {
    
    func birthDate(usingThisDate: Date) -> Int {
        
        let calendar = NSCalendar.current
        
        let components = calendar.dateComponents([.year], from: usingThisDate, to: Date())
        
        return components.year!
        
    }  //birthDate

}  //Calculate
