//
//  Message.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2018-01-15.
//  Copyright © 2018 Surette, Paul. All rights reserved.
//

import Foundation
import UIKit

class Message {
    
    //classes
    let timeFormat  = TimeFormat()
    let convertDate = ConvertDate()
    
    let newLine = "\n"
    
    func build(data: StatsPerGameViewController.AccumulatedStats) -> [String: String] {
        
        var message = ""
        
        message += data.playerInformation
        message += newLine
        message += data.gameDate
        message += newLine
        message += data.teams
        message += newLine
        message += newLine
        message += "Time On Ice"
        message += newLine
        message += data.totalTimeOnIce
        message += newLine
        message += newLine
        message += "Shifts"
        message += newLine
        message += newLine
        message += "Total Shifts - " + data.totalShifts
        message += newLine
        message += "Average Shifts - " + data.averageShifts
        message += newLine
        message += "Shortest Shifts - " + data.shortestShift
        message += newLine
        message += "Longest Shifts - " + data.longestShift
        message += newLine
        message += newLine
        message += "Periods"
        message += newLine
        message += newLine
        message += "1st Period Shifts - " + data.firstPeriod
        message += newLine
        message += "2nd Period Shifts - " + data.secondPeriod
        message += newLine
        message += "3rd Period Shifts - " + data.thirdPeriod
        message += newLine
        message += "Overtime Period Shifts - " + data.overtimePeriod
        message += newLine
        message += newLine
        message += "1st Period Shift % - " + data.firstPeriodPercentage
        message += newLine
        message += "2nd Period Shift % - " + data.secondPeriodPercentage
        message += newLine
        message += "3rd Period Shift % - " + data.thirdPeriodPercentage
        message += newLine
        message += "Overtime Period Shift % - " + data.overTimePeriodPercentage
        message += newLine
        message += newLine
        message += "Shift Details"
        message += newLine
        message += newLine
        
        let shifts = data.shifts
        
        var shiftDetails = ""
        
        for index in shifts.indices {
            
            let timeOnInce = timeFormat.mmSS(totalSeconds: shifts[index]["timeOnIce"] as! Int)
            let results = "\(index + 1) - \(String(describing: shifts[index]["period"]!)) Period - \(timeOnInce)s"
            shiftDetails += results
            shiftDetails += newLine
            
        }
        
        message += shiftDetails
        message += newLine
        message += newLine
        message += "Time between Shifts"
        message += newLine
        message += newLine
        
        var timeDifferenceResults = ""
        
        for index in shifts.indices {
            
            if index == 0 {
                
                let timeOfShift = convertDate.convertDateToTime(dateToConvert: shifts[index]["date"] as! Date)
                timeDifferenceResults += "\(index + 1) - \(String(describing: shifts[index]["period"]!)) Period - \(String(describing: timeOfShift)) - 0s"
                timeDifferenceResults += newLine
                
            } else {
                
                let previousDate = shifts[index - 1]["date"] as! Date
                let comparisonDate = shifts[index]["date"] as! Date
                let timeDifference   = comparisonDate.timeIntervalSince(previousDate)
                let timeOfShift = convertDate.convertDateToTime(dateToConvert: shifts[index]["date"] as! Date)
                
                timeDifferenceResults += "\(index + 1) - \(String(describing: shifts[index]["period"]!)) Period - \(String(describing: timeOfShift)) - \(timeDifference.stringTime)s"
                timeDifferenceResults += newLine
            }
            
            
        }
        
        message += timeDifferenceResults
        message += newLine
        message += "NOTE: The Time between Shifts is represented as the time of day the shift took place.  This is NOT based on the arena clock."
        message += newLine
        message += newLine
        message += "Thanks for using Time on Ice"
        
        let subjectLine = "\(data.playerInformation): \(data.teams) (\(data.gameDate))"
        
        let resultsDictionary = ["message": message, "subjectLine": subjectLine]
        
        return resultsDictionary
    }
    
}  //Message
