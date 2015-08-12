//
//  Meme.swift
//  MemeProject
//
//  Created by Laura Evans on 8/12/15.
//  Copyright (c) 2015 Ivie. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var top: String?
    var bottom: String?
    var originalImage: UIImage
    var memedImage: UIImage
    
    init(top: String, bottom: String, originalImage: UIImage, memedImage: UIImage) {
        self.top = top
        self.bottom = bottom
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}

