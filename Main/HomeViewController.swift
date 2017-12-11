//
//  HomeViewController.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-11-15.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class HomeViewController: UIViewController {
    
    //timer
    var timer               = Timer()
    var timerCounter        = 0
    
    //UILabel
    @IBOutlet weak var playersOnBenchLabel: UILabel!
    @IBOutlet weak var playersOnIceLabel: UILabel!
    
    //UITableView
    @IBOutlet weak var tableView: UITableView!
    
    //UICollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    //UIButton
    @IBOutlet weak var gameButton: UIButton!
    @IBOutlet weak var playersButton: UIButton!
    @IBOutlet weak var clockButton: UIButton!
    
    var tappedArray  = [[String:Int]]()
    var playerArray  = [Players]()
    var tappedButton = true
    var valueArray   = [Int]()
    var selectedPlayerIndexPathArray = [IndexPath]()
    
    //classes
    let timeFormat             = TimeFormat()
    let goFetch                = GoFetch()
    let showPopover            = ShowPopover()
    let createAttributedString = CreateAttributedString()
    
    //App Delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //coredata
    var managedContext: NSManagedObjectContext!
    
    //Delegates
    var myDelegates: myDelegates?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //NotifactionCenter
        SetupNotificationCenter()
        
        // Register collectionView cell classes
        collectionView.register(UINib(nibName: "BenchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "benchCell")
        collectionView.register(UINib(nibName: "AddPlayerToBenchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "addBenchCell")
        
        // Register tableView cell classes
        let cellNib = UINib(nibName: "PlayersOnIceTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "playersOnIceTableViewCell")
        tableView.rowHeight = 90
        
        // collectionView delegate
        collectionView.delegate   = self
        collectionView.dataSource = self
        
        //tableView delegate
        tableView.delegate   = self
        tableView.dataSource = self
        
        //collectionView Layout
        collectionViewLayout()
        
        let isAppAlreadyLaunchedOnce = IsAppAlreadyLaunchedOnce()
        let importPlayers            = ImportPlayers()
        let importGames              = ImportGames()
        
        if !isAppAlreadyLaunchedOnce.isAppAlreadyLaunchedOnce() {
            
            //Import Test data
            importPlayers.importPlayers()
            importGames.importGames()
            
        }
        
    }  //viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if appDelegate.game == nil  {
            
            clockButton.isEnabled = false
            
        } else {
            
            clockButton.isEnabled = true
        }
        
        
        
    }  //viewWillAppear
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }  //didReceiveMemoryWarning
    
    
    //    @IBAction func toggleClock(_ sender: Any) {
    //
    //        guard tappedArray.count > 0 else {
    //
    //            clockSwitch.isEnabled = false
    //
    //            return
    //        }
    //
    //        clockSwitch.isEnabled = true
    //
    //        if (sender as! UISwitch).isOn {
    //
    //            clockStatusLabel.text = clockStatus.on.rawValue
    //
    //            //start the timer
    //            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
    //
    //        } else {
    //
    //            clockStatusLabel.text = clockStatus.off.rawValue
    //            timerCounter = 0
    //
    //            //stop the timer
    //            stopTimer()
    //        }
    //    }
    
    //    @objc func startTimer() {
    //
    //        guard tappedArray.count > 0 else {
    //            return
    //        }
    //
    //        runningTotalCounter += 1
    //        timerCounter += 0
    //
    //        //        for rows in tappedArray {
    //        //
    //        //            if shiftDetails.count > 0 {
    //        //
    //        //                print(shiftDetails, rows)
    //        //                //                shiftDetails[playerArray[rows]].timeOnIce += 1
    //        //
    //        //            }
    //        //            //            playerArray[rows].runningTimeOnIce += 1
    //        //            //            playerArray[rows].timeOnIce += 1
    //        //
    //        //            tableView.reloadData()
    //        //
    //        //        }  //rows
    //
    //    }  //startTimer
    
    //    func stopTimer()  {
    //
    //        clockStatusLabel.text = clockStatus.off.rawValue
    //        timer.invalidate()
    //    }
    
    func collectionViewLayout() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        collectionView!.collectionViewLayout = layout
        
    }  //collectionViewLayout
    
    func setupUI () {
        
        playersOnBenchLabel.attributedText = createAttributedString.forPlayersOnBench(numberOfPlayers: playerArray.count)
        
    }  //setupUI
    
    //UIButtons
    
    @IBAction func selectGame(_ sender: Any) {
        
        let gameList = goFetch.games(managedContext: managedContext)
        
        guard gameList.count != 0 else {
            showPopover.forNoGames(view: self, sender: sender as! UIButton)
            return
        }
        
        showPopover.showPopoverForGames(sender: sender as! UIButton, array: gameList, popoverTitle: "Games", delegate: myDelegates!)
    }
    
    @IBAction func selectPlayers(_ sender: Any) {
        
        let playerList = goFetch.player(managedContext: managedContext) // as? [[Players]]
        
        guard playerList.count != 0 else {
            showPopover.forNoPlayers(view: self, sender: sender as! UIButton)
            return
        }
        
        showPopover.showPopoverForPlayers(sender: sender as! UIButton, array: playerList, popoverTitle: "Players", delegate: myDelegates!)
    }
    
    func SetupNotificationCenter()  {
        
        let positionNotificationCenter = NotificationCenter.default
        positionNotificationCenter.addObserver(forName:Notification.Name(rawValue:"PlayersOnBench"),
                                               object:nil, queue:nil,
                                               using:notificationCenterData)
        
    }  //SetupNotificationCenter
    
    func notificationCenterData(notification:Notification) -> Void  {
        
        guard notification.object != nil else {
            
            return
        }
        
        playerArray = notification.object as! [Players]
        
        //Update UI
        setupUI()
        
        //reload data into CollectionView
        collectionView.reloadData()
        
    }  //notificationCenterData
    
    
    @IBAction func clock(_ sender: Any) {
        
        let button = sender as! UIButton
        
        if tappedButton {
            
            tappedButton = false
            button.setImage(UIImage(named: "buttonClockStop"), for: .normal)
            
            startTimer()
            
        } else {
            
            tappedButton = true
            button.setImage(UIImage(named: "buttonClockStart"), for: .normal)
            
            stopTimer()
        }
        
    }  //clock
    
    func startTimer()  {
        
        //start the timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounters), userInfo: nil, repeats: true)
        
    }  //startTimer
    
    func stopTimer() {
        
        timer.invalidate()
    }  //stopTimer
    
    @objc func updateCounters() {
        
        timerCounter += 1
        
        for row in tappedArray.indices {
            
            tappedArray[row]["timeOnIce"]! += 1
        }
        
        //Update tableview
        tableView.reloadData()
        
        
    }  //updateCounters
    
    
    
}  //ShotDetailsPopover

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }  //numberOfSections
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return playerArray.count
        
    }  //numberOfItemsInSection
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "benchCell", for: indexPath) as! BenchCollectionViewCell
        
        cell.playerNumberLabel.text   = playerArray[indexPath.row].number
        cell.playerLastNameLabel.text = playerArray[indexPath.row].lastName
        
        if tappedArray.count > 0 {
            
            valueArray = []
            
            for value in tappedArray {
                
                valueArray.append(value["indexPath"]!)
                
                if valueArray.contains(indexPath.row) {
                    
                    cell.cellBackgroundImageView.image = UIImage(named: "collectionviewcell_60x60_blue")
                    
                } else {
                    
                    cell.cellBackgroundImageView.image = UIImage(named: "collectionviewcell_60x60_white")
                    
                } //if
                
            }  //for
            
        }  //if tappedArray.count
        
        return cell
        
    }  //cellForItemAt
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! BenchCollectionViewCell
        
        if cell.cellBackgroundImageView.image == UIImage(named: "collectionviewcell_60x60_white") {
            
            cell.cellBackgroundImageView.image = UIImage(named: "collectionviewcell_60x60_blue")
            
            let currentPlayerSelected = ["indexPath": indexPath.row, "timeOnIce": 0]
            
            tappedArray.append(currentPlayerSelected)
            
            selectedPlayerIndexPathArray.append(indexPath)
            
        } else {
            
            cell.cellBackgroundImageView.image = UIImage(named: "collectionviewcell_60x60_white")
            
            //Save to CoreData since the shift is over
            let selectedPlayerArray = tappedArray.filter { $0["indexPath"] == indexPath.row }
            
            let timeOnIce = selectedPlayerArray.first!["timeOnIce"]
            let row = selectedPlayerArray.first!["indexPath"]
            let currentPlayer = playerArray[row!]
            
            //Only save a shift if it's greater that 1s.
            if timeOnIce! > 0 {
                
                saveShift(player: currentPlayer, timeOnIce: timeOnIce!)
            }
            
            //Remove player from on ice.
            tappedArray = tappedArray.filter { $0["indexPath"] != indexPath.row }
            
            selectedPlayerIndexPathArray = selectedPlayerIndexPathArray.filter {$0 != indexPath }
        }
        
        if tappedArray.count > 0 {
            clockButton.isEnabled = true
        } else {
            clockButton.isEnabled = false
        }
        
//        print("On the ice \(selectedPlayerIndexPathArray)")
        myDelegates?.storePlayersOnIceIndexPathArray(indexPath: selectedPlayerIndexPathArray)
        
        playersOnIceLabel.attributedText = createAttributedString.forPlayersOnIce(numberOfPlayers: tappedArray.count)
        
        //Update players on bench
        let playersOnBench = playerArray.count - tappedArray.count
        playersOnBenchLabel.attributedText = createAttributedString.forPlayersOnBench(numberOfPlayers: playersOnBench)
        
        tableView.reloadData()
        
    }  //didSelectItemAt
    
    func saveShift(player:Players, timeOnIce: Int) {
        
        do {
            
            let game = appDelegate.game
            
            let entity = NSEntityDescription.entity(forEntityName: "Shifts", in: managedContext)
            let shifts = Shifts(entity: entity!, insertInto: managedContext)
            
            shifts.playersRelationship = player
            shifts.gameRelationship    = game
            
            shifts.timeOnIce           = Int16(timeOnIce)
            shifts.date                = Date() as NSDate
            
            //Save
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
            
        }  //do
        
    }  //saveShift
    
}  //extension


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }  //numberOfSections
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tappedArray.count
        
    }  //numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playersOnIceTableViewCell", for: indexPath) as! PlayersOnIceTableViewCell
        
        let player = playerArray[tappedArray[indexPath.row]["indexPath"]!]
        
        //        cell.playerNumberLabel.attributedText = createAttributedString.poundNumber(number: player.number!)
        cell.playerNameLabel.attributedText   = createAttributedString.poundNumberFirstNameLastName(number: player.number!, firstName: player.firstName!, lastName: player.lastName!)
        
        let timeOnIce = timeFormat.mmSS(totalSeconds: tappedArray[indexPath.row]["timeOnIce"]!)
        cell.playerTimerLabel.text = timeOnIce
        
        let results = goFetch.timeOnIceWithShifts(player: player, managedContext: managedContext)
        
        let totalTimeOnIce = timeFormat.mmSS(totalSeconds: results["timeOnIce"]!)
        cell.timeOnIceLabel.text = totalTimeOnIce
        
        if let shifts = results["shifts"] {
            cell.shiftsLabel.text = String(shifts)
        }
        
        return cell
        
    }  //cellForRowAt
    
}  //extension

extension HomeViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        
        return .none
    }
} //extension
