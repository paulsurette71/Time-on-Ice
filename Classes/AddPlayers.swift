//
//  AddPlayers.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-11-22.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import Foundation


struct Player {
    let firstName: String
    let lastName: String
    let position: Position
    let number: Int

}

struct Shift {
    let player: Player
    var timeOnIce: Int
    var dateOnIce: Date
}

class AddPlayers {
    
    func addTestPlayers() -> [Player] {
        
        var playerInformationArray = [Player]()
        
        let sidneyCrosby      = Player(firstName: "Sidney", lastName: "Crosby", position: .centre, number: 87)
        let alexOvechkin      = Player(firstName: "Alex", lastName: "Ovechkin", position: .leftWing, number: 8)
        let patrickKane       = Player(firstName: "Patrick", lastName: "Kane", position: .rightWing, number: 88)
        let stevenStamkos     = Player(firstName: "Steven", lastName: "Stamkos", position: .centre, number: 91)
        let jamieBenn         = Player(firstName: "Jamie", lastName: "Benn", position: .leftWing, number: 14)
        let johnTavares       = Player(firstName: "John", lastName: "Tavares", position: .centre, number: 91)
        let pkSubban          = Player(firstName: "P.K.", lastName: "Subban", position: .defense, number: 76)
        let jaromirJagr       = Player(firstName: "Jaromir", lastName: "Jagr", position: .rightWing, number: 68)
        let careyPrice        = Player(firstName: "Carey", lastName: "Price", position: .goalie, number: 31)
        let connorMcDavid     = Player(firstName: "Connor", lastName: "McDavid", position: .centre, number: 97)
        let vladimirTarasenko = Player(firstName: "Vladimir", lastName: "Tarasenko", position: .rightWing, number: 91)
        let henrikLundqvist   = Player(firstName: "Henrik", lastName: "Lundqvist", position: .goalie, number: 30)
        
        
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
        playerInformationArray.append(vladimirTarasenko)
        playerInformationArray.append(henrikLundqvist)
        
        return playerInformationArray.sorted(by: { $0.number > $1.number })
    }  //addTestPlayers
    
}  //AddPlayers
