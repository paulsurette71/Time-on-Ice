//
//  CoreDataStack.swift
//  myShotTracker
//
//  Created by Surette, Paul on 2017-02-01.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        
        // Default directory where the CoreDataStack will store its files
        
        let directory = NSPersistentContainer.defaultDirectoryURL()
        let url       = directory.appendingPathComponent(self.modelName + ".sqlite")
        
        //Show where CoreData files are stored
        print("url \(url)")
        
        
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores {
            (storeDescription, error) in
            
            if let error = error as NSError? {
                print("CoreDataStack|storeContainer: Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        
        
        
        return self.storeContainer.viewContext
        
    }()
    
    func saveContext() {
        
        guard managedContext.hasChanges else {
            return
        }
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("CoreDataStack|saveContext: Error Saving.  Unresolved error \(error), \(error.userInfo)")
        }
    }
}

