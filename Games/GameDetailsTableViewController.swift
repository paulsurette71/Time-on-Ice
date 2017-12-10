//
//  GameDetailsTableViewController.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-05.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import UIKit
import CoreData

class GameDetailsTableViewController: UITableViewController {
    
    //UIDatePicker
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //UITextField
    @IBOutlet weak var homeTeamCityTextField: UITextField!
    @IBOutlet weak var homeTeamNameTextField: UITextField!
    @IBOutlet weak var visitingTeamCityTextField: UITextField!
    @IBOutlet weak var visitingTeamNameTextField: UITextField!
    @IBOutlet weak var arenaCityTextField: UITextField!
    @IBOutlet weak var arenaNameTextField: UITextField!
    
    //coredata
    var managedContext: NSManagedObjectContext!
    var games: Games?
    
    var newGame = false
    
    var selectedGame: Games? {
        didSet {
            self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
    }  //viewDidLoad
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //Check to see if the mandatory first name, last name and number are empty.
        guard !(homeTeamCityTextField.text?.isEmpty)!, !(visitingTeamCityTextField.text?.isEmpty)! else {
            //Found empty fields.
            return
        }
        
        if newGame {
            
            saveNewGame()
            
        } else {
            
            updateGame()
        }
        
    }  //viewWillDisappear
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        //http://stackoverflow.com/questions/19802336/changing-font-size-for-uitableview-section-headers
        
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        
        header.textLabel?.textColor     = UIColor.black
        header.textLabel?.font          = UIFont.systemFont(ofSize: 24, weight: .light)
        header.textLabel?.frame         = header.frame
        header.textLabel?.textAlignment = .left
        header.backgroundView?.backgroundColor = UIColor(named: "gryphonGold")
    }
    
    func saveNewGame() {
        
        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Games", in: managedContext)
            let game = Games(entity: entity!, insertInto: managedContext)
            
            game.homeTeamCity    = homeTeamCityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            game.homeTeamName    = homeTeamNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            game.visitorTeamCity = visitingTeamCityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            game.visitorTeamName = visitingTeamNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            game.arenaCity       = arenaCityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            game.arenaName       = arenaNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            game.date            = datePicker.date as NSDate?
            
            //Save
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
            
        }  //do
    }  //saveNewPlayer
    
    func updateGame() {
        
        do {
            
            selectedGame?.homeTeamCity = homeTeamCityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            selectedGame?.homeTeamName = homeTeamNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            selectedGame?.visitorTeamCity = visitingTeamCityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            selectedGame?.visitorTeamName = visitingTeamNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            selectedGame?.arenaCity = arenaCityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            selectedGame?.arenaName = arenaNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            selectedGame?.date = datePicker.date as NSDate?
            
            try games?.managedObjectContext?.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
        }  //do
        
    }  //updateGame
    
    func configureView() {
        
        // Update the user interface for the detail item.
        
        if let game = self.selectedGame {
            
            if let picker = self.datePicker {
                picker.date = game.date! as Date
            }
            
            if let label = self.homeTeamNameTextField {
                label.text = game.homeTeamName
            }
            
            if let label = self.homeTeamCityTextField {
                label.text = game.homeTeamCity
            }
            
            if let label = self.visitingTeamNameTextField {
                label.text = game.visitorTeamName
            }
            
            if let label = self.visitingTeamCityTextField {
                label.text = game.visitorTeamCity
            }
            
            if let label = self.arenaNameTextField {
                label.text = game.arenaName
            }
            
            if let label = self.arenaCityTextField {
                label.text = game.arenaCity
            }
            
            
        }
    }  //configureView
}
