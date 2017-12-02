//
//  PlayerDetailsTableViewController.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-11-20.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import UIKit
import CoreData

class PlayerDetailsTableViewController: UITableViewController {
    
    //UITextField
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var shootsTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var leagueTextField: UITextField!
    @IBOutlet weak var levelTextField: UITextField!
    @IBOutlet weak var divisionTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    //UIImageView
    @IBOutlet weak var headShotImageView: UIImageView!
    
    //UIButton
    @IBOutlet weak var cameraButton: UIButton!
    
    //UIDatePicker
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //UILabel
    @IBOutlet weak var ageLabel: UILabel!
    
    //Classes
    let calculate = Calculate()
    
    //JPEG Compresion
    let bestQuality:CGFloat = 1.0
    
    //coredata
    var managedContext: NSManagedObjectContext!
    
    var newPlayer = false
    
    var selectedPlayer: Players? {
        didSet {
            self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(self) -> \(#function)")
        
        //UITextFieldDelegate
        positionTextField.delegate = self
        shootsTextField.delegate   = self
        
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self) -> \(#function)")
        
        if newPlayer {
            
            saveNewPlayer()
            
        } else {
            
            updatePlayer()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self) -> \(#function)")
        
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        print("\(self) -> \(#function)")
        
        
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(self) -> \(#function)")
        
        
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 3
        case 3:
            return 2
        default:
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        print("\(self) -> \(#function)")
        
        
        if section == 0 {
            return 0  //hide the first section
        } else {
            return 40
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        print("\(self) -> \(#function)")
        
        
        //http://stackoverflow.com/questions/19802336/changing-font-size-for-uitableview-section-headers
        
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        
        header.textLabel?.textColor     = UIColor.black
        header.textLabel?.font          = UIFont.systemFont(ofSize: 24, weight: .heavy)
        header.textLabel?.frame         = header.frame
        header.textLabel?.textAlignment = .left
        header.backgroundView?.backgroundColor = UIColor(named: "gryphonGold")
    }
    
    @IBAction func camera(_ sender: Any) {
        print("\(self) -> \(#function)")
        
        
    }  //camera
    
    @IBAction func birthdate(_ sender: UIDatePicker) {
        print("\(self) -> \(#function)")
        
        
        let birthdate = sender.date
        
        let age = calculate.birthDate(usingThisDate: birthdate)
        
        ageLabel.text = String(describing: age)
        
    }  //birthdate
    
    func saveNewPlayer() {
        print("\(self) -> \(#function)")
        
        
        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Players", in: managedContext)
            let player = Players(entity: entity!, insertInto: managedContext)
            
            player.firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            player.lastName  = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            player.number    = numberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            player.position  = positionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            player.shoots    = shootsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            player.city      = cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            player.team      = teamTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            player.league    = leagueTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            player.level     = levelTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            player.division  = divisionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            player.height    = heightTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            player.weight    = weightTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //HeadShot
            let headshot     = UIImageJPEGRepresentation(headShotImageView.image!, bestQuality) as NSData?
            player.headshot  = headshot
            player.birthdate = datePicker.date as NSDate?
            
            //Save
            try managedContext.save()
            
        } catch let error as NSError {
            print("PlayerDetailsTableViewController|newPlayer: Fetch error: \(error) description: \(error.userInfo)")
            
        }  //do
    }  //saveNewPlayer
    
    func updatePlayer()  {
        
    }  //updatePlayer
    
    func showPopover(textField: UITextField, array: [Any], popoverTitle: String) {
        print("\(self) -> \(#function)")
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        
        let popoverViewController = rootViewController?.storyboard?.instantiateViewController(withIdentifier: "PopoverViewController") as! PopoverViewController
        
        popoverViewController.modalPresentationStyle = .popover
        popoverViewController.preferredContentSize   = CGSize(width: 150, height: 150)
        popoverViewController.dataToPassToPicker = array
        popoverViewController.popoverTitle = popoverTitle
        
        let popover = popoverViewController.popoverPresentationController!
        
        popover.delegate = self
        popover.permittedArrowDirections = .any
        popover.sourceView = textField
        popover.sourceRect = textField.bounds
        
        self.present(popoverViewController, animated: true, completion: nil)
        
    }  //showShotDetails
    
    func configureView() {
        print("\(self) -> \(#function)")
        
        // Update the user interface for the detail item.
        
        if let player = self.selectedPlayer {
            if let label = self.firstNameTextField {
                label.text = player.firstName
            }
            if let label = self.lastNameTextField {
                label.text = player.lastName
            }
            if let label = self.numberTextField {
                label.text = player.number
            }
            if let label = self.cityTextField {
                label.text = player.city
            }
            if let label = self.teamTextField {
                label.text = player.team
            }
            if let label = self.leagueTextField {
                label.text = player.league
            }
            if let label = self.levelTextField {
                label.text = player.level
            }
            if let label = self.divisionTextField {
                label.text = player.division
            }
            if let picker = self.datePicker {
                picker.date = player.birthdate! as Date
            }
            if let label = self.ageLabel {
                
                let birthdate = calculateBirthDate(birthdate: player.birthdate! as Date)
                label.text = String(describing: birthdate) //+ " years old"
            }
            
            if let label = self.weightTextField {
                label.text = player.weight
            }
            
            if let label = self.heightTextField {
                label.text = player.height
            }
            
            if let image = self.headShotImageView {
                
                image.image = UIImage(data:player.headshot! as Data,scale:1.0)
            }
        }
    }  //configureView
    
    func calculateBirthDate(birthdate: Date) -> Int {
        
        let calendar = NSCalendar.current
        
        let components = calendar.dateComponents([.year], from: birthdate, to: Date())
        
        return components.year!
        
    }
    
}  //PlayerDetailsTableViewController

extension PlayerDetailsTableViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        
        return .none
    }
} //extension

extension PlayerDetailsTableViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == shootsTextField {
            
            showPopover(textField: shootsTextField, array: [Shoots.both.rawValue, Shoots.left.rawValue, Shoots.right.rawValue], popoverTitle: "Shoots")
            
        } else if textField == positionTextField {
            
            showPopover(textField: positionTextField, array: [Position.centre.rawValue, Position.defense.rawValue, Position.goalie.rawValue, Position.leftWing.rawValue, Position.rightWing.rawValue], popoverTitle: "Position")
        }
        
        
    }  //textFieldDidBeginEditing
    
}  //extension
