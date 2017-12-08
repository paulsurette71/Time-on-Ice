//
//  AppDelegate.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-11-15.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, myDelegates {
    
    var window: UIWindow?
    
    lazy var coreDataStack = CoreDataStack(modelName: "Time On Ice")
    
    //classes
    let colourPalette = ColourPalette()
    
    //Delegates
    var playersOnBench: [Players]?
    var checkmarkIndexPath: [IndexPath]?
    var selectedPlayers: [Players]?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //print("\(self) -> \(#function)")
        // Override point for customization after application launch.
        
        //Pretty up the place
        colourPalette.changeAppearance()
        
        let tabBarController = window?.rootViewController as! UITabBarController
        
        //Main Tab
        let navigationController  = tabBarController.viewControllers?[0] as! UINavigationController
        let homeViewController    = navigationController.viewControllers[0] as! HomeViewController
        
        //pass managedContext
        homeViewController.managedContext = coreDataStack.managedContext
        homeViewController.myDelegates    = self
        
        //Player Tab
        let playerNavigationController = tabBarController.viewControllers?[2] as! UINavigationController
        let playerInformationTableViewController = playerNavigationController.viewControllers[0] as! PlayerInformationTableViewController
        
        playerInformationTableViewController.managedContext = coreDataStack.managedContext
        
        //Game Tab
        let gameNavigationController = tabBarController.viewControllers?[1] as! UINavigationController
        let gameInformationTableViewController = gameNavigationController.viewControllers[0] as! GameInformationTableViewController
        
        gameInformationTableViewController.managedContext = coreDataStack.managedContext
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        //print("\(self) -> \(#function)")
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //print("\(self) -> \(#function)")
        
        coreDataStack.saveContext()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        //print("\(self) -> \(#function)")
        
        coreDataStack.saveContext()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //print("\(self) -> \(#function)")
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        //print("\(self) -> \(#function)")
        
    }
    
    //Delegates
    func storePlayersOnBench(playersOnBench: [Players]) {
        
        self.playersOnBench = playersOnBench
        
    }
    
    func storeCheckmarkIndexPathArray(indexPath: [IndexPath]) {
        
        self.checkmarkIndexPath = indexPath
    }
    
    func storeSelectedPlayers(selectedPlayers: [Players]) {
        
        self.selectedPlayers = selectedPlayers
        
    }
    
}

