//
//  NavBarTitleView.swift
//  The Smoke Signal
//
//  Created by Harshita Gupta on 6/9/15.
//  Copyright © 2015 The Smoke Signal. All rights reserved.
//

import Foundation
import UIKit


class NavBarTitleView : UIView {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var image: UIImageView!
    
    
    init(frame: CGRect, title: String, imagePresent: Bool) {
        super.init(frame: frame)
        
        NSBundle.mainBundle().loadNibNamed("NavBars", owner: self, options: nil)
        
        self.addSubview(label)
        
        let bindings = ["label": label, "image": image]
        
        if (imagePresent) {
            self.addSubview(image)
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-0-[label]-0-[image]-0-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: bindings))
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[image]-0-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: bindings))
        }
        
        
        else {
            
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-0-[label]-0-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: bindings))
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[label]-0-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: bindings))
            
        }
        
        self.label.text = title
        self.label.sizeToFit()
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
