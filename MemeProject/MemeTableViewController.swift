//
//  MemeTableViewController.swift
//  MemeProject
//
//  Created by Laura Evans on 8/18/15.
//  Copyright (c) 2015 Ivie. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme]!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData() // Reset table data
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! MemeTableViewCell
        let meme = memes[indexPath.row]
        
        cell.title.text = meme.top! + " ... " + meme.bottom!
        cell.memeImage.image = meme.originalImage
        
        //Style Text
        let textAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 15)!,
            NSStrokeWidthAttributeName : -3
        ]
        let attribTopText = NSAttributedString(string: meme.top!, attributes: textAttributes)
        let attribBottomText = NSAttributedString(string: meme.bottom!, attributes: textAttributes)
        cell.topMemeText.attributedText = attribTopText
        cell.bottomMemeText.attributedText = attribBottomText
                
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let memeDetailView = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        memeDetailView.meme = memes[indexPath.row]
        memeDetailView.memeIndex = indexPath.row
        navigationController!.pushViewController(memeDetailView, animated: true)
    }
    
    @IBAction func addMeme(sender: AnyObject) {
        let addMemeViewController = storyboard?.instantiateViewControllerWithIdentifier("EditMeme") as! EditMemeViewController
        presentViewController(addMemeViewController, animated: true, completion: nil)
    }
    
}
