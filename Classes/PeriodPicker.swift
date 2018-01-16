//
//  PeriodPicker.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2018-01-11.
//  Copyright © 2018 Surette, Paul. All rights reserved.
//

import Foundation
import UIKit

enum Period: String {
    
    case first    = "1st"
    case second   = "2nd"
    case third    = "3rd"
    case overtime = "Overtime"
    
}

class PeriodPicker: UIPickerView {
    
    //PickerView
    let periodArray = [Period.first, Period.second, Period.third, Period.overtime]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate   = self
        self.dataSource = self
        
    }
    
    func setPickerToSelectedPeriod(currentPeriod: Period) {
        
        var rowToSelect = 0
        
        switch currentPeriod {
        case .first:
            rowToSelect = 0
        case .second:
            rowToSelect = 1
        case .third:
            rowToSelect = 2
        case .overtime:
            rowToSelect = 3
            
        }
        
        self.selectRow(rowToSelect, inComponent: 0, animated: true)
    }
}

extension PeriodPicker: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return periodArray.count
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        return 150
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        
        //http://stackoverflow.com/questions/27455345/uipickerview-wont-allow-changing-font-name-and-size-via-delegates-attributedt
        
        let pickerLabel = UILabel()
        
        pickerLabel.textColor     = UIColor.black
        pickerLabel.text          = String(periodArray[row].rawValue)
        pickerLabel.font          = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.thin)
        pickerLabel.textAlignment = NSTextAlignment.center
        
        return pickerLabel
    }
    
}

extension PeriodPicker: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 35.0
    }  //rowHeightForComponent
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return String(describing: periodArray[row])
        
    }  //titleForRow
    
}

