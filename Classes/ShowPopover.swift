//
//  ShowPopover.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-08.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import Foundation
import UIKit

class ShowPopover: NSObject {
    
    func forNoPlayers(view: UIViewController,sender: UIButton) {
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        
        let noPlayerPopoverViewController = rootViewController?.storyboard?.instantiateViewController(withIdentifier: "NoPlayerPopoverViewController") as! NoPlayerPopoverViewController
        
        noPlayerPopoverViewController.modalPresentationStyle = .popover
        noPlayerPopoverViewController.preferredContentSize   = CGSize(width: 260, height: 100)
        
        let popover = noPlayerPopoverViewController.popoverPresentationController!
        
        popover.delegate = self
        popover.permittedArrowDirections = .any
        popover.sourceView = sender
        popover.sourceRect = sender.bounds
        
        rootViewController?.present(noPlayerPopoverViewController, animated: true, completion: nil)
        
    }  //showPeriodPopover
    
    
}

extension ShowPopover: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        
        return .none
    }
    
    
} //extension
