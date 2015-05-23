//
//  MainViewController.swift
//  SmokeSignalMobileApp
//
//  Created by Harshita Gupta on 2/14/15.
//  Copyright (c) 2015 The Smoke Signal. All rights reserved.
//

import Foundation
import UIKit
import Fabric
import Crashlytics

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

        setCenterControllerAndBarButton("centerViewList")

    }
    
    func setCenterControllerAndBarButton(storyboardTag : String) {
        (self.frontViewController as! UINavigationController).viewControllers[0] = self.storyboard?.instantiateViewControllerWithIdentifier(storyboardTag) as! UIViewController!

    }
}