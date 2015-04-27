//
//  MainViewController.swift
//  SmokeSignalMobileApp
//
//  Created by Harshita Gupta on 2/14/15.
//  Copyright (c) 2015 The Smoke Signal. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: DrawerController {
    
    override func viewDidLoad() {
        print("test")
        self.showsShadows = false
        
        self.leftDrawerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("sideMenuView") as? UIViewController
        
        
        self.centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("centerNavController") as? UIViewController
        
        setCenterControllerAndBarButton("centerViewList")
        
        println("start")
        println(self.centerViewController)
        println(self.centerViewController?.navigationController)
        println(self.centerViewController?.parentViewController)
        println("end")
        
    }
    
    func setCenterControllerAndBarButton(storyboardTag : String) {
        (self.centerViewController as! UINavigationController).viewControllers[0] = self.storyboard?.instantiateViewControllerWithIdentifier(storyboardTag) as! UIViewController!
        (self.centerViewController as! UINavigationController).viewControllers[0].navigationItem.leftBarButtonItem = DrawerBarButtonItem(target: self.parentViewController, action: "toggleLeft")

    }
    
    func toggleLeft() {
        
        if (self.openSide == DrawerSide.Left) {
            self.closeDrawerAnimated( true , completion: nil)

        }
        else {
            self.openDrawerSide(DrawerSide.Left, animated: true, completion: nil)
        }
    }
}