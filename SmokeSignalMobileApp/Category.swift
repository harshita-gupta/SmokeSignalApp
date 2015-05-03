//
//  Category.swift
//  SmokeSignalMobileApp
//
//  Created by Harshita Gupta on 2/15/15.
//  Copyright (c) 2015 The Smoke Signal. All rights reserved.
//

import Foundation
import UIKit

class Category : NSObject {
    
    var slug: String?
    var catName : String?
    var highlightColor: UIColor?
    var navBarFinal: NavBarViewController?
    
    override init() {
        
    }
    
    func createNavBarView() {
        
        var navBarViewController = (NSBundle.mainBundle().loadNibNamed("NavBars", owner: self, options: nil)).last as! NavBarViewController
        
        
            navBarViewController.topLabel.text = self.catName!
        
        
        if self.slug! == "" {
            
        }
        else {
            navBarViewController.topImage.setTranslatesAutoresizingMaskIntoConstraints(true)
            var imFrame = navBarViewController.topImage.frame
            imFrame.size.width = 0
            imFrame.size.height = 0
            navBarViewController.topImage.frame = imFrame
        }
        
        navBarFinal = navBarViewController
        
    }
    
    init (slug_name: String) {
        super.init()
        self.slug = slug_name
        switch self.slug! {
        case "":
            catName = "the smoke signal"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.regular)
        case "about-us":
            catName = "About Us"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.regular)
        case "ae":
            catName = "Arts & Entertainment"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.ae)
        case "centerspread" :
            catName = "Centerspread"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.centerspread)
        case "news":
            catName = "News"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.news)
        case "feature":
            catName = "Feature"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.feautre)
        case "online-exclusives" :
            catName = "Online Exclusives"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.onlineExclusives)
        case "opinion" :
            catName = "Opinion"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.opinion)
        case "photos" :
            catName = "Photos"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.graphics)
        case "sports" :
            catName = "Sports"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.sports)
        default:
            catName = "the Smoke Signal"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.regular)
        }
        
        self.createNavBarView()
        
    }
    
}