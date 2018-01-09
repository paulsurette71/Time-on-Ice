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
    
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    
    //coredata
    var managedContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<Games>!
    var selectedGame: Games?
    
    //classes
    var convertDate = ConvertDate()
    var showPopover = ShowPopover()
    
    //App Delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        
        if let fetchedObjects = fetchedResultsController.fetchedObjects?.count {
            
            if fetchedObjects == 0 {
                
                //Show popover if there are no games listed.
                showPopover.forNoGamesAdded(view: self, sender: addBarButtonItem)
            }
        }
        
        //Make sure the tableView is updated.
        tableView.reloadData()
        
    }  //viewWillAppear
    
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
    }  //numberOfSections
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
            
        }
        
        return sectionInfo.numberOfObjects
    }  //numberOfRowsInSection
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameInformationTableViewCell", for: indexPath) as! GameInformationTableViewCell
        
        let game = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withGame: game, indexPath: indexPath)
        
        return cell
        
    }  //cellForRowAt
    
    func configureCell(_ cell: GameInformationTableViewCell, withGame game: Games, indexPath: IndexPath) {
        
        let currentDate = convertDate.convertDate(date: (game.date)!)
        
        cell.dateLabel.text = currentDate
        cell.homeTeamLabel.text = game.homeTeamCity! + " " + game.homeTeamName!
        cell.visitingTeamLabel.text = game.visitorTeamCity! + " " + game.visitorTeamName! + " vs."
        
        //Show the game image if the game is selected.
        if  game == appDelegate.game {
            cell.gameImageView.isHidden = false
        } else {
            cell.gameImageView.isHidden = true
        }
        
    }  //configureCell

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let games = fetchedResultsController.object(at: indexPath)
        
        //Make sure you can't delete a game that's been selected.
        if games == appDelegate.game {
            return false
        } else {
            return true
        }
        
    }  //canEditRowAt
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let playerToDelete = fetchedResultsController.object(at:indexPath)
            managedContext.delete(playerToDelete)
            
            do {
                try managedContext.save()
                
            } catch let error as NSError {
                print("\(self) -> \(#function): Saving error: \(error), description: \(error.userInfo)")
            }  //do
            
        }  //if
        
    }  //editingStyle
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        updateGame(indexPath: indexPath)
        
    }  //didSelectRowAt
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        
        header.textLabel?.textColor     = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        header.textLabel?.font          = UIFont.systemFont(ofSize: 24, weight: .light)
        header.textLabel?.frame         = header.frame
        header.textLabel?.textAlignment = .left
        header.backgroundView?.backgroundColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
        
    }  //willDisplayHeaderView
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return "No Games"

        }

        let numberOfGamesForPlayer = String(sectionInfo.numberOfObjects) + " Games"

        return numberOfGamesForPlayer
                
    }  //titleForHeaderInSection

    
    func updateGame(indexPath: IndexPath)  {
        
        let game = self.fetchedResultsController.object(at: indexPath as IndexPath)
        
        let gameDetailsTableViewController = storyboard?.instantiateViewController(withIdentifier: "GameDetailsTableViewController") as! GameDetailsTableViewController
        
        gameDetailsTableViewController.selectedGame = game
        gameDetailsTableViewController.newGame      = false
        
        //This is for lookup popovers
        gameDetailsTableViewController.managedContext = managedContext
        
        self.navigationController?.pushViewController(gameDetailsTableViewController, animated: true)
        
    }  //updatePlayer
    
    
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
            print("GameInformationTableViewController Update")
            tableView?.reloadData()
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
