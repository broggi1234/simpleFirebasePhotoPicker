//
//  ViewController.swift
//  FirebasePhotoPicker
//
//  Created by Sean Calkins on 4/27/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    let pickerController = UIImagePickerController()
    var arrayOfPhotos = [Photo]()
    var ref = Firebase(url: "https://cameraphotopicker.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.observePhotos()
    }
    
    //MARK: - Take picture tapped
    @IBAction func takePictureTapped(sender: UIBarButtonItem) {
        
        self.displayPickerController()
        
    }
    
    //MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfPhotos.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return self.view.frame.size.width
    }
    
    //setting up the cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if !self.arrayOfPhotos.isEmpty {
            
            let p = arrayOfPhotos[indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Photo Cell", forIndexPath: indexPath) as! CustomTableViewCell
            if let imageData = p.imagePngData {
                
                if let theImage = UIImage(data: imageData) {
                    
                    cell.photoCellImageView.image = theImage
                    
                } else {
                    
                    print("can't create image from data")
                }
            } else {
                print("bad image data")
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    //MARK: - Table View Delegate
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            if !self.arrayOfPhotos.isEmpty {
                
                let photo = arrayOfPhotos[indexPath.row]
                
                let photoRef = photo.ref
                
                self.arrayOfPhotos.removeAtIndex(indexPath.row)
                
                self.tableView.reloadData()
                
                //Delete image form firebase
                photoRef?.removeValue()
                
            }
        }
    }
    
    //MARK: - Take Picture Tapped
    func displayPickerController() {
        
        pickerController.delegate = self
        
        //checks if camera is available, if not look in photo library
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            pickerController.sourceType = .Camera
            pickerController.allowsEditing = true
            
        } else {
            
            pickerController.allowsEditing = true
            pickerController.sourceType = .PhotoLibrary
            
        }
        self.presentViewController(pickerController, animated: true) {
            
        }
    }
    
    //MARK: - Photo picker delegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        pickerController.dismissViewControllerAnimated(true) {
            
        }
    }
    
    //MARK: - Image picker controller
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            //converts image into data
            let pngData = UIImagePNGRepresentation(editedImage)
            
            let p = Photo()
            
            p.imagePngData = pngData
            
            p.save()
            
        }
        
        pickerController.dismissViewControllerAnimated(true) {
            
        }
    }
    
    // MARK: - Event Observer
    func observePhotos() {
        
        // Add observer for Events
        
        self.ref.observeEventType(.Value, withBlock: { snapshot in
            
            self.arrayOfPhotos.removeAll()
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    if let dict = snap.value as? [String: AnyObject] {
                        
                        let key = snap.key
                        
                        let photo = Photo(key: key, dict: dict)
                        
                        //Sets photo.ref to event url for accessing later
                        photo.ref = Firebase(url: "https://cameraphotopicker.firebaseio.com/\(key)")
                        
                        self.arrayOfPhotos.insert(photo, atIndex: 0)
                        
                        print(self.arrayOfPhotos.count)
                        
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
    
}

