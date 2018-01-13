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
        
        print("myDelegates \(String(describing: myDelegates))")
        
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
        imagePickerController.cameraCaptureMode = .photo
        imagePickerController.modalPresentationStyle = .fullScreen
        imagePickerController.delegate = self
        
        rootViewController?.present(imagePickerController, animated: true, completion: nil)
                
    }  //takePicture
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let resizedImage = resizeImage(image: info[UIImagePickerControllerOriginalImage] as! UIImage, newWidth: 500.0)
                
        myDelegates?.storeHeadShot(playerHeadShot: resizedImage)
        
        rootViewController?.dismiss(animated:true, completion: nil)
        
    }  //imagePickerController
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        rootViewController?.dismiss(animated:true, completion: nil)
        
    }  //imagePickerControllerDidCancel
    
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        //http://nshipster.com/image-resizing/
        
        let size = image.size.applying(CGAffineTransform(scaleX: 0.10, y: 0.10))
        let hasAlpha = false
        let scale: CGFloat = 3.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint(), size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
        
    }  //resizeImage
    
}  //Camera
