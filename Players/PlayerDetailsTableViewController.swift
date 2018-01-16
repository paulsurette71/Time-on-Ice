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
    let calculate        = Calculate()
    let goFetch          = GoFetch()
    let roundedImageView = RoundedImageView()
    let camera           = Camera()
    
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
    
    //Arrays
    let shootsArray = ["Left", "Right"].sorted()
    let positionArray = ["Defense", "Goalie", "Left Wing", "Right Wing", "Centre", "Forward"].sorted()
    
    //Delegates
    var myDelegates: myDelegates?
    
    //App Delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundedImageView.setRounded(image: headShotImageView, colour: #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1))
        
        //NotificationCenter
        SetupNotificationCenter()
        
        //UITextFieldDelegate
        positionTextField.delegate = self
        shootsTextField.delegate   = self
        teamTextField.delegate     = self
        cityTextField.delegate     = self
        leagueTextField.delegate   = self
        levelTextField.delegate    = self
        divisionTextField.delegate = self
        
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //Check to see if the mandatory first name, last name and number are empty.
        guard !(firstNameTextField.text?.isEmpty)!, !(lastNameTextField.text?.isEmpty)!,!(numberTextField.text?.isEmpty)! else {
            //Found empty fields.
            return
        }
        
        if newPlayer {
            
            saveNewPlayer()
            
        } else {
            
            updatePlayer()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard (appDelegate.playerHeadShot != nil) else {
            
            tableView.reloadData()
        
            return
        }
        
        headShotImageView.image = appDelegate.playerHeadShot
        
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 3
        case 3:
            return 2
        default:
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0  //hide the first section
        } else {
            return 40
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        //http://stackoverflow.com/questions/19802336/changing-font-size-for-uitableview-section-headers
        
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        
        header.textLabel?.textColor     = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        header.textLabel?.font          = UIFont.systemFont(ofSize: 24, weight: .light)
        header.textLabel?.frame         = header.frame
        header.textLabel?.textAlignment = .left
        header.backgroundView?.backgroundColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
    }
    
    @IBAction func headShot(_ sender: Any) {
        
        camera.myDelegates = myDelegates
        camera.takePicture()
    
    }  //headShot
    
    
    @IBAction func birthdate(_ sender: UIDatePicker) {
        
        let birthdate = sender.date
        
        let age = calculate.birthDate(usingThisDate: birthdate)
        
        ageLabel.text = String(describing: age)
        
    }  //birthdate
    
    func saveNewPlayer() {
        
        do {
            
            let entity = NSEntityDescription.entity(forEntityName: "Players", in: managedContext)
            let player = Players(entity: entity!, insertInto: managedContext)
            
            player.firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            player.lastName  = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            player.number    = Int16((numberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)!
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
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
            
        }  //do
    }  //saveNewPlayer
    
    func updatePlayer()  {
        
        do {
            
            selectedPlayer?.firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            selectedPlayer?.lastName  = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            selectedPlayer?.number    = Int16((numberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)!
            selectedPlayer?.position  = positionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            selectedPlayer?.shoots    = shootsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            selectedPlayer?.city      = cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            selectedPlayer?.team      = teamTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            selectedPlayer?.league    = leagueTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            selectedPlayer?.level     = levelTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            selectedPlayer?.division  = divisionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            selectedPlayer?.height    = heightTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            selectedPlayer?.weight    = weightTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //HeadShot
            let headshot     = UIImageJPEGRepresentation(headShotImageView.image!, bestQuality) as NSData?
            selectedPlayer?.headshot  = headshot
            
            try selectedPlayer?.managedObjectContext?.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
        }
        
    }  //updatePlayer
    
    func showPopover(textField: UITextField, array: [Any], popoverTitle: String) {
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        
        let popoverViewController = rootViewController?.storyboard?.instantiateViewController(withIdentifier: "PopoverViewController") as! PopoverViewController
        
        popoverViewController.modalPresentationStyle = .popover
        popoverViewController.preferredContentSize   = CGSize(width: 150, height: 150)
        popoverViewController.dataToPassToPicker     = array
        popoverViewController.popoverTitle           = popoverTitle
        popoverViewController.sender                 = textField
        
        let popover = popoverViewController.popoverPresentationController!
        
        popover.delegate = self
        popover.permittedArrowDirections = .any
        popover.sourceView = textField
        popover.sourceRect = textField.bounds
        
        self.present(popoverViewController, animated: true, completion: nil)
        
    }  //showShotDetails
    
    func configureView() {
        
        // Update the user interface for the detail item.
        
        if let player = self.selectedPlayer {
            if let label = self.firstNameTextField {
                label.text = player.firstName
            }
            if let label = self.lastNameTextField {
                label.text = player.lastName
            }
            if let label = self.numberTextField {
                label.text = String(player.number)
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
            
            if let label = self.positionTextField {
                label.text = player.position
            }
            
            if let label = self.shootsTextField {
                label.text = player.shoots
            }
        }
    }  //configureView
    
    func calculateBirthDate(birthdate: Date) -> Int {
        
        let calendar = NSCalendar.current
        
        let components = calendar.dateComponents([.year], from: birthdate, to: Date())
        
        return components.year!
        
    }  //calculateBirthDate
    
    func SetupNotificationCenter()  {
        
        let positionNotificationCenter = NotificationCenter.default
        positionNotificationCenter.addObserver(forName:Notification.Name(rawValue:"Notification"),
                                               object:nil, queue:nil,
                                               using:updateLabel)
        
    }  //SetupNotificationCenter
    
    func updateLabel(notification:Notification) -> Void  {
        
        guard let userInfo = notification.userInfo, let value = userInfo["value"] else {
            print("No userInfo found in notification")
            return
        }
        
        let textField = (notification.object as! UITextField)
        textField.text = value as? String
        
    }  //updatePositionLabel
    
}  //PlayerDetailsTableViewController

extension PlayerDetailsTableViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        
        return .none
    }
} //extension

extension PlayerDetailsTableViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == shootsTextField {
            
            if (textField.text?.isEmpty)! {
                shootsTextField.text = shootsArray.first
            }
            
            showPopover(textField: shootsTextField, array: shootsArray, popoverTitle: "Shoots")
            
        } else if textField == positionTextField {
            
            if (textField.text?.isEmpty)! {
                positionTextField.text = positionArray.first
            }
            
            showPopover(textField: positionTextField, array: positionArray, popoverTitle: "Position")
            
        }
        
        if textField == teamTextField {
            
            let teamNames = goFetch.teamNames(managedContext: managedContext)
            
            guard teamNames.count != 0 else {
                return
            }
            
            showPopover(textField: teamTextField, array: teamNames.sorted(), popoverTitle: "Teams")
        }
        
        if textField == cityTextField {
            
            let cityNames = goFetch.city(managedContext: managedContext)
            
            guard cityNames.count != 0 else {
                return
            }
            
            showPopover(textField: cityTextField, array: cityNames.sorted(), popoverTitle: "City")
        }
        
        if textField == leagueTextField {
            
            let leagueNames = goFetch.league(managedContext: managedContext)
            
            guard leagueNames.count != 0 else {
                return
            }
            
            showPopover(textField: leagueTextField, array: leagueNames.sorted(), popoverTitle: "League")
        }
        
        if textField == levelTextField {
            
            let levelNames = goFetch.level(managedContext: managedContext)
            
            guard levelNames.count != 0 else {
                return
            }
            
            showPopover(textField: levelTextField, array: levelNames.sorted(), popoverTitle: "Level")
        }
        
        if textField == divisionTextField {
            
            let divisionNames = goFetch.division(managedContext: managedContext)
            
            guard divisionNames.count != 0 else {
                return
            }
            
            showPopover(textField: divisionTextField, array: divisionNames.sorted(), popoverTitle: "Division")
        }
        
        
    }  //textFieldDidBeginEditing
    
}  //extension
