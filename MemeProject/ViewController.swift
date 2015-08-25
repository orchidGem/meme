//
//  ViewController.swift
//  MemeProject
//
//  Created by Laura Evans on 8/11/15.
//  Copyright (c) 2015 Ivie. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bottomText.delegate = self
        self.topText.delegate = self
        
        self.shareButton.enabled = false
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3
        ]
        self.topText.defaultTextAttributes = memeTextAttributes
        self.bottomText.defaultTextAttributes = memeTextAttributes
        self.topText.text = "TOP"
        self.bottomText.text = "BOTTOM"
        self.topText.textAlignment = NSTextAlignment.Center
        self.bottomText.textAlignment = NSTextAlignment.Center
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Enable camera button only if camera is available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        self.subscribeToKeyboardNotifications()
        
        // If image has been selected, enable top toolbar buttons
        if let image = self.imageView.image {
            self.shareButton.enabled = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Choose Picture and Show on Selection
    @IBAction func pickAnImage(sender: AnyObject) {
        // Present the Image Picker
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func takeCameraImage(sender: AnyObject) {
        let cameraController = UIImagePickerController()
        cameraController.delegate = self
        cameraController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(cameraController, animated: true, completion: nil)
    }
    
    // Show Activity View Controller when Share Button is clicked
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        var memedImage = generateMemedImage()
        var meme = Meme(top: topText.text!, bottom: bottomText.text!, originalImage: self.imageView.image!, memedImage: memedImage)
        
        //TODO: define an instance of the ActivityViewController
        let shareMemeViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        self.presentViewController(shareMemeViewController, animated: true, completion: nil)
        
        shareMemeViewController.completionWithItemsHandler = {
            (success) in
            
            // Create the meme
            var meme = Meme(top: self.topText.text!, bottom: self.bottomText.text!, originalImage: self.imageView.image!, memedImage: memedImage)
            
            // Add it to the memes array in the Application delegate
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.append(meme)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Show selected image once viewer has picked an album image or taken a photo
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func generateMemedImage() -> UIImage
    {
        // Hide Toolbars
        self.topToolbar.hidden = true
        self.bottomToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Hide Toolbars
        self.topToolbar.hidden = false
        self.bottomToolbar.hidden = false
        
        return memedImage
    }
    
    
    
    
    // TextField Delegate Behavior
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    
    
    //Move view up or down based on keyboard interaction
    func keyboardWillShow(notification: NSNotification) {
        if self.bottomText.editing {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.bottomText.editing {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
}

