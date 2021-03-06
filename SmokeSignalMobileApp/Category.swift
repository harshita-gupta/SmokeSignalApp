//
//  Category.swift
//  SmokeSignalMobileApp
//
//  Created by Harshita Gupta on 2/15/15.
//  Copyright (c) 2015 The Smoke Signal. All rights reserved.
//

import Foundation
import UIKit

final class Category : NSObject {
    
    var slug: String?
    var catName : String?
    var highlightColor: UIColor?
    var width : CGFloat?//space title takes for navbar
    
    override init() {
        
    }
    
    init (slug_name: String) {
        super.init()
        self.slug = slug_name
        switch self.slug! {
        case "":
            catName = "the smoke signal"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.regular)
            width = 150.0
        case "about-us":
            catName = "About Us"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.regular)
            width = 165.0
        case "ae":
            catName = "Arts & Entertainment"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.ae)
            width = 202.0
        case "centerspread" :
            catName = "Centerspread"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.centerspread)
            width = 126.0
        case "news":
            catName = "News"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.news)
            width = 65.0
        case "feature":
            catName = "Feature"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.feautre)
            width = 74.0
        case "online-exclusives" :
            catName = "Online Exclusives"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.onlineExclusives)
            width = 150.0
        case "opinion" :
            catName = "Opinion"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.opinion)
            width = 70.0
        case "photos" :
            catName = "Photos"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.graphics)
            width = 75.0
        case "sports" :
            catName = "Sports"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.sports)
            width = 75.0
        default:
            catName = "the smoke signal"
            highlightColor = UIColor(rgba: "#" + Singleton.catColorHexes.regular)
            width = 165.0

        }
                
    }
    
}