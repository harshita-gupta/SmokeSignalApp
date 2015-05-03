//
//  Singleton.swift
//  SmokeSignalMobileApp
//
//  Created by Harshita Gupta on 1/25/15.
//  Copyright (c) 2015 The Smoke Signal. All rights reserved.
//

import Foundation
import UIKit

class Singleton {
  class var sharedInstance: Singleton {
    struct Static {
      static var instance: Singleton?
      static var token: dispatch_once_t = 0
    }

    dispatch_once(&Static.token) {
      Static.instance = Singleton()
    }

    return Static.instance!
  }
    
    struct catColorHexes {
        static var regular = "729977"
        static var ae = "9acd9b"
        static var centerspread = "9acd9b"
        static var feautre = "9acd9b"
        static var news = "9acd9b"
        static var onlineExclusives = "9acd9b"
        static var opinion = "9acd9b"
        static var graphics = "9acd9b"
        static var sports = "9acd9b"
    }
    
    struct catSlug {
        static var ae = "ae"
        static var centerspread = "centerspread"
        static var feature = "feature"
        static var news = "news"
        static var newsbytes = "newsbytes"
        static var onlineExclusives = "online-exclusives"
        static var blogs = "blog"
        static var humans = "homsj"
        static var opinion = "opinion"
        static var graphicOps = "graphicops"
        static var graphics = "photos"
        static var sports = "sports"
    }
    
    struct catBannerFileNames {
        static var about = "About Us Banner.png"
        static var ae = "Arts & Entertainment Banner.png"
        static var centerspread = "Centerspread Banner.png"
        static var favorites = "Favorites Banner.png"
        static var feature = "Feature Banner.png"
        static var news = "News Banner.png"
        static var onlineExclusives = "Online Exclusives Banner.png"
        static var opinion = "Opinion Banner.png"
        static var graphics = "Photo Banner.png"
        static var recent = "Recent Banner.png"
        static var sports = "Sports Banner.png"
        static var settings = "Settings Banner.png"
        static var regular = "SMOKIE LOGO Banner.png"
    }
    
    var currColor : UIColor = UIColor(rgba: Singleton.catColorHexes.regular)
    
    var posts : [NSMutableDictionary] = [NSMutableDictionary]()
    var currIndex = Int()
    var masterViewControllerReference = MasterViewController()
    var universalCSS : NSString = "p { font-family: \"Segoe UI\"; src: url(\"Regular.eot?\") format(\"eot\"),url(\"Regular.woff\") format(\"woff\"),url(\"Regular.ttf\") format(\"truetype\");} i {    font-family: \"Segoe UI\";    src: url(\"Italic.eot?\") format(\"eot\"),    url(\"Italic.woff\") format(\"woff\"),    url(\"Italic.ttf\") format(\"truetype\");}b {    font-family: \"Segoe UI\";    src: url(\"Semibold.eot?\") format(\"eot\"),    url(\"Semibold.woff\") format(\"woff\"),    url(\"Seimibold.ttf\") format(\"truetype\");    }-webkit-border-radius: 0 0 0 0;border-radius: 0 0 0 0;p {padding-top: 25px;    padding-right: 50px;padding-bottom: 25px;    padding-left: 50px;}body {    margin: 3;    padding: 0;}P { text-align: justify }img {    max-width: 100%;    height: auto;}"

}

// move posts to singleton, keep functions in parsing