//
//  HomeViewController.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-11-15.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //UITableView
    @IBOutlet weak var tableView: UITableView!
    
    //UICollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    var tappedArray = [Int]()
    
    //classes
    let addPlayers = AddPlayers()
    
    //temp array for test data
    var playerArray = [PlayerInformation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Register cell classes
        collectionView.register(UINib(nibName: "BenchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "benchCell")
        
        // collectionView delegate
        collectionView.delegate   = self
        collectionView.dataSource = self

        //tableView delegate
        tableView.delegate   = self
        tableView.dataSource = self
        
        //load in test data
        playerArray = addPlayers.addTestPlayers()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }  //didReceiveMemoryWarning
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }  //numberOfSections
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playerArray.count
        
    }  //numberOfItemsInSection
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "benchCell", for: indexPath) as! BenchCollectionViewCell
        
        cell.playerNumberLabel.text = playerArray[indexPath.row].number
        cell.playerFirstNameLabel.text = playerArray[indexPath.row].firstName
        cell.playerLastNameLabel.text = playerArray[indexPath.row].lastName
        cell.playerPositionLabel.text = playerArray[indexPath.row].position.rawValue
        
        return cell
        
    }  //cellForItemAt
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard !tappedArray.contains(indexPath.row) else {
            
            return
        }
        
        tappedArray.append(indexPath.row)
        
        tableView.reloadData()
        
    }  //didSelectItemAt
    
}  //extension


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tappedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playersTableViewCell", for: indexPath)
        
        cell.textLabel?.text = String(tappedArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tappedArray.remove(at: indexPath.row)
        tableView.reloadData()
    }

}  //extension
