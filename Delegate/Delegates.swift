//
//  Delegates.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-03.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import Foundation
import UIKit

protocol myDelegates {
    
    func storeGame(game: Games?)
    func storeGameCheckmarkIndexPathArray(indexPath: IndexPath?)
    func storePeriod(periodSelected: Period)
    func storeHeadShot(playerHeadShot: UIImage)
    
}  //myDelegates
