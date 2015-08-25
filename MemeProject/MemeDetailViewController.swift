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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memeImage.image = meme.memedImage
    }
    
}
