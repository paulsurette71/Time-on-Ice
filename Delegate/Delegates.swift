//
//  Delegates.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-03.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import Foundation

protocol myDelegates {
    
    func storePlayersOnBench(playersOnBench: [Players])
    func storeCheckmarkIndexPathArray(indexPath: [IndexPath])
    func storeSelectedPlayers(selectedPlayers: [Players])
    
    
}  //myDelegates
