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

final class MainViewController: SWRevealViewController {
    
    override func viewDidLoad() {
        print("MainView loaded", terminator: "\n")
        self.frontViewController = self.storyboard!.instantiateViewControllerWithIdentifier("centerNavController") as UIViewController?
        
        self.rearViewController = self.storyboard!.instantiateViewControllerWithIdentifier("sideMenuView") as UIViewController?
        
        Singleton.sharedInstance.mainViewControllerReference = self
        
        print("frontViewController set to:", terminator: "")
        print(self.frontViewController, terminator: "\n")

        print("", terminator: "\n")
        print("rearViewController set to:", terminator: "")
        print(self.rearViewController, terminator: "\n")

        
        print("", terminator: "\n")
        print("first member of NavigationController", terminator: "")
        print((self.frontViewController as! UINavigationController).viewControllers[0], terminator: "\n")

        setCenterControllerAndBarButton("centerViewList")

    }
    
    func setCenterControllerAndBarButton(storyboardTag : String) {
        (self.frontViewController as! UINavigationController).viewControllers[0] = self.storyboard?.instantiateViewControllerWithIdentifier(storyboardTag) as UIViewController!

    }
}