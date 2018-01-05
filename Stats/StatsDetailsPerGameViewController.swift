//
//  StatsDetailsPerGameViewController.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2018-01-04.
//  Copyright © 2018 Surette, Paul. All rights reserved.
//

import UIKit
import CoreData

class StatsDetailsPerGameViewController: UIViewController {
    
    //UIView
    //    @IBOutlet weak var barChartView: BasicBarChart!
    @IBOutlet weak var barChartView: LineChart!
    
    
    //UITableView
    @IBOutlet weak var tableView: UITableView!
    
    //coredata
    var managedContext: NSManagedObjectContext!
    
    //Passed from StatsPerGameViewController
    var player: Players?
    var game: Games?
    
    //classes
    let goFetch     = GoFetch()
    let convertDate = ConvertDate()
    let timeFormat  = TimeFormat()
    
    //data
    var results = [[String: Any]]()
    
    //barchart
    //    var barChartData: [BarEntry] = []
    var barChartData: [PointEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChartView.isCurved = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard player != nil else {
            
            return
        }
        
        self.title = (player?.firstName)! + " " + (player?.lastName)!
        
        results = goFetch.shiftsPerPlayerPerGame(player: player!, game: game!, managedContext: managedContext)
        print(results)
        
        /*
         
         for elements in array.indices {
         
         print(elements + 1)
         print(array[elements]["Age"]!)
         
         }
         
         */
        
        for index in results.indices {
            
            let timeOnIce = results[index]["timeOnIce"]
            
            let shiftNumber = String(index + 1)
            
            barChartData.append(PointEntry(value: timeOnIce as! Int, label: shiftNumber))
        }
        
        barChartView.dataEntries = barChartData
        
    }  //viewWillAppear
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension StatsDetailsPerGameViewController : UITableViewDelegate {
    
    
}

extension StatsDetailsPerGameViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }  //numberOfSections
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return results.count
        
    }  //numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatsDetailsPerGameCell", for: indexPath)
        
        // Configure the cell...
        
        let currentCell = results[indexPath.row]
        
        let currentDate = convertDate.convertDate(date: currentCell["date"] as! NSDate)
        let currentTimeOnIce = timeFormat.mmSS(totalSeconds: currentCell["timeOnIce"]! as! Int)
        
        cell.textLabel?.text = String(indexPath.row + 1) + " - " + String(currentTimeOnIce)
        cell.detailTextLabel?.text = currentDate
        
        return cell
        
    }  //cellForRowAt
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        
        header.textLabel?.textColor     = UIColor.black
        header.textLabel?.font          = UIFont.systemFont(ofSize: 24, weight: .light)
        header.textLabel?.frame         = header.frame
        header.textLabel?.textAlignment = .left
        header.backgroundView?.backgroundColor = UIColor(named: "gryphonGold")
        
    }  //willDisplayHeaderView
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard results.count != 0 else {
            
            return "No Shifts recorded"
        }
        
        let numberOfShiftsForPlayer = String(results.count) + " Shifts"
        
        return numberOfShiftsForPlayer
        
    }  //titleForHeaderInSection
    
    
    
    
}

