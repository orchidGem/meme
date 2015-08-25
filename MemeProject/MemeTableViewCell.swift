//
//  MemeTableViewCell.swift
//  MemeProject
//
//  Created by Laura Evans on 8/24/15.
//  Copyright (c) 2015 Ivie. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var topMemeText: UILabel!
    @IBOutlet weak var bottomMemeText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
