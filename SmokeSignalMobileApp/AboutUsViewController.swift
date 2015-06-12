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
    
    
    func setBarButton() {
        print("starts setting leftBarButtonItem", appendNewline: true)
        self.navigationController?.navigationItem.leftBarButtonItem = DrawerBarButtonItem(target: self, action: "toggleLeft")
        print("leftBarButtonItem set to: ", appendNewline: false)
        print(self.navigationController?.navigationItem.leftBarButtonItem, appendNewline: true)
        print("finished setting leftBarButtonItem", appendNewline: true)
        print("", appendNewline: true)
        
    }
    
    func toggleLeft() {
        print("DrawerBarButtonItem tapped.", appendNewline: true)
        ((Singleton.sharedInstance.mainViewControllerReference) as SWRevealViewController).revealToggleAnimated(true)
    }

    
    
}