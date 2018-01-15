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
    
    func convertDateOnly(date:NSDate) -> String {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = DateFormatter.Style.medium
        
        return formatter.string(from: date as Date)
        
    }  //convertDate
    
    func convertDateToTime(dateToConvert:Date) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = .medium  //10:00:00 PM
        
        let dateAsAString = dateFormatter.string(from: dateToConvert)
        let dateAsADate   = dateFormatter.date(from: dateAsAString)
        let convertedDateAsAString = dateFormatter.string(from: dateAsADate!)
        
        return convertedDateAsAString
        
    }


    
}  //ConvertDate

