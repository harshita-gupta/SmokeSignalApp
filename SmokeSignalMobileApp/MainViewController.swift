//
//  MainViewController.swift
//  SmokeSignalMobileApp
//
//  Created by Harshita Gupta on 2/14/15.
//  Copyright (c) 2015 The Smoke Signal. All rights reserved.
//

import Foundation
import UIKit
//import Fabric
//import Crashlytics

class MainViewController: SWRevealViewController {
    
    override func viewDidLoad() {
        print("MainView loaded", appendNewline: true)
        self.frontViewController = self.storyboard!.instantiateViewControllerWithIdentifier("centerNavController") as UIViewController?
        
        self.rearViewController = self.storyboard!.instantiateViewControllerWithIdentifier("sideMenuView") as UIViewController?
        
        Singleton.sharedInstance.mainViewControllerReference = self
        
        print("frontViewController set to:", appendNewline: false)
        print(self.frontViewController, appendNewline: true)

        print("", appendNewline: true)
        print("rearViewController set to:", appendNewline: false)
        print(self.rearViewController, appendNewline: true)

        
        print("", appendNewline: true)
        print("first member of NavigationController", appendNewline: false)
        print((self.frontViewController as! UINavigationController).viewControllers[0], appendNewline: true)

        setCenterControllerAndBarButton("centerViewList")

    }
    
    func setCenterControllerAndBarButton(storyboardTag : String) {
        (self.frontViewController as! UINavigationController).viewControllers[0] = self.storyboard?.instantiateViewControllerWithIdentifier(storyboardTag) as UIViewController!

    }
}