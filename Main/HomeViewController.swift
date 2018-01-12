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
    
    lazy var fetchedResultsControllerOnBench: NSFetchedResultsController<Players> = {
        
        let fetchRequest: NSFetchRequest<Players> = Players.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Players.number), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        let predicate               = NSPredicate(format: "%K = true", #keyPath(Players.onBench))
        fetchRequest.predicate      = predicate
        
        let fetchedResultsControllerOnBench = NSFetchedResultsController( fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsControllerOnBench.delegate = self
        
        return fetchedResultsControllerOnBench
    }()
    
    lazy var fetchedResultsControllerOnIce: NSFetchedResultsController<Players> = {
        
        let fetchRequest: NSFetchRequest<Players> = Players.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Players.number), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        let predicate               = NSPredicate(format: "%K = true", #keyPath(Players.onIce))
        fetchRequest.predicate      = predicate
        
        let fetchedResultsControllerOnIce = NSFetchedResultsController( fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsControllerOnIce.delegate = self
        
        return fetchedResultsControllerOnIce
    }()
    
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
    @IBOutlet weak var periodButton: UIButton!
    
    
    
    var tappedButton                 = true
    
    //classes
    let timeFormat             = TimeFormat()
    let goFetch                = GoFetch()
    let showPopover            = ShowPopover()
    let createAttributedString = CreateAttributedString()
    let convertDate            = ConvertDate()
    let reset                  = Reset()
    
    //App Delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //coredata
    var managedContext: NSManagedObjectContext!
    
    //Delegates
    var myDelegates: myDelegates?
    
    //Haptic Feedback
    let impactFeedbackGenerator = UIImpactFeedbackGenerator()
    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set the period
        myDelegates?.storePeriod(periodSelected: .first)
        
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
        let importShifts             = ImportShifts()
        
        if !isAppAlreadyLaunchedOnce.isAppAlreadyLaunchedOnce() {
            
            //Import Test data
            importPlayers.importPlayers()
            importGames.importGames()
            importShifts.importShifts()
            
        }
        
        reset.playersStoredData(managedContext: managedContext)
        
        //        //Go get the players on the bench
        //        goFetch.fetchPlayersOnIceOrBench(managedContext: managedContext, fetchedResultsController: fetchedResultsControllerOnBench)
        //
        //        //Go get the players on the ice
        //        goFetch.fetchPlayersOnIceOrBench(managedContext: managedContext, fetchedResultsController: fetchedResultsControllerOnIce)
        
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
        
        fetchAndReloadTableView()
        
        fetchAndReloadCollectionView()
        
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
        
        if let count = fetchedResultsControllerOnBench.fetchedObjects?.count  {
            
            if count > 0 {
                gameButton.isEnabled = false
            } else {
                gameButton.isEnabled = true
            }
            
            playersOnBenchLabel.attributedText = createAttributedString.forPlayersOnBench(numberOfPlayers: count)
            
        }  //if let
        
    }  //setupUI
    
    //UIButtons
    
    @IBAction func selectGame(_ sender: Any) {
        
        let gameList = goFetch.games(managedContext: managedContext)
        
        guard gameList.count != 0 else {
            showPopover.forNoGames(view: self, sender: sender as! UIButton)
            return
        }
        
        showPopover.showPopoverForGames(sender: sender as! UIButton, array: gameList, popoverTitle: "Games", delegate: myDelegates!)
        
    }  //selectGame
    
    @IBAction func selectPlayers(_ sender: Any) {
        
        let playerList = goFetch.player(managedContext: managedContext)
        
        guard playerList.count != 0 else {
            showPopover.forNoPlayers(view: self, sender: sender as! UIButton)
            return
        }
        
        showPopover.showPopoverForPlayers(sender: sender as! UIButton, array: playerList, popoverTitle: "Players", delegate: myDelegates!, managedContext: managedContext )
    }  //selectPlayers
    
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
        
        fetchAndReloadCollectionView()
        fetchAndReloadTableView()
        
        //Update UI
        self.setupUI()
        
    }  //notificationCenterData
    
    func fetchAndReloadTableView () {
        
        //Go get the players on the ice
        goFetch.fetchPlayersOnIceOrBench(managedContext: managedContext, fetchedResultsController: fetchedResultsControllerOnIce)
        
        tableView.reloadData()
        
    }
    
    func fetchAndReloadCollectionView () {
        
        //Go get the players on the bench
        goFetch.fetchPlayersOnIceOrBench(managedContext: managedContext, fetchedResultsController: fetchedResultsControllerOnBench)
        
        collectionView.reloadData()
        
    }
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
            impactFeedbackGenerator.impactOccurred()
            
        } else {
            
            tappedButton = true
            button.setImage(UIImage(named: "buttonClockStart"), for: .normal)
            
            stopTimer()
            //selection.selectionChanged()
            notificationFeedbackGenerator.notificationOccurred(.success)
            
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
        
        for players in fetchedResultsControllerOnIce.fetchedObjects! {
            
            players.runningTimeOnIce += 1
            
            tableView.reloadData()
            
        }
        
    }  //updateCounters
    
    @IBAction func period(_ sender: UIButton) {
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        
        let periodPopoverViewController = rootViewController?.storyboard?.instantiateViewController(withIdentifier: "PeriodPopoverViewController") as! PeriodPopoverViewController
        
//        scoreClockPopoverViewController.periodSelected         = periodSelected
//        scoreClockPopoverViewController.mainView               = mainView
//        scoreClockPopoverViewController.sender                 = sender
        periodPopoverViewController.modalPresentationStyle = .popover
        periodPopoverViewController.preferredContentSize   = CGSize(width: 100, height: 200)
        periodPopoverViewController.homeViewController     = self
        periodPopoverViewController.myDelegates = myDelegates
        
        
        let popover = periodPopoverViewController.popoverPresentationController!
        popover.delegate = self
        popover.permittedArrowDirections = .any
        
        popover.sourceView = sender
        popover.sourceRect = sender.bounds
        
        rootViewController?.present(periodPopoverViewController, animated: true, completion: nil)

        
        
    }  //period
    
    
}  //ShotDetailsPopover

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        guard let sections = fetchedResultsControllerOnBench.sections else {
            
            return 0
            
        }
        
        return sections.count
        
    }  //numberOfSections
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let sectionInfo = fetchedResultsControllerOnBench.sections?[section] else {
            
            return 0
            
        }
        
        return sectionInfo.numberOfObjects
        
    }  //numberOfItemsInSection
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "benchCell", for: indexPath) as! BenchCollectionViewCell
        
        let player = fetchedResultsControllerOnBench.object(at: indexPath)
        
        cell.playerNumberLabel.text   = String(player.number)
        cell.playerLastNameLabel.text = player.lastName
        
        let results = goFetch.timeOnIceWithShifts(player: player, game: appDelegate.game!, managedContext: managedContext)
        
        let totalTimeOnIce = timeFormat.mmSS(totalSeconds: results["timeOnIce"]!)
        
        cell.totalTimeOnIceLabel.text = totalTimeOnIce
        
//        DispatchQueue.main.async {
        
            if player.onIce {
                
                cell.cellBackgroundImageView.image = UIImage(named: "collectionviewcell_60x60_gray")
                
            } else {
                
                cell.cellBackgroundImageView.image = UIImage(named: "collectionviewcell_60x60_white")
            }
            
//        }
        
        return cell
        
    }  //cellForItemAt
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! BenchCollectionViewCell
        
        configCollectionViewCell(cell: cell, indexPath: indexPath)
        
    }  //didSelectItemAt
    
    func configCollectionViewCell(cell: BenchCollectionViewCell, indexPath: IndexPath) {
        
        let player = fetchedResultsControllerOnBench.object(at: indexPath)
        
        if player.onIce == false {
            
            saveOnIceStatus(player: player, managedContext: managedContext, onIce: true)
            
            player.runningTimeOnIce = 0
            

            
        } else if player.onIce == true {
            
            //Only save a shift if it's greater that 1s.
            if player.runningTimeOnIce > 0 {
                
                saveShift(player: player, timeOnIce: Int(player.runningTimeOnIce))
                
            }  //if timeOnIce!
            
            saveOnIceStatus(player: player, managedContext: managedContext, onIce: false)
            
        }  //else
        
        
        fetchAndReloadTableView()
        collectionView.reloadData()
        
        if let countPlayersOnIce = fetchedResultsControllerOnIce.fetchedObjects?.count {
            
            if countPlayersOnIce > 0 {
                
                clockButton.isEnabled = true
                
            } else {
                
                clockButton.isEnabled = false
                stopTimer()
            }
            
            playersOnIceLabel.attributedText = createAttributedString.forPlayersOnIce(numberOfPlayers: countPlayersOnIce)
            
            if let countPlayersOnBench = fetchedResultsControllerOnBench.fetchedObjects?.count {
                
                let playersOnBenchCount = countPlayersOnBench - countPlayersOnIce
                
                playersOnBenchLabel.attributedText = createAttributedString.forPlayersOnBench(numberOfPlayers: playersOnBenchCount)
                
            }  // if let countPlayersOnBench
            
        }  // if let countPlayersOnIce
        
    }  //configCollectionViewCell
    
    func saveOnIceStatus(player:Players, managedContext: NSManagedObjectContext, onIce: Bool) {
        
        do {
            
            player.onIce = onIce
            
            //Save
            try player.managedObjectContext?.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
            
        }  //do
        
    }  //saveOnBenchStatus
    
    
    func saveShift(player:Players, timeOnIce: Int) {
        
        do {
            
            let game = appDelegate.game
            
            let entity = NSEntityDescription.entity(forEntityName: "Shifts", in: managedContext)
            let shifts = Shifts(entity: entity!, insertInto: managedContext)
            
            shifts.playersRelationship = player
            shifts.gameRelationship    = game
            
            shifts.timeOnIce           = Int16(timeOnIce)
            shifts.date                = Date() as NSDate
            shifts.period              = appDelegate.periodSelected.map { $0.rawValue }
            
            //Save
            try managedContext.save()
            
        } catch let error as NSError {
            print("\(self) -> \(#function): Fetch error: \(error) description: \(error.userInfo)")
            
        }  //do
        
    }  //saveShift
    
}  //extension


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let sections = fetchedResultsControllerOnIce.sections else {
            return 0
            
        }
        
        return sections.count
        
    }  //numberOfSections
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sectionInfo = fetchedResultsControllerOnIce.sections?[section] else {
            return 0
            
        }
        
        return sectionInfo.numberOfObjects
        
    }  //numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playersOnIceTableViewCell", for: indexPath) as! PlayersOnIceTableViewCell
        
        let player = fetchedResultsControllerOnIce.object(at: indexPath)
        
        cell.playerNameLabel.attributedText   = createAttributedString.poundNumberFirstNameLastName(number: String(player.number), firstName: player.firstName!, lastName: player.lastName!)
        
        let timeOnIce = timeFormat.mmSS(totalSeconds: Int(player.runningTimeOnIce))
        cell.playerTimerLabel.text = timeOnIce
        
        let results = goFetch.timeOnIceWithShifts(player: player, game: appDelegate.game!, managedContext: managedContext)
        
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
    }  //averageTimeOnIce
    
}  //extension

extension HomeViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        
        return .none
    }
    
} //extension

extension HomeViewController: NSFetchedResultsControllerDelegate {
    
    //    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    //
    //        if controller == fetchedResultsControllerOnIce {
    //
    //            tableView.reloadData()
    //
    //        } else if controller == fetchedResultsControllerOnBench {
    //
    //            collectionView.reloadData()
    //
    //        }
    //
    //    }  //controllerDidChangeContent
    
}  //extension HomeViewController: NSFetchedResultsControllerDelegate
