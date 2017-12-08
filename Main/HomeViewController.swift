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
    
    enum clockStatus: String {
        case on  = "Stop Clock"
        case off = "Start Clock"
    }
    
    let createAttributedString = CreateAttributedString()
    
    //timer
    var timer               = Timer()
    var timerCounter        = 0
    var runningTotalCounter = 0
    var shifts              = 0
    
    //UILabel
    @IBOutlet weak var playersOnBenchLabel: UILabel!
    @IBOutlet weak var clockStatusLabel: UILabel!
    @IBOutlet weak var playersOnIceLabel: UILabel!
    
    //UISwitch
    @IBOutlet weak var clockSwitch: UISwitch!
    
    //UITableView
    @IBOutlet weak var tableView: UITableView!
    
    //UICollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    //UIButton
    @IBOutlet weak var gameButton: UIButton!
    @IBOutlet weak var playersButton: UIButton!
    
    var tappedArray = [Int]()
    var playerArray = [Players]()
    
    //classes
    let timeFormat = TimeFormat()
    let goFetch    = GoFetch()
    
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
        tableView.rowHeight = 60
        
        // collectionView delegate
        collectionView.delegate   = self
        collectionView.dataSource = self
        
        //tableView delegate
        tableView.delegate   = self
        tableView.dataSource = self
        
        //collectionView Layout
        collectionViewLayout()
        
        //setupUI
        //        setupUI()
        
        //        let isAppAlreadyLaunchedOnce = IsAppAlreadyLaunchedOnce()
        //        let importPlayers            = ImportPlayers()
        //
        //        if !isAppAlreadyLaunchedOnce.isAppAlreadyLaunchedOnce() {
        //
        //            //Import Test data
        //           importPlayers.importPlayers()
        //
        //        }
        
        
    }  //viewDidLoad
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }  //didReceiveMemoryWarning
    
    @IBAction func toggleClock(_ sender: Any) {
        
        guard tappedArray.count > 0 else {
            
            clockSwitch.isEnabled = false
            
            return
        }
        
        clockSwitch.isEnabled = true
        
        if (sender as! UISwitch).isOn {
            
            clockStatusLabel.text = clockStatus.on.rawValue
            
            //start the timer
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
            
        } else {
            
            clockStatusLabel.text = clockStatus.off.rawValue
            timerCounter = 0
            
            //stop the timer
            stopTimer()
        }
    }
    
    @objc func startTimer() {
        
        guard tappedArray.count > 0 else {
            return
        }
        
        runningTotalCounter += 1
        timerCounter += 0
        
        //        for rows in tappedArray {
        //
        //            if shiftDetails.count > 0 {
        //
        //                print(shiftDetails, rows)
        //                //                shiftDetails[playerArray[rows]].timeOnIce += 1
        //
        //            }
        //            //            playerArray[rows].runningTimeOnIce += 1
        //            //            playerArray[rows].timeOnIce += 1
        //
        //            tableView.reloadData()
        //
        //        }  //rows
        
    }  //startTimer
    
    func stopTimer()  {
        
        clockStatusLabel.text = clockStatus.off.rawValue
        timer.invalidate()
    }
    
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
        
        //        showPopover(sender: sender as! UIButton, array: <#[Any]#>, popoverTitle: "Games")
    }
    
    @IBAction func selectPlayers(_ sender: Any) {
        
        let playerList = goFetch.player(managedContext: managedContext) // as? [[Players]]
        
        showPopover(sender: sender as! UIButton, array: playerList, popoverTitle: "Players")
    }
    
    func showPopover(sender: UIButton, array: [Players], popoverTitle: String) {
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        
        let playerPopoverTableViewController = rootViewController?.storyboard?.instantiateViewController(withIdentifier: "PlayerPopoverTableViewController") as! PlayerPopoverTableViewController
        
        playerPopoverTableViewController.modalPresentationStyle = .popover
        playerPopoverTableViewController.preferredContentSize   = CGSize(width: 350, height: 250)
        playerPopoverTableViewController.players     = array
        
        //Pass delegate
        playerPopoverTableViewController.myDelegates = myDelegates
        
        let popover = playerPopoverTableViewController.popoverPresentationController!
        
        popover.delegate = self
        popover.permittedArrowDirections = .any
        popover.sourceView = sender
        popover.sourceRect = sender.bounds
        
        self.present(playerPopoverTableViewController, animated: true, completion: nil)
        
    }  //showShotDetails
    
    func SetupNotificationCenter()  {
        ////print("\(self) -> \(#function)")
        
        let positionNotificationCenter = NotificationCenter.default
        positionNotificationCenter.addObserver(forName:Notification.Name(rawValue:"PlayersOnBench"),
                                               object:nil, queue:nil,
                                               using:notificationCenterData)
        
    }  //SetupNotificationCenter
    
    func notificationCenterData(notification:Notification) -> Void  {
        
        guard notification.object != nil else {
            print("En Garde")
            return
        }
        
        playerArray = notification.object as! [Players]
        
        //Update UI
        setupUI()
        
        //reload data into CollectionView
        collectionView.reloadData()
        
    }  //notificationCenterData
    
}  //ShotDetailsPopover

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //print("\(self) -> \(#function)")
        
        return 1
        
    }  //numberOfSections
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("\(self) -> \(#function)")
        
        return playerArray.count
        
    }  //numberOfItemsInSection
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "benchCell", for: indexPath) as! BenchCollectionViewCell
        
        cell.playerNumberLabel.text   = playerArray[indexPath.row].number
        cell.playerLastNameLabel.text = playerArray[indexPath.row].lastName
        
        if tappedArray.count > 0 {
            
            if tappedArray.contains(indexPath.row) {
                
                cell.cellBackgroundImageView.image = UIImage(named: "collectionviewcell_60x60_blue")
                
            } else {
                
                cell.cellBackgroundImageView.image = UIImage(named: "collectionviewcell_60x60_white")
                
            }
        }
        
        return cell
        
    }  //cellForItemAt
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! BenchCollectionViewCell
        
        if cell.cellBackgroundImageView.image == UIImage(named: "collectionviewcell_60x60_white") {
            
            cell.cellBackgroundImageView.image = UIImage(named: "collectionviewcell_60x60_blue")
            
            tappedArray.append(indexPath.row)
            
            //            playerArray[indexPath.row].timeOnIce = 0
            //            playerArray[indexPath.row].shifts += 1
            
            //            let currentShift = Shift(player: playerArray[indexPath.row], timeOnIce: 0, dateOnIce: Date())
            //
            //            shiftDetails.append(currentShift)
            //            shiftDetails[indexPath.row].timeOnIce = 0
            
        } else {
            
            cell.cellBackgroundImageView.image = UIImage(named: "collectionviewcell_60x60_white")
            
            //            cell.totalTimeOnIceLabel.text = timeFormat.mmSS(totalSeconds: playerArray[indexPath.row].runningTimeOnIce)
            //            cell.totalTimeOnIceLabel.text = timeFormat.mmSS(totalSeconds: shiftDetails[indexPath.row].timeOnIce)
            
            tappedArray = tappedArray.filter { $0 != indexPath.row }
            
            //If there is no one on the ice, stop and disable the clock.
            if tappedArray.count == 0 {
                
                clockSwitch.isOn      = false
                clockSwitch.isEnabled = false
                stopTimer()
            }
            
        }
        
        if tappedArray.count > 0 {
            
            clockSwitch.isEnabled = true
        }
        
        playersOnIceLabel.attributedText = createAttributedString.forPlayersOnIce(numberOfPlayers: tappedArray.count)
        
        //Update players on bench
        let playersOnBench = playerArray.count - tappedArray.count
        playersOnBenchLabel.attributedText = createAttributedString.forPlayersOnBench(numberOfPlayers: playersOnBench)
        
        appDelegate.storePlayersOnBench(playersOnBench: playerArray)
        
        tableView.reloadData()
        
    }  //didSelectItemAt
    
}  //extension


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("\(self) -> \(#function)")
        
        return 1
        
    }  //numberOfSections
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("\(self) -> \(#function)")
        
        return tappedArray.count
        
    }  //numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("\(self) -> \(#function)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playersOnIceTableViewCell", for: indexPath) as! PlayersOnIceTableViewCell
        
        
        //        let player = playerArray[tappedArray[indexPath.row]]
        
        
        //        cell.playerNumberLabel.text          = String(player.number)
        //        cell.playerNameLabel.attributedText  = createAttributedString.forFirstNameLastName(firstName: player.firstName, lastName: player.lastName)
        //        cell.playerTimerLabel.attributedText = createAttributedString.forTimeOnIce(timeInSeconds: player.timeOnIce)
        //        cell.timeOnIceLabel.attributedText   = createAttributedString.forTotalTimeOnIce(timeInSeconds: player.runningTimeOnIce)
        //        cell.shiftsLabel.attributedText      = createAttributedString.forNumberOfShifts(numberOfShifts: player.shifts)
        
        //        if shiftDetails.count > 0 {
        //
        //            print("tappedArray[indexPath.row] \(tappedArray[indexPath.row])")
        //            let shift = shiftDetails[indexPath.row]
        //            cell.playerTimerLabel.attributedText = createAttributedString.forTimeOnIce(timeInSeconds: shift.timeOnIce)
        //
        //        }
        
        
        
        return cell
    }  //cellForRowAt
    
}  //extension

extension HomeViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        ////print("\(self) -> \(#function)")
        
        return .none
    }
} //extension
