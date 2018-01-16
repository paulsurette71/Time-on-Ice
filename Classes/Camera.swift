//
//  Camera.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2018-01-03.
//  Copyright © 2018 Surette, Paul. All rights reserved.
//

import Foundation
import UIKit

class Camera: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    //Delegates
    var myDelegates: myDelegates?
    
    let imagePickerController = UIImagePickerController()
    
    var rootViewController = UIApplication.shared.keyWindow?.rootViewController
    
    var headShot:UIImage?
    
    func takePicture() {
        
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
        imagePickerController.cameraCaptureMode = .photo
        imagePickerController.modalPresentationStyle = .fullScreen
        imagePickerController.delegate = self
        
        rootViewController?.present(imagePickerController, animated: true, completion: nil)
        
    }  //takePicture
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let resizedImage = resizeImage(image: info[UIImagePickerControllerOriginalImage] as! UIImage, newWidth: CGSize(width: 75, height: 75))
        
        myDelegates?.storeHeadShot(playerHeadShot: resizedImage)
        
        rootViewController?.dismiss(animated:true, completion: nil)
        
    }  //imagePickerController
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        rootViewController?.dismiss(animated:true, completion: nil)
        
    }  //imagePickerControllerDidCancel
    
    
    func resizeImage(image: UIImage, newWidth: CGSize) -> UIImage {
        
        let horizontalRatio = newWidth.width / image.size.width
        let verticalRatio = newWidth.height / image.size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
        
    }  //resizeImage
    
}  //Camera
