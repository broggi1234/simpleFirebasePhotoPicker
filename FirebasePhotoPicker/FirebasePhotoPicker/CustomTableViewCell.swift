//
//  CustomTableViewCell.swift
//  FirebasePhotoPicker
//
//  Created by Sean Calkins on 4/27/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var photoCellImageView: UIImageView!
    @IBOutlet weak var doubleTapLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    //MARK: - Properties
    let doubleTap = UITapGestureRecognizer()
    let singleTap = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField.hidden = true
        
        self.doubleTapLabel.alpha = 0
        
        singleTap.addTarget(self, action: #selector(self.handleSingleTap))
        
        doubleTap.addTarget(self, action: #selector(self.handleDoubleTap))
        
        singleTap.numberOfTapsRequired = 1
        
        doubleTap.numberOfTapsRequired = 2
        
        self.photoCellImageView.addGestureRecognizer(doubleTap)
        self.photoCellImageView.addGestureRecognizer(singleTap)
        
    }
    
    func handleSingleTap() {
        
        self.textField.hidden = !self.textField.hidden
        
    }
    
    func handleDoubleTap() {
        
        UIView.animateWithDuration(0.2, animations: {
            
            self.doubleTapLabel.alpha = 0.75
            
        }) { (animated) in
            
            UIView.animateWithDuration(0.2, animations: {
                
                self.doubleTapLabel.alpha = 0
                
            })
        }
    }
    
    
}

