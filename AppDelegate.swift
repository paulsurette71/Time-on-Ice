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
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var coreDataStack = CoreDataStack(modelName: "Time On Ice")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let tabBarController = window?.rootViewController as! UITabBarController
        
        //Main Tab
        let navigationController  = tabBarController.viewControllers?[0] as! UINavigationController
        let homeViewController    = navigationController.viewControllers[0] as! HomeViewController
        
        //pass managedContext
        homeViewController.managedContext = coreDataStack.managedContext
        
        //Player Tab
        let playerNavigationController = tabBarController.viewControllers?[2] as! UINavigationController
        let playerInformationTableViewController = playerNavigationController.viewControllers[0] as! PlayerInformationTableViewController

        playerInformationTableViewController.managedContext = coreDataStack.managedContext
        
        //Game Tab
                
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
    
}

