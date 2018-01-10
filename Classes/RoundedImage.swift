//
//  RoundedImage.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-05.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import Foundation
import UIKit

class RoundedImageView: UIImageView {
    
    func setRounded(image: UIImageView, colour: UIColor) {
        
        //http://stackoverflow.com/questions/28074679/how-to-set-image-in-circle-in-swift
        
        image.layer.borderWidth = 2
        image.layer.masksToBounds = false
        image.layer.borderColor = colour.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
        
    }
}

