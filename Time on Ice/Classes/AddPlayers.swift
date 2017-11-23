//
//  AddPlayers.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-11-22.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import Foundation

enum Position: String {
    case lw = "Left Wing"
    case rw = "Right Wing"
    case c  = "Centre"
    case d  = "Defense"
    case g  = "Goalie"
}

struct PlayerInformation {
    let firstName: String
    let lastName: String
    let position: Position
    let number: String
}
class AddPlayers {
    
    func addTestPlayers() -> [PlayerInformation] {
        
        var playerInformationArray = [PlayerInformation]()
        
        let sidneyCrosby  = PlayerInformation.init(firstName: "Sidney", lastName: "Crosby", position: Position.c, number: "87")
        let alexOvechkin  = PlayerInformation.init(firstName: "Alex", lastName: "Ovechkin", position: Position.lw, number: "8")
        let patrickKane   = PlayerInformation.init(firstName: "Patrick", lastName: "Kane", position: Position.rw, number: "88")
        let stevenStamkos = PlayerInformation.init(firstName: "Steven", lastName: "Stamkos", position: Position.c, number: "91")
        let jamieBenn     = PlayerInformation.init(firstName: "Jamie", lastName: "Benn", position: Position.lw, number: "14")
        let johnTavares   = PlayerInformation.init(firstName: "John", lastName: "Tavares", position: Position.c, number: "91")
        let pkSubban      = PlayerInformation.init(firstName: "P.K.", lastName: "Subban", position: Position.d, number: "76")
        let jaromirJagr   = PlayerInformation.init(firstName: "Jaromir", lastName: "Jagr", position: Position.rw, number: "68")
        let careyPrice    = PlayerInformation.init(firstName: "Carey", lastName: "Price", position: Position.g, number: "31")
        let connorMcDavid = PlayerInformation.init(firstName: "Connor", lastName: "McDavid", position: Position.c, number: "97")
        
        
        playerInformationArray.append(sidneyCrosby)
        playerInformationArray.append(alexOvechkin)
        playerInformationArray.append(patrickKane)
        playerInformationArray.append(stevenStamkos)
        playerInformationArray.append(jamieBenn)
        playerInformationArray.append(johnTavares)
        playerInformationArray.append(pkSubban)
        playerInformationArray.append(jaromirJagr)
        playerInformationArray.append(careyPrice)
        playerInformationArray.append(connorMcDavid)
        
        return playerInformationArray
    }  //addTestPlayers
    
}  //AddPlayers