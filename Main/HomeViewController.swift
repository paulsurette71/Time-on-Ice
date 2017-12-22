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
    var timer        = Timer()
    
    //UILabel
    @IBOutlet weak var playersOnBenchLabel: UILabel!
    @IBOutlet weak var playersOnIceLabel: UILabel!
    @IBOutlet weak var gameInformationLabel: UILabel!
    @IBOutlet weak var gameDateInformationLabel: UILabel!
    
    //UITableView
    @IBOutlet weak var tableView: UITableView!
    
    //UICollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    //UIButton
    @IBOutlet weak var gameButton: UIButton!
    @IBOutlet weak var playersButton: UIButton!
    @IBOutlet weak var clockButton: UIButton!
    
    var trackTimeOnInce  = [[String:Int]]()
    
    var playersOnBench               = [Players]()
    var playersOnIce                 = [Players]()
    var tappedButton                 = true
    var selectedPlayerIndexPathArray = [IndexPath]()
    
    //classes
    let timeFormat             = TimeFormat()
    let goFetch                = GoFetch()
    let showPopover            = ShowPopover()
    let createAttributedString = CreateAttributedString()
    let convertDate            = ConvertDate()
    
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
        tableView.rowHeight = 75
        
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
            playersButton.isEnabled = false
            
        } else {
            
            clockButton.isEnabled = true
            playersButton.isEnabled = true
        }
        
    }  //viewWillAppear
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }  //didReceiveMemoryWarning
    
    func collectionViewLayout() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        collectionView!.collectionViewLayout = layout
        
    }  //collectionViewLayout
    
    func setupUI () {
        
        if playersOnBench.count > 0 {
            gameButton.isEnabled = false
        } else {
            gameButton.isEnabled = true
        }
        
        playersOnBenchLabel.attributedText = createAttributedString.forPlayersOnBench(numberOfPlayers: playersOnBench.count)
        
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
        
        let playerList = goFetch.player(managedContext: managedContext)
        
        guard playerList.count != 0 else {
            showPopover.forNoPlayers(view: self, sender: sender as! UIButton)
            return
        }
        
        showPopover.showPopoverForPlayers(sender: sender as! UIButton, array: playerList, popoverTitle: "Players", delegate: myDelegates!, managedContext: managedContext )
    }
    
    func SetupNotificationCenter()  {
        
        let positionNotificationCenter = NotificationCenter.default
        positionNotificationCenter.addObserver(forName:Notification.Name(rawValue:"PlayersOnBench"),
                                               object:nil, queue:nil,
                                               using:notificationCenterData)
        
        positionNotificationCenter.addObserver(forName:Notification.Name(rawValue:"GameNotification"),
                                               object:nil, queue:nil,
                                               using:displayGameHeader)
        
    }  //SetupNotificationCenter
    
    func notificationCenterData(notification:Notification) -> Void  {
        
        playersOnBench = appDelegate.toPlay!
        
        //Update UI
        setupUI()
        
        //reload data into CollectionView
        collectionView.reloadData()
        
       goFetch.playersOnBench(managedContext: managedContext)
        
    }  //notificationCenterData
    
    func displayGameHeader(notification:Notification) -> Void {
        
        guard (appDelegate.game != nil) else {
            
            gameInformationLabel.text     = "Welcome"
            gameDateInformationLabel.text = ""
            playersButton.isEnabled = false
            
            return
        }
        
        if let game = appDelegate.game {
            
            let homeTeam     = game.homeTeamCity
            let visitingTeam = game.visitorTeamCity
            let gameDate     = game.date
            
            gameInformationLabel.text = homeTeam! + " vs. " + visitingTeam!
            
            let currentDate = convertDate.convertDate(date: gameDate!)
            gameDateInformationLabel.text = currentDate
            
            playersButton.isEnabled = true
            
        }
    }  //displayGameHeader
    
    
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
        clockButton.setImage(UIImage(named: "buttonClockStart"), for: .normal)
        tappedButton = true
        
    }  //stopTimer
    
    @objc func updateCounters() {
        
        for row in trackTimeOnInce.indices {
            
            trackTimeOnInce[row]["timeOnIce"]! += 1
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
        
        return playersOnBench.count
        
    }  //numberOfItemsInSection
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "benchCell", for: indexPath) as! BenchCollectionViewCell
        
        cell.playerNumberLabel.text   = playersOnBench[indexPath.row].number
        cell.playerLastNameLabel.text = playersOnBench[indexPath.row].lastName
        
        
        let results = goFetch.timeOnIceWithShifts(player: playersOnBench[indexPath.row], managedContext: managedContext)
        
        let totalTimeOnIce = timeFormat.mmSS(totalSeconds: results["timeOnIce"]!)
        
        cell.totalTimeOnIceLabel.text = totalTimeOnIce
        
        if selectedPlayerIndexPathArray.contains(indexPath) {
            
            cell.cellBackgroundImageView.image = UIImage(named: "collectionviewcell_60x60_blue")
            
        } else {
            
            cell.cellBackgroundImageView.image = UIImage(named: "collectionviewcell_60x60_white")
            
        }  //if
        
        return cell
        
    }  //cellForItemAt
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! BenchCollectionViewCell
        
        configCollectionViewCell(cell: cell, indexPath: indexPath)
        
    }  //didSelectItemAt
    
    func configCollectionViewCell(cell: BenchCollectionViewCell, indexPath: IndexPath) {
        
        if cell.cellBackgroundImageView.image == UIImage(named: "collectionviewcell_60x60_white") {
            
            cell.cellBackgroundImageView.image = UIImage(named: "collectionviewcell_60x60_blue")
            
            //Keep track of which players are on the ice
            playersOnIce.append(playersOnBench[indexPath.row])
            
            //Keep track of which players have a blue cell
            selectedPlayerIndexPathArray.append(indexPath)
            
            let currentPlayerSelected = ["indexPath": indexPath.row, "timeOnIce": 0]
            
            trackTimeOnInce.append(currentPlayerSelected)
            
        } else {
            
            cell.cellBackgroundImageView.image = UIImage(named: "collectionviewcell_60x60_white")
            
            //Save to CoreData since the shift is over
            let selectedPlayerArray = trackTimeOnInce.filter { $0["indexPath"] == indexPath.row }
            
            if selectedPlayerArray.count > 0 {
                
                let timeOnIce = selectedPlayerArray.first!["timeOnIce"]  //crash
                let row = selectedPlayerArray.first!["indexPath"]
                let currentPlayer = playersOnBench[row!]
                
                //Only save a shift if it's greater that 1s.
                if timeOnIce! > 0 {
                    
                    saveShift(player: currentPlayer, timeOnIce: timeOnIce!)
                }
                
                //Remove player from ice
                playersOnIce = playersOnIce.filter { $0 != playersOnBench[indexPath.row] }
                
                //Remove cell from being selected
                selectedPlayerIndexPathArray = selectedPlayerIndexPathArray.filter {$0 != indexPath }
                
                //Reomve players time on ice tracking.
                trackTimeOnInce = trackTimeOnInce.filter { $0["indexPath"] != indexPath.row }
                
            }  //selectedPlayerArray.count
            
        }
        
        if playersOnIce.count > 0 {
            clockButton.isEnabled = true
        } else {
            clockButton.isEnabled = false
            stopTimer()
        }
        
        playersOnIceLabel.attributedText = createAttributedString.forPlayersOnIce(numberOfPlayers: playersOnIce.count)
        
        //Update players on bench
        let playersOnBenchCount = playersOnBench.count - playersOnIce.count
        playersOnBenchLabel.attributedText = createAttributedString.forPlayersOnBench(numberOfPlayers: playersOnBenchCount)
        
        //update the cells
        tableView.reloadData()
        collectionView.reloadData()
        
    }  //configCollectionViewCell
    
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
        
        //return tappedArray.count
        return playersOnIce.count
        
    }  //numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playersOnIceTableViewCell", for: indexPath) as! PlayersOnIceTableViewCell
        
        let player = playersOnIce[indexPath.row]
        
        cell.playerNameLabel.attributedText   = createAttributedString.poundNumberFirstNameLastName(number: player.number!, firstName: player.firstName!, lastName: player.lastName!)
        
        let timeOnIce = timeFormat.mmSS(totalSeconds: trackTimeOnInce[indexPath.row]["timeOnIce"]!)  //crash
        cell.playerTimerLabel.text = timeOnIce
        
        let results = goFetch.timeOnIceWithShifts(player: player, managedContext: managedContext)
        
        let totalTimeOnIce = timeFormat.mmSS(totalSeconds: results["timeOnIce"]!)
        cell.timeOnIceLabel.text = totalTimeOnIce
        
        if let shifts = results["shifts"] {
            cell.shiftsLabel.text = String(shifts)
            
            cell.averageTimeOnIceLabel.text = averageTimeOnIce(player: player, timeOnIce: results["timeOnIce"]!, shifts: shifts)
        }
        
        return cell
        
    }  //cellForRowAt
    
    func averageTimeOnIce(player: Players, timeOnIce: Int, shifts: Int) -> String {
        var returnValue = ""
        
        if shifts > 0 {
            
            let average = timeOnIce / shifts
            
            returnValue = timeFormat.mmSS(totalSeconds: average)
            
        } else {
            
            returnValue = ""
        }
        
        
        return returnValue
        
    }
    
}  //extension

extension HomeViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        
        return .none
    }
} //extension
