//
//  AppDelegate.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-11-15.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, myDelegates {
    
    var window: UIWindow?
    
    lazy var coreDataStack = CoreDataStack(modelName: "Time On Ice")
    
    //classes
    let colourPalette = ColourPalette()
    
    //Delegates
    var game: Games?
    var gameIndexPath: IndexPath?
    var periodSelected: Period?
    var playerHeadShot: UIImage?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        //Firebase
        FirebaseApp.configure()
        
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
        playerInformationTableViewController.myDelegates = self  //For Camera HeadShots
        
        //Game Tab
        let gameNavigationController = tabBarController.viewControllers?[1] as! UINavigationController
        let gameInformationTableViewController = gameNavigationController.viewControllers[0] as! GameInformationTableViewController
        
        gameInformationTableViewController.managedContext = coreDataStack.managedContext
        
        //        //Stats Tab
        //        let statsNavigationController = tabBarController.viewControllers?[3] as! UINavigationController
        //        let statsInformationViewController = statsNavigationController.viewControllers[0] as! StatsInformationViewController
        //        
        //        statsInformationViewController.managedContext = coreDataStack.managedContext
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        coreDataStack.saveContext()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        coreDataStack.saveContext()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    //Delegates
    
    func storeGame(game: Games?) {
        
        self.game = game
    }
    
    func storeGameCheckmarkIndexPathArray(indexPath: IndexPath?) {
        
        self.gameIndexPath = indexPath
    }
    
    func storePeriod(periodSelected: Period) {
        
        self.periodSelected = periodSelected
        
    }
    
    func storeHeadShot(playerHeadShot: UIImage) {
        
        self.playerHeadShot = playerHeadShot
        
    }
    
}

