//
//  MemeCollectionViewController.swift
//  MemeProject
//
//  Created by Laura Evans on 8/25/15.
//  Copyright (c) 2015 Ivie. All rights reserved.
//

import Foundation

import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDataSource {

    
    var memes: [Meme]!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let space: CGFloat = 1.0
        
        let dimension = (self.view.frame.size.width) / 4.0
        
        println(self.view.frame.size.width)
        println(self.view.frame.size.height)
        println(dimension)
        
        //flowLayout.minimumInteritemSpacing = space
        //flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
                
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        self.collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.memedImage
        
        return cell

    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        detailController.memeIndex = indexPath.row
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    @IBAction func addMeme(sender: AnyObject) {
        let addMemeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditMeme") as! EditMemeViewController
        self.presentViewController(addMemeViewController, animated: true, completion: nil)
    }
    
}
