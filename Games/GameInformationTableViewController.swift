//
//  GameInformationTableViewController.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-05.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import UIKit
import CoreData

class GameInformationTableViewController: UITableViewController {
    
    //coredata
    var managedContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<Games>!
    var selectedGame: Games?
    
    //classes
    var convertDate = ConvertDate()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register tableView cell classes
        let cellNib = UINib(nibName: "GameInformationTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "gameInformationTableViewCell")
        tableView.rowHeight = 80
        
        goFetch()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        goFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goFetch() {
        
        let fetchRequest: NSFetchRequest<Games> = Games.fetchRequest()
        let sortDate   = NSSortDescriptor(key: #keyPath(Games.date), ascending: true)

        fetchRequest.sortDescriptors = [sortDate]
        fetchRequest.fetchBatchSize = 10
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetching error: \(error), \(error.userInfo)")
        }
    }  //goFetch


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
            
        }
        
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameInformationTableViewCell", for: indexPath) as! GameInformationTableViewCell
        
        let results = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withGame: results, indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        updateGame(indexPath: indexPath)
    }
    
    func updateGame(indexPath: IndexPath)  {
        
        
        let game = self.fetchedResultsController.object(at: indexPath as IndexPath)
                
        let gameDetailsTableViewController = storyboard?.instantiateViewController(withIdentifier: "GameDetailsTableViewController") as! GameDetailsTableViewController
        
        gameDetailsTableViewController.selectedGame = game
        gameDetailsTableViewController.newGame       = false
        
        //This is for lookup popovers
        gameDetailsTableViewController.managedContext = managedContext
        
        self.navigationController?.pushViewController(gameDetailsTableViewController, animated: true)
        
    }  //updatePlayer

    
    func configureCell(_ cell: GameInformationTableViewCell, withGame game: Games, indexPath: IndexPath) {
        
        
        let currentDate = convertDate.convertDate(date: (game.date)!)
        
        cell.dateLabel.text = currentDate
        cell.homeTeamLabel.text = game.homeTeamCity! + " " + game.homeTeamName! + " vs."
        cell.visitingTeamLabel.text = game.visitorTeamCity! + " " + game.visitorTeamName!
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let gameDetailsTableViewController = segue.destination as! GameDetailsTableViewController
        
        if segue.identifier == "newGameSegue" {
                        
            gameDetailsTableViewController.managedContext = managedContext
            gameDetailsTableViewController.newGame = true
            
        }
        
    }  //prepare
    
}

extension GameInformationTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!) as! GameInformationTableViewCell
            let results = fetchedResultsController.object(at: indexPath!)
            configureCell(cell, withGame: results, indexPath: indexPath!)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default: break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
} //extension
