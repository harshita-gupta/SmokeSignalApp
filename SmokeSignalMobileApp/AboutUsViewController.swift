//
//  AboutUsViewController.swift
//  SmokeSignalMobileApp
//
//  Created by Harshita Gupta on 2/15/15.
//  Copyright (c) 2015 The Smoke Signal. All rights reserved.
//

import Foundation
import UIKit

final class AboutUsViewController: UIViewController {
    
    @IBOutlet var mainTextView: UITextView!
    var currentCategory = Category(slug_name: "about-us")
    override func viewDidLoad() {
        //mainTextView.font = UIFont(name: "SegoeUI", size: 12)
        
       // mainTextView.attributedText
    }
    
    
}