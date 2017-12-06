//
//  ConvertDate.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-06.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import Foundation

class ConvertDate {
    
    func convertDate(date:NSDate) -> String {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.short
        
        return formatter.string(from: date as Date)
        
    }  //convertDate
    
}  //ConvertDate

