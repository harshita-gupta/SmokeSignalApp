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
    var topBanner: UIImage?
    
    
    override init() {
        
    }
    
    init (slug_name: String) {
        
        self.slug = slug_name
        switch self.slug! {
        case "":
            catName = "Recents"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.regular)
            topBanner = UIImage(named: Singleton.catBannerFileNames.regular)!
        case "about-us":
            catName = "About Us"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.regular)
            topBanner = nil
        case "ae":
            catName = "Arts & Entertainment"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.ae)
            topBanner = UIImage(named: Singleton.catBannerFileNames.ae)!
        case "centerspread" :
            catName = "Centerspread"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.centerspread)
            topBanner = UIImage(named: Singleton.catBannerFileNames.centerspread)!
        case "news":
            catName = "News"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.news)
            topBanner = UIImage(named: Singleton.catBannerFileNames.news)!
        case "feature":
            catName = "Feature"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.feautre)
            topBanner = UIImage(named: Singleton.catBannerFileNames.feature)!
        case "online-exclusives" :
            catName = "Online Exclusives"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.onlineExclusives)
            topBanner = UIImage(named: Singleton.catBannerFileNames.onlineExclusives)!
        case "opinion" :
            catName = "Opinion"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.opinion)
            topBanner = UIImage(named: Singleton.catBannerFileNames.opinion)!
        case "photos" :
            catName = "Photos"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.graphics)
            topBanner = UIImage(named: Singleton.catBannerFileNames.graphics)!
        case "sports" :
            catName = "Sports"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.sports)
            topBanner = UIImage(named: Singleton.catBannerFileNames.sports)!
        default:
            catName = ""
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.regular)
            topBanner = UIImage(named: Singleton.catBannerFileNames.regular)!
        }
        

        
    }
    
}