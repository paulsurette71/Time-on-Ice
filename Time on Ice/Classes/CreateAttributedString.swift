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
        
        let staticAttributedString = NSMutableAttributedString(string: "Players on Ice")
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
    
    func forPlayersOnIceBeingTimed( playerNumber: Int, firstName: String, lastName: String, position: Position) -> NSMutableAttributedString {
        
        let playerNumberAttributedString = NSMutableAttributedString(string: String(playerNumber))
        playerNumberAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.heavy), range: NSMakeRange(0, playerNumberAttributedString.length))
        
        let firstNameAttributedString = NSMutableAttributedString(string: firstName)
        firstNameAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.light), range: NSMakeRange(0, firstNameAttributedString.length))
        
        let dashAttributedString  = NSMutableAttributedString(string: "-")
        dashAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular), range: NSMakeRange(0, dashAttributedString.length))

        let lastNameAttributedString = NSMutableAttributedString(string: lastName)
        lastNameAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold), range: NSMakeRange(0, lastNameAttributedString.length))
        
        let positionAttributedString = NSMutableAttributedString(string: position.rawValue)
        positionAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular), range: NSMakeRange(0, positionAttributedString.length))
        
        let combination = NSMutableAttributedString()
        
        let spaceAttributedString  = NSMutableAttributedString(string: " ")

        
        //47 - Lucas Surette LW
        combination.append(playerNumberAttributedString)
        combination.append(spaceAttributedString)
        combination.append(dashAttributedString)
        combination.append(spaceAttributedString)
        combination.append(firstNameAttributedString)
        combination.append(spaceAttributedString)
        combination.append(lastNameAttributedString)
//        combination.append(spaceAttributedString)
//        combination.append(positionAttributedString)
        
        return combination
        
    }  //forPlayersOnIceBeingTimed
    
}  //CreateAttributedString
