//
//  Picker.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2017-12-01.
//  Copyright © 2017 Surette, Paul. All rights reserved.
//

import UIKit

class Picker: UIPickerView {
    
    var dataArray = [Any]()
    var textField = UITextField()
    
    //Protocol
    var myDelegates: myDelegates?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate   = self
        self.dataSource = self
    }
    
}  //Picker

extension Picker: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return dataArray.count
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
        pickerLabel.text          = dataArray[row] as? String
        pickerLabel.font          = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.thin)
        pickerLabel.textAlignment = NSTextAlignment.center
        
        return pickerLabel
    }  //forComponent
}

extension Picker: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 35.0
    }  //rowHeightForComponent
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return dataArray[row] as? String
        
    }  //titleForRow
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //NotificationCenter
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name:Notification.Name(rawValue:"Notification"),
                                object: textField,
                                userInfo: ["value" : dataArray[row]])
        
    }  //didSelectRow
    
}  //UIPickerViewDelegate
