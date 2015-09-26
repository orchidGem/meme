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
        
        self.tableView.reloadData() // Reset table data
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! MemeTableViewCell
        let meme = self.memes[indexPath.row]
        
        cell.title.text = meme.top! + " ... " + meme.bottom!
        cell.memeImage.image = meme.originalImage
        cell.topMemeText.text = meme.top
        cell.bottomMemeText.text = meme.bottom
                
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let memeDetailView = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        memeDetailView.meme = self.memes[indexPath.row]
        memeDetailView.memeIndex = indexPath.row
        self.navigationController!.pushViewController(memeDetailView, animated: true)
    }
    
    @IBAction func addMeme(sender: AnyObject) {
        let addMemeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditMeme") as! EditMemeViewController
        self.presentViewController(addMemeViewController, animated: true, completion: nil)
    }
    
}
