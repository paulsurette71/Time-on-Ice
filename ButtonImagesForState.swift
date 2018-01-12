//
//  ButtonImagesForState.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2018-01-11.
//  Copyright © 2018 Surette, Paul. All rights reserved.
//

import Foundation
import UIKit

class ButtonImagesForState {
    
    func setButtonImages(period: Period, viewController: HomeViewController!) {
        
        switch period {
        case .first:
            viewController.periodButton.setImage(#imageLiteral(resourceName: "buttonPeriod1st"), for: .normal)
            
        case .second:
            viewController.periodButton.setImage(#imageLiteral(resourceName: "buttonPeriod2nd"), for: .normal)
            
        case .third:
            viewController.periodButton.setImage(#imageLiteral(resourceName: "buttonPeriod3rd"), for: .normal)
            
        case .overtime:
            viewController.periodButton.setImage(#imageLiteral(resourceName: "buttonPeriodOT"), for: .normal)
            
        }  //switch
        
    }  //setButtonImages
    
}  //ButtonImagesForState
