//
//  ViewController.swift
//  MemeProject
//
//  Created by Laura Evans on 8/11/15.
//  Copyright (c) 2015 Ivie. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    var editTopText: String?
    var editBottomText: String?
    var editImage: UIImage?
    var editedImageIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomText.delegate = self
        topText.delegate = self
        
        shareButton.enabled = false
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3
        ]
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        topText.textAlignment = NSTextAlignment.Center
        bottomText.textAlignment = NSTextAlignment.Center
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Enable camera button only if camera is available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        subscribeToKeyboardNotifications()
        
        // If image has been selected, enable top toolbar buttons
        if let image = imageView.image {
            shareButton.enabled = true
        }
        
        // If editing a previous meme, populate text fields with info
        if let editTopText = editTopText {
            topText.text = editTopText
            bottomText.text = editBottomText
            imageView.image = editImage
            shareButton.enabled = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func takeCameraImage(sender: AnyObject) {
        let cameraController = UIImagePickerController()
        cameraController.delegate = self
        cameraController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(cameraController, animated: true, completion: nil)
    }
    
    // Show Activity View Controller when Share Button is clicked
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        var memedImage = generateMemedImage()
        var meme = Meme(top: topText.text!, bottom: bottomText.text!, originalImage: imageView.image!, memedImage: memedImage)
        
        //TODO: define an instance of the ActivityViewController
        let shareMemeViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        presentViewController(shareMemeViewController, animated: true, completion: nil)
        
        shareMemeViewController.completionWithItemsHandler = {
            (success) in
            
            // Create the meme
            var meme = Meme(top: self.topText.text!, bottom: self.bottomText.text!, originalImage: self.imageView.image!, memedImage: memedImage)
            
            // Add it to the memes array in the Application delegate
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            
            
            //Add to meme array or replace if editing meme
            if let editedImageIndex = self.editedImageIndex {
                appDelegate.memes.removeAtIndex(editedImageIndex)
                appDelegate.memes.insert(meme, atIndex: editedImageIndex)
                self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
            } else {
                appDelegate.memes.append(meme)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Show selected image once viewer has picked an album image or taken a photo
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func generateMemedImage() -> UIImage
    {
        // Hide Toolbars
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Hide Toolbars
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        
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
        if bottomText.editing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.editing {
            view.frame.origin.y += getKeyboardHeight(notification)
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

