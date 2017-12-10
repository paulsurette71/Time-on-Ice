//
//  CreateAttributedString.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-11-27.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import Foundation
import UIKit

class CreateAttributedString {
    
    let timeFormat = TimeFormat()
    
    func forPlayersOnBench(numberOfPlayers: Int) -> NSMutableAttributedString {
        
        let staticAttributedString = NSMutableAttributedString(string: "Players on Bench")
        let spaceAttributedString  = NSMutableAttributedString(string: " ")
        
        let numberOfPlayersAttributedString = NSMutableAttributedString(string: String(numberOfPlayers))
        numberOfPlayersAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy), range: NSMakeRange(0, numberOfPlayersAttributedString.length))
        
        let staticStringAttributedString = staticAttributedString
        staticStringAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular), range: NSMakeRange(0, staticStringAttributedString.length))
        
        let combination = NSMutableAttributedString()
        
        //17 Players on Bench
        combination.append(numberOfPlayersAttributedString)
        combination.append(spaceAttributedString)
        combination.append(staticAttributedString)
        
        return combination
        
    }  //forPlayersOnBench
    
    func forPlayersOnIce(numberOfPlayers: Int) -> NSMutableAttributedString  {
        
        var staticAttributedString = NSMutableAttributedString()
        
        if numberOfPlayers > 1 {
            
            staticAttributedString = NSMutableAttributedString(string: "Players on Ice")
            
        } else {
            
            staticAttributedString = NSMutableAttributedString(string: "Player on Ice")
        }
        
        let spaceAttributedString  = NSMutableAttributedString(string: " ")
        
        let numberOfPlayersAttributedString = NSMutableAttributedString(string: String(numberOfPlayers))
        numberOfPlayersAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy), range: NSMakeRange(0, numberOfPlayersAttributedString.length))
        
        let staticStringAttributedString = staticAttributedString
        staticStringAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular), range: NSMakeRange(0, staticStringAttributedString.length))
        
        let combination = NSMutableAttributedString()
        
        //17 Players on Bench
        combination.append(numberOfPlayersAttributedString)
        combination.append(spaceAttributedString)
        combination.append(staticAttributedString)
        
        return combination
        
    }  //forPlayersOnIce
    
    func forFirstNameLastName( firstName: String, lastName: String) -> NSMutableAttributedString {
        
        let firstNameAttributedString = NSMutableAttributedString(string: firstName)
        firstNameAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.light), range: NSMakeRange(0, firstNameAttributedString.length))
        
        let lastNameAttributedString = NSMutableAttributedString(string: lastName)
        lastNameAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold), range: NSMakeRange(0, lastNameAttributedString.length))
        
        
        let combination = NSMutableAttributedString()
        
        let spaceAttributedString  = NSMutableAttributedString(string: " ")
        
        //Lucas Surette
        combination.append(firstNameAttributedString)
        combination.append(spaceAttributedString)
        combination.append(lastNameAttributedString)
        
        return combination
        
    }  //forFirstNameLastName
    
    func forTotalTimeOnIce(timeInSeconds: Int) -> NSMutableAttributedString {
        
        let timeOnIceAttributedString = NSMutableAttributedString(string: "ToI")
        timeOnIceAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy), range: NSMakeRange(0, timeOnIceAttributedString.length))
        
        let convertedTime = timeFormat.mmSS(totalSeconds: timeInSeconds)
        
        let iceTimeAttributedString = NSMutableAttributedString(string: convertedTime)
        iceTimeAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.thin), range: NSMakeRange(0, iceTimeAttributedString.length))
        
        
        let combination = NSMutableAttributedString()
        
        let spaceAttributedString  = NSMutableAttributedString(string: " ")
        
        //00:00
        combination.append(timeOnIceAttributedString)
        combination.append(spaceAttributedString)
        combination.append(iceTimeAttributedString)
        
        return combination
        
    }  //forTotalTimeOnIce
    
    func forNumberOfShifts(numberOfShifts: Int) -> NSMutableAttributedString {
        
        let shiftsAttributedString = NSMutableAttributedString(string: "Shifts")
        shiftsAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy), range: NSMakeRange(0, shiftsAttributedString.length))
        
        let numberOfShiftsAttributedString = NSMutableAttributedString(string: String(numberOfShifts))
        numberOfShiftsAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.thin), range: NSMakeRange(0, numberOfShiftsAttributedString.length))
        
        
        let combination = NSMutableAttributedString()
        
        let spaceAttributedString  = NSMutableAttributedString(string: " ")
        
        //00:00
        combination.append(shiftsAttributedString)
        combination.append(spaceAttributedString)
        combination.append(numberOfShiftsAttributedString)
        
        return combination
        
    }  //forNumberOfShifts
    
    func forTimeOnIce(timeInSeconds: Int) -> NSMutableAttributedString {
        
        let convertedTime = timeFormat.mmSS(totalSeconds: timeInSeconds)
        
        let iceTimeAttributedString = NSMutableAttributedString(string: convertedTime)
        iceTimeAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.heavy), range: NSMakeRange(0, iceTimeAttributedString.length))
        
        if timeInSeconds <= 30 {
            iceTimeAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSMakeRange(0, iceTimeAttributedString.length))
            
            //        } else if timeInSeconds > 15 && timeInSeconds <= 45 {
            //
            //            iceTimeAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.yellow, range: NSMakeRange(0, iceTimeAttributedString.length))
        } else if timeInSeconds > 30 {
            iceTimeAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSMakeRange(0, iceTimeAttributedString.length))
        }
        
        
        
        let combination = NSMutableAttributedString()
        
        
        //00:00
        
        combination.append(iceTimeAttributedString)
        
        return combination
        
    }  //forTimeOnIce
    
    func forFirstNameLastNameDivisionLevel( firstName: String, lastName: String, divsion: String, level: String) -> NSMutableAttributedString {
        
        let firstNameAttributedString = NSMutableAttributedString(string: firstName)
        firstNameAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.light), range: NSMakeRange(0, firstNameAttributedString.length))
        
        let lastNameAttributedString = NSMutableAttributedString(string: lastName)
        lastNameAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy), range: NSMakeRange(0, lastNameAttributedString.length))
        
        let divisionAttributedString = NSMutableAttributedString(string: divsion)
        divisionAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy), range: NSMakeRange(0, divisionAttributedString.length))
        
        let levelAttributedString = NSMutableAttributedString(string: level)
        levelAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy), range: NSMakeRange(0, levelAttributedString.length))
        
        
        let combination = NSMutableAttributedString()
        
        let spaceAttributedString  = NSMutableAttributedString(string: " ")
        let dashAttributedString  = NSMutableAttributedString(string: " - ")
        
        //Lucas Surette - Novice AA
        combination.append(firstNameAttributedString)
        combination.append(spaceAttributedString)
        combination.append(lastNameAttributedString)
        combination.append(dashAttributedString)
        combination.append(divisionAttributedString)
        combination.append(spaceAttributedString)
        combination.append(levelAttributedString)
        return combination
        
    }  //forFirstNameLastNameDivisionLevel
    
    func forDivisionLevel(divsion: String, level: String) -> NSMutableAttributedString {
        
        let divisionAttributedString = NSMutableAttributedString(string: divsion)
        divisionAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular), range: NSMakeRange(0, divisionAttributedString.length))
        
        let levelAttributedString = NSMutableAttributedString(string: level)
        levelAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular), range: NSMakeRange(0, levelAttributedString.length))
        
        
        let combination = NSMutableAttributedString()
        
        let spaceAttributedString  = NSMutableAttributedString(string: " ")
        
        //Lucas Surette
        combination.append(divisionAttributedString)
        combination.append(spaceAttributedString)
        combination.append(levelAttributedString)
        
        return combination
        
    }  //forDivisionLevel
    
    func poundNumberFirstNameLastName(number: String, firstName: String, lastName: String) -> NSMutableAttributedString {
        
        let numberAttributedString = NSMutableAttributedString(string: number)
        numberAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.regular), range: NSMakeRange(0, numberAttributedString.length))
        
        let poundAttributedString = NSMutableAttributedString(string: "#")
        poundAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light), range: NSMakeRange(0, poundAttributedString.length))
        poundAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: NSMakeRange(0, poundAttributedString.length))
        
        let firstNameAttributedString = NSMutableAttributedString(string: firstName)
        firstNameAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.light), range: NSMakeRange(0, firstNameAttributedString.length))
        
        let lastNameAttributedString = NSMutableAttributedString(string: lastName)
        lastNameAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.light), range: NSMakeRange(0, lastNameAttributedString.length))
        
        let combination = NSMutableAttributedString()
        let spaceAttributedString  = NSMutableAttributedString(string: " ")
        
        //#47 Lucas Surette
        combination.append(poundAttributedString)
        combination.append(numberAttributedString)
        combination.append(spaceAttributedString)
        combination.append(firstNameAttributedString)
        combination.append(spaceAttributedString)
        combination.append(lastNameAttributedString)
        
        return combination
        
    }  //forDivisionLevel
    
    
}  //CreateAttributedString
