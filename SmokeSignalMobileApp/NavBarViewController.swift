//
//  NavBarViewController.swift
//  The Smoke Signal
//
//  Created by Harshita Gupta on 5/2/15.
//  Copyright (c) 2015 The Smoke Signal. All rights reserved.
//

import Foundation
import UIKit

class NavBarViewController : UIViewController {
    
    @IBOutlet var topImage: UIImageView!
    @IBOutlet var topLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awoke from nib", appendNewline: true)
        //self.backgroundColor
    }
        
}
