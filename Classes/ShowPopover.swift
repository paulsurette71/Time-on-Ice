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
    
    func showPopoverForPlayers(sender: UIButton, array: [Players], popoverTitle: String, delegate: myDelegates) {
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        
        let playerPopoverTableViewController = rootViewController?.storyboard?.instantiateViewController(withIdentifier: "PlayerPopoverTableViewController") as! PlayerPopoverTableViewController
        
        playerPopoverTableViewController.modalPresentationStyle = .popover
        playerPopoverTableViewController.preferredContentSize   = CGSize(width: 350, height: 250)
        playerPopoverTableViewController.players     = array
        
        //Pass delegate
        playerPopoverTableViewController.myDelegates = delegate
        
        let popover = playerPopoverTableViewController.popoverPresentationController!
        
        popover.delegate = self
        popover.permittedArrowDirections = .any
        popover.sourceView = sender
        popover.sourceRect = sender.bounds
        
        rootViewController?.present(playerPopoverTableViewController, animated: true, completion: nil)
        
    }  //showShotDetails

    func showPopoverForGames(sender: UIButton, array: [Games], popoverTitle: String, delegate: myDelegates) {
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        
        let gamePopoverTableViewController = rootViewController?.storyboard?.instantiateViewController(withIdentifier: "GamePopoverTableViewController") as! GamePopoverTableViewController
        
        gamePopoverTableViewController.modalPresentationStyle = .popover
        gamePopoverTableViewController.preferredContentSize   = CGSize(width: 350, height: 250)
        gamePopoverTableViewController.games     = array
        
        //Pass delegate
        gamePopoverTableViewController.myDelegates = delegate
        
        let popover = gamePopoverTableViewController.popoverPresentationController!
        
        popover.delegate = self
        popover.permittedArrowDirections = .any
        popover.sourceView = sender
        popover.sourceRect = sender.bounds
        
        rootViewController?.present(gamePopoverTableViewController, animated: true, completion: nil)
        
    }  //showShotDetails

    func forNoGames(view: UIViewController,sender: UIButton) {
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        
        let noGamePopoverViewController = rootViewController?.storyboard?.instantiateViewController(withIdentifier: "NoGamePopoverViewController") as! NoGamePopoverViewController
        
        noGamePopoverViewController.modalPresentationStyle = .popover
        noGamePopoverViewController.preferredContentSize   = CGSize(width: 260, height: 100)
        
        let popover = noGamePopoverViewController.popoverPresentationController!
        
        popover.delegate = self
        popover.permittedArrowDirections = .any
        popover.sourceView = sender
        popover.sourceRect = sender.bounds
        
        rootViewController?.present(noGamePopoverViewController, animated: true, completion: nil)
        
    }  //forNoGames
    
}

extension ShowPopover: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        
        return .none
    }
    
    
} //extension
