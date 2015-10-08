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
        
        let space: CGFloat = 0.1
        
        let dimension = (self.view.frame.size.width - (4 * space))  / 4.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
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
        
        //Style Text
        let textAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 15)!,
            NSStrokeWidthAttributeName : -3
        ]
        let attribTopText = NSAttributedString(string: meme.top!, attributes: textAttributes)
        let attribBottomText = NSAttributedString(string: meme.bottom!, attributes: textAttributes)
        cell.topText.attributedText = attribTopText
        cell.bottomText.attributedText = attribBottomText
        
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
