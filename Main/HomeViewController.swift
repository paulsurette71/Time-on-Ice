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
    //    var timerCounter = 0
    
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
    
    var playersOnBench  = [Players]()
    var playersOnIce    = [Players]()
    
    var tappedButton = true
    //    var valueArray   = [Int]()
    var selectedPlayerIndexPathArray = [IndexPath]()
    //    var trackTimeOnInce = [Int]()
    
    //    //new
    //    var selectedPlayer = [Players]()
    //    var removedPlayer  = [Players]()
    
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
        tableView.rowHeight = 90
        
        // collectionView delegate
        collectionView.delegate   = self
        collectionView.dataSource = self
        
        //tableView delegate
        tableView.delegate   = self
        tableView.dataSource = self
        
        //collectionView Layout
        collectionViewLayout()
        
        //                let isAppAlreadyLaunchedOnce = IsAppAlreadyLaunchedOnce()
        //                let importPlayers            = ImportPlayers()
        //                let importGames              = ImportGames()
        //
        //                if !isAppAlreadyLaunchedOnce.isAppAlreadyLaunchedOnce() {
        //
        //                    //Import Test data
        //                    importPlayers.importPlayers()
        //                    importGames.importGames()
        //
        //                }
        
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
        
        showPopover.showPopoverForPlayers(sender: sender as! UIButton, array: playerList, popoverTitle: "Players", delegate: myDelegates!)
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
        
        //        guard notification.object != nil else {
        //
        //            return
        //        }
        
        playersOnBench = appDelegate.toPlay!
        
        print("\n")
        print("On Bench")
        print("########")
        for players in playersOnBench {
            print(players.lastName!)
        }
        
        //myDelegates?.playersOnBench(players: playersOnBench)
        
        //Update UI
        setupUI()
        
        //reload data into CollectionView
        collectionView.reloadData()
        
    }  //notificationCenterData
    
    func displayGameHeader(notification:Notification) -> Void {
        
        guard (appDelegate.game != nil) else {
            
            gameInformationLabel.text = "Welcome"
            gameDateInformationLabel.text = ""
            
            return
        }
        
        if let game = appDelegate.game {
            
            let homeTeam     = game.homeTeamCity
            let visitingTeam = game.visitorTeamCity
            let gameDate     = game.date
            
            gameInformationLabel.text = homeTeam! + " vs. " + visitingTeam!
            
            let currentDate = convertDate.convertDate(date: gameDate!)
            gameDateInformationLabel.text = currentDate
            
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
        
        //        timerCounter += 1
        
        for row in trackTimeOnInce.indices {
            
            trackTimeOnInce[row]["timeOnIce"]! += 1
        }
        
        print("trackTimeOnInce \(trackTimeOnInce)")
        
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
        
        //        if tappedArray.count > 0 {
        //
        //            valueArray = []
        //
        //            for value in tappedArray {
        //
        //                valueArray.append(value["indexPath"]!)
        //
        
        if selectedPlayerIndexPathArray.contains(indexPath) {
            
            cell.cellBackgroundImageView.image = UIImage(named: "collectionviewcell_60x60_blue")
            
        } else {
            
            cell.cellBackgroundImageView.image = UIImage(named: "collectionviewcell_60x60_white")
            
        }  //if
        
        
        //
        //            }  //for
        //
        //        }  //if tappedArray.count
        
        return cell
        
    }  //cellForItemAt
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! BenchCollectionViewCell
        
        configCollectionViewCell(cell: cell, indexPath: indexPath)
        
    }  //didSelectItemAt
    
    func configCollectionViewCell(cell: BenchCollectionViewCell, indexPath: IndexPath) {
        
        if cell.cellBackgroundImageView.image == UIImage(named: "collectionviewcell_60x60_white") {
            
            cell.cellBackgroundImageView.image = UIImage(named: "collectionviewcell_60x60_blue")
            
            playersOnIce.append(playersOnBench[indexPath.row])
            
            //Keep track of which players have a blue cell
            selectedPlayerIndexPathArray.append(indexPath)
            
            //            selectedPlayer.append(playerPicked)
            //
            //            for players in selectedPlayer {
            //
            //                if let index = playersOnBench.index(of: players)
            //                {
            //                    playersOnIce += [playersOnBench.remove(at: index)]
            //
            //                }
            //
            //            }
            
            
            
            
            /*
             
             let cardsPlayed = [1,3,2,8,7]
             
             for cards in cardsPlayed {
             
             if let index = cardsInHand.index(of: cards)
             {
             cardsOnTable += [cardsInHand.remove(at: index)]
             }
             }
             */
            
            //            print("This is the selected Player \(String(describing: playerOnBench[indexPath.row].lastName!))")
            //
            //            print("These are the players on the bench \n")
            //            for players in playerOnBench {
            //
            //                print("On Bench \(players.lastName!)")
            //            }
            //
            //            playerOnBench = playerOnBench.filter { $0 !=  playerOnBench[indexPath.row] }
            //
            //            print("These are the players on the bench \n")
            //            for players in playerOnBench {
            //
            //                print("On Bench \(players.lastName!)")
            //            }
            
            
            
            //            //Add player to the ice
            //            selectedPlayer.append(playerOnBench[indexPath.row])
            //            print("selectedPlayer \(String(describing: selectedPlayer))")
            //
            //            myDelegates?.playersOnIce(players: selectedPlayer)
            //
            //            //remove player from Bench
            //            removedPlayer = (selectedPlayer.filter { $0 != selectedPlayer[indexPath.row] })
            //            myDelegates?.playersOnBench(players: removedPlayer)
            
            let currentPlayerSelected = ["indexPath": indexPath.row, "timeOnIce": 0]
            
            trackTimeOnInce.append(currentPlayerSelected)
            //
            
            
            //            selectedPlayerIndexPathArray.append(indexPath)
            
            //                        //store player on ice in delegate so he can't be removed from the bench if he's on the ice
            //                        myDelegates?.storePlayersOnIceIndexPathArray(indexPath: selectedPlayerIndexPathArray)
            //
        } else {
            
            cell.cellBackgroundImageView.image = UIImage(named: "collectionviewcell_60x60_white")
            
            
            //   cardsInHand = cardsInHand.filter{!self.cardsOnTable.contains($0)}
            //tappedArray = tappedArray.filter { $0["indexPath"] != indexPath.row }\
            
            //            for players in selectedPlayer {
            //
            //                if let index = playersOnIce.index(of: players)
            //                {
            //                    playersOnBench += [playersOnIce.remove(at: index)]
            //
            //                }
            //            }
            
            
            
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
                
                //Remove player from on ice.
                //                tappedArray = tappedArray.filter { $0["indexPath"] != indexPath.row }
                
                //              selectedPlayerIndexPathArray = selectedPlayerIndexPathArray.filter {$0 != indexPath }
                //
                //            //store player on ice in delegate so he can't be removed from the bench if he's on the ice
                //            myDelegates?.storePlayersOnIceIndexPathArray(indexPath: selectedPlayerIndexPathArray)
                //            }
                
                playersOnIce = playersOnIce.filter { $0 != playersOnBench[indexPath.row] }
                
                selectedPlayerIndexPathArray = selectedPlayerIndexPathArray.filter {$0 != indexPath }
                
                trackTimeOnInce = trackTimeOnInce.filter { $0["indexPath"] != indexPath.row }

            }
            
            
            
        }
        
        //        print("\nselectedPlayer ")
        //        for player in selectedPlayer {
        //            print(player.lastName!)
        //        }
        //        print("\nPlayersOnBench ")
        //        for player in playersOnBench {
        //            print(player.lastName!)
        //        }
        //
        
        
        
        print("\nPlayersOnIce ")
        for player in playersOnIce {
            print(player.lastName!)
        }
        
        
        //       print("On Ice \(selectedPlayerIndexPathArray)")
        //
        //        print("tappedArray \(tappedArray)")
        //
        //        print("storePlayersOnIceIndexPathArray \(String(describing: appDelegate.playersOnIceIndexPathArray))")
        
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
        
        tableView.reloadData()
        
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
        
        // let player = playersOnBench[tappedArray[indexPath.row]["indexPath"]!]  //crash
        let player = playersOnIce[indexPath.row]
        
        
        cell.playerNameLabel.attributedText   = createAttributedString.poundNumberFirstNameLastName(number: player.number!, firstName: player.firstName!, lastName: player.lastName!)
        
        let timeOnIce = timeFormat.mmSS(totalSeconds: trackTimeOnInce[indexPath.row]["timeOnIce"]!)
        //        let timeOnIce = timeFormat.mmSS(totalSeconds: playersOnIce[indexPath.row])
        cell.playerTimerLabel.text = timeOnIce
        //
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
