//
//  MemeDetailViewController.swift
//  MemeProject
//
//  Created by Laura Evans on 8/24/15.
//  Copyright (c) 2015 Ivie. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memeImage: UIImageView!
    
    var meme: Meme!
    var memes: [Meme]!
    var memeIndex: Int!
    
    @IBOutlet weak var btnEdit: UIBarButtonItem!
    @IBOutlet weak var btnDelete: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memeImage.image = meme.memedImage
        self.navigationItem.description.isEmpty
        
        self.navigationItem.rightBarButtonItem = self.btnEdit
        var buttons: Array = [btnEdit, btnDelete]
        
        self.navigationItem.setRightBarButtonItems(buttons, animated: true)
        self.hidesBottomBarWhenPushed = true
    }
    
    @IBAction func deleteMeme(sender: AnyObject) {
        
        //TODO: Delete this meme
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.removeAtIndex(memeIndex)
        
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func editMeme(sender: AnyObject) {
        let addMemeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditMeme") as! EditMemeViewController
        
        addMemeViewController.editTopText = meme.top
        addMemeViewController.editBottomText = meme.bottom
        addMemeViewController.editImage = meme.originalImage
        addMemeViewController.editedImageIndex = memeIndex
        
        self.presentViewController(addMemeViewController, animated: true, completion: nil)
        self.navigationController!.popViewControllerAnimated(true)
    }
}
