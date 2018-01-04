//
//  BarEntry.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2018-01-04.
//  Copyright © 2018 Surette, Paul. All rights reserved.
//

import Foundation
import UIKit

struct BarEntry {
    let color: UIColor
    
    /// Ranged from 0.0 to 1.0
    let height: Float
    
    /// To be shown on top of the bar
    let textValue: String
    
    /// To be shown at the bottom of the bar
    let title: String
}
