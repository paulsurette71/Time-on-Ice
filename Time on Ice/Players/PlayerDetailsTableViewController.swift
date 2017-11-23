//
//  PlayerDetailsTableViewController.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-11-20.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import UIKit

class PlayerDetailsTableViewController: UITableViewController {
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        header.textLabel?.textColor     = UIColor.black
        header.textLabel?.font          = UIFont.systemFont(ofSize: 24, weight: .heavy)
        header.textLabel?.frame         = header.frame
        header.textLabel?.textAlignment = .left
        //        header.backgroundView?.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func camera(_ sender: Any) {
    
    }  //camera
    
    @IBAction func birthdate(_ sender: UIDatePicker) {
        
        let birthdate = sender.date
        
        let age = calculate.birthDate(usingThisDate: birthdate)
        
        ageLabel.text = String(describing: age)
        
    }  //birthdate
    
}  //PlayerDetailsTableViewController
