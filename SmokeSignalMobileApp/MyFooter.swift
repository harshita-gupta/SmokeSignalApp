//
//  MyFooter.swift
//  AsyncTableView
//
//  Created by ischuetz on 27/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation
import UIKit

class MyFooter : UIView {
    
    @IBOutlet var activityIndicator:UIActivityIndicatorView!
    
    override var isHidden:Bool {
        get {
            return super.isHidden
        }
        set(hidden) {
            super.isHidden = hidden

//            if self.activityIndicator {
//                if hidden {
//                    self.activityIndicator.startAnimating()
//                } else {
//                    self.activityIndicator.stopAnimating()
//                }
//            }
        }
    }
    
    override func awakeFromNib() {
        self.activityIndicator.startAnimating()
    }
}
