//
//  PeriodPopoverViewController.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2018-01-11.
//  Copyright © 2018 Surette, Paul. All rights reserved.
//

import UIKit

class PeriodPopoverViewController: UIViewController {
    
    @IBOutlet weak var picker: PeriodPicker!
    
    //Pass MainView
    var homeViewController: HomeViewController?
    
    //Delegates
    var myDelegates: myDelegates?
    
    //App Delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //Protocol
    var currentPeriod: Period?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard appDelegate.periodSelected != nil else {
            
            return
        }
        
        currentPeriod = appDelegate.periodSelected
        print(currentPeriod!)
        picker.setPickerToSelectedPeriod(currentPeriod: currentPeriod!)
        
    }  //viewWillAppear
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let currentScoreClockPeriod = selectedPeriodFromPicker()
        
        //Save the values from the score clock in the Delegate
        myDelegates?.storePeriod(periodSelected: currentScoreClockPeriod)
        
        let buttonImagesForState = ButtonImagesForState()
        buttonImagesForState.setButtonImages(period: currentScoreClockPeriod, viewController: homeViewController)
        
    }  //viewWillDisappear
    
    func selectedPeriodFromPicker () -> Period {
        
        let selectedPeriodRow = picker.selectedRow(inComponent: 0)
        
        var selectedPeriod: Period?
        
        switch selectedPeriodRow {
        case 0:
            selectedPeriod = .first
        case 1:
            selectedPeriod = .second
        case 2:
            selectedPeriod = .third
        case 3:
            selectedPeriod = .overtime
        default:
            selectedPeriod = .first
        }  //switch
        
        return selectedPeriod!
    }  //selectedPeriodFromPicker
    
    
}
