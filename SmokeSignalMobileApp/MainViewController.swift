//
//  MainViewController.swift
//  SmokeSignalMobileApp
//
//  Created by Harshita Gupta on 2/14/15.
//  Copyright (c) 2015 The Smoke Signal. All rights reserved.
//

import Foundation
import UIKit

class MainViewController : UIViewController {
    
    var paperFoldView : PaperFoldView?
    var centerViewController : UIViewController?
    var leftView : UIView?
    var centerView : UIView?
    
    override func viewDidLoad() {
        println("MainView Loaded")
       
        
        ///MAIN FRAME///////////////////////////////////////////////////////////////////
        var mainFrame : CGRect = CGRect(x: 0.0, y: 0.0, width: self.view!.frame.size.width, height: self.view!.frame.size.height)
        print("frame of view: ")
        println(mainFrame)
        ////////////////////////////////////////////////////////////////////////////////
        
        
        ///PAPER FOLD VIEW/////////////////////////////////////////////////////////////
        paperFoldView  = PaperFoldView(frame: mainFrame)
        print("paperfoldview:")
        println(paperFoldView)
        self.view.addSubview(paperFoldView!)
        ////////////////////////////////////////////////////////////////////////////////
        
        
        ///LEFT VIEW/////////////////////////////////////////////////////////////
        var leftFrame : CGRect = CGRect(x: 0.0, y: 0.0, width: 256, height: self.view!.frame.size.height)
        var leftViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("sideMenuView") as? UIViewController)
        leftView = leftViewController?.view!
        leftView!.frame = leftFrame
        print("leftview:")
        println(leftView)
        
        paperFoldView!.setLeftFoldContentView((leftView), foldCount: (3 as Int32), pullFactor: (0.9 as Float) )
        print("after setting leftView, left view's value:")
        println(paperFoldView?.leftFoldView)
        ////////////////////////////////////////////////////////////////////////////////

        
        ///CENTER VIEW/////////////////////////////////////////////////////////////
        var centerViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("centerNavController") as? UIViewController)
        centerView = centerViewController?.view!
        centerView!.frame = mainFrame
        print("centerview and frame:")
        println(centerView)
        
        
        paperFoldView!.setCenterContentView(centerView!)
        print("after setting contentView, content view's value:")
        println(paperFoldView?.contentView)
        ////////////////////////////////////////////////////////////////////////////////

        
        
        
    }
   
    
    func setCenterController(storyboardTag : String) {
        (self.centerViewController! as! UINavigationController).viewControllers[0] = self.storyboard?.instantiateViewControllerWithIdentifier(storyboardTag) as! UIViewController!
       // (self.centerViewController! as! UINavigationController).viewControllers[0].navigationItem.leftBarButtonItem = DrawerBarButtonItem(target: self.parentViewController, action: "toggleLeft")

    }
//
//    func toggleLeft() {
//        
//        if (self.openSide == DrawerSide.Left) {
//            self.closeDrawerAnimated( true , completion: nil)
//
//        }
//        else {
//            self.openDrawerSide(DrawerSide.Left, animated: true, completion: nil)
//        }
//    }
}