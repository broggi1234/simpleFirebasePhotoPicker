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
            
            let data = dataStr.dataUsingEncoding(NSUTF8StringEncoding)
            
            if let data = data {
                
                self.imagePngData = data
                
            }
            
        } else {
            
            print("Couldn't parse imagePngData")
            
        }
    }
    
    func save() {
        
        let imagePngDataString = "\(self.imagePngData)"
        
        let dict = [
            
            "imagePngData": imagePngDataString
            
        ]
        
        let firebaseQuestion = self.photoRef.childByAutoId()
        
        firebaseQuestion.setValue(dict)
        
        print("saved")
    }

}