//
//  SideMenuViewController.swift
//  SmokeSignalMobileApp
//
//  Created by Harshita Gupta on 2/14/15.
//  Copyright (c) 2015 The Smoke Signal. All rights reserved.
//

import Foundation
import UIKit
class SideMenuViewController: UITableViewController {
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //((self.parentViewController) as! MainViewController).toggleLeft()
        
        println("side menu row selected")
        
        // setting variable for center view at start of tap ---- idk if this will work but try
        var currentCenterController: UIViewController = (((self.parentViewController as! MainViewController).centerViewController) as! UINavigationController).viewControllers[0] as! UIViewController
        print(currentCenterController)
        
        // if on something other than about and about is selected, will switch to about
        if (indexPath.row == 9 &&  ((currentCenterController is AboutUsViewController) == false )) {
            (self.parentViewController as! MainViewController).setCenterController("centerViewAboutUs")
            return
        }
        
        // if on about and about is selected, will do nothing
        if (indexPath.row == 9 &&  (currentCenterController is AboutUsViewController)) {
            return
        }
        
        //if on about and another section is selected
        if (indexPath.row < 9 && (currentCenterController is AboutUsViewController) ) {
            println("yoyoyo")
            ((self.parentViewController as! MainViewController).centerViewController as! UINavigationController).viewControllers[0] = Singleton.sharedInstance.masterViewControllerReference
            Singleton.sharedInstance.posts = [NSMutableDictionary]()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                Singleton.sharedInstance.masterViewControllerReference.tableView.reloadData()
                print(self.giveSlugForSideMenuIndex(indexPath.row))
                Singleton.sharedInstance.masterViewControllerReference.refreshWithNewCatSort(self.giveSlugForSideMenuIndex(indexPath.row))
            })
            return
        }
        
        // therefore this only runs if on a section and another section is selected
        if (indexPath.row != giveIndexForCatSlug(Singleton.sharedInstance.masterViewControllerReference.currentCategory.slug!) ) {
            Singleton.sharedInstance.posts = [NSMutableDictionary]()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                Singleton.sharedInstance.masterViewControllerReference.tableView.reloadData()
            })
            
            var catLabel : String = giveSlugForSideMenuIndex(indexPath.row)
            
            if (indexPath.row < 9 ) {
                Singleton.sharedInstance.masterViewControllerReference.refreshWithNewCatSort(catLabel)
            }
        }
        
        
    }
    
    
    func giveSlugForSideMenuIndex (sideMenuIndex : Int) -> String {
        var catLabel : String
        switch sideMenuIndex {
        case 0:
            catLabel = ""
        case 1:
            catLabel = Singleton.catSlug.news
        case 2:
            catLabel = Singleton.catSlug.opinion
        case 3:
            catLabel = Singleton.catSlug.feature
        case 4:
            catLabel = Singleton.catSlug.centerspread
        case 5:
            catLabel = Singleton.catSlug.ae
        case 6:
            catLabel = Singleton.catSlug.sports
        case 7:
            catLabel = Singleton.catSlug.graphics
        case 8:
            catLabel = Singleton.catSlug.onlineExclusives
        case 9:
            catLabel = "about-us"
            /// DO FOR FAVORITES AND SETTINGS HERE
        default:
            catLabel = ""
        }
        return catLabel
    }
    
    func giveIndexForCatSlug (catSlug: String) -> Int {

        var catIndex : Int
        switch catSlug {
        case "":
            catIndex = 0
        case "ae":
            catIndex = 5
        case "centerspread" :
            catIndex = 4
        case "news":
            catIndex = 1
        case "feature":
            catIndex = 3
        case "online-exclusives" :
            catIndex = 8
        case "opinion" :
            catIndex = 2
        case "photos" :
            catIndex = 7
        case "sports" :
            catIndex = 6
        case "about-us" :
            catIndex = 9
        default :
            catIndex = 0
        }
        return catIndex
    }
    
    override func viewDidLoad() {
        println("side menu view loading started")

        var tableFrame = self.tableView.frame
        tableFrame.origin = CGPointMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y + 20)
        self.tableView.frame = tableFrame
        self.tableView.setTranslatesAutoresizingMaskIntoConstraints(true)

        println("side menu view loaded")
        
    }
}