//
//  File.swift
//  FirebasePhotoPicker
//
//  Created by Sean Calkins on 4/27/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import Foundation
import Firebase

class Photo {
    
    var imagePngData: NSData?
    
    var key: String = ""
    
    var photoRef = Firebase(url: "https://cameraphotopicker.firebaseio.com/")
    
    var ref: Firebase?
    
    
    init (){}
    
    
    init(key: String, dict: [String: AnyObject]) {
        
        self.key = key
        
        if let dataStr = dict["imagePngData"] as? String {
            
            let decodedData = NSData(base64EncodedString: dataStr, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            
            if let data = decodedData {
                
                self.imagePngData = data
                
            }
            
        } else {
            
            print("Couldn't parse imagePngData")
            
        }
    }
    
    func save() {
        
      //  if let imageData = self.imagePngData {
            
          //  let imagePngDataString = String(data: imageData, encoding: NSUTF8StringEncoding)
        
        
        let base64String = imagePngData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
                let dict = [
                    
                    "imagePngData": base64String
                    
                ]
                
                
                let firebaseQuestion = self.photoRef.childByAutoId()
                
                firebaseQuestion.setValue(dict)
                
                print("saved")
        
    }
}