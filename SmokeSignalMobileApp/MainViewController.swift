//
//  MainViewController.swift
//  SmokeSignalMobileApp
//
//  Created by Harshita Gupta on 2/14/15.
//  Copyright (c) 2015 The Smoke Signal. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: SWRevealViewController {
    
    override func viewDidLoad() {
        println("MainView loaded")
        self.frontViewController = self.storyboard?.instantiateViewControllerWithIdentifier("centerNavController") as? UIViewController
        
        self.rearViewController = self.storyboard?.instantiateViewControllerWithIdentifier("sideMenuView") as? UIViewController
        
        Singleton.sharedInstance.mainViewControllerReference = self
        
        print("frontViewController set to:")
        println(self.frontViewController)

        println("")
        print("rearViewController set to:")
        println(self.rearViewController)

        
        println("")
        print("first member of NavigationController")
        println((self.frontViewController as! UINavigationController).viewControllers[0])

        panGestureRecognizer()
        setCenterControllerAndBarButton("centerViewList")

    }
    
    func setCenterControllerAndBarButton(storyboardTag : String) {
        (self.frontViewController as! UINavigationController).viewControllers[0] = self.storyboard?.instantiateViewControllerWithIdentifier(storyboardTag) as! UIViewController!
//        (self.frontViewController as! UINavigationController).viewControllers[0].navigationItem.leftBarButtonItem = DrawerBarButtonItem(target: self.parentViewController, action: "toggleLeft")

    }
    
//    func toggleLeft() {
//        self.revealToggleAnimated(true)
//    }
}