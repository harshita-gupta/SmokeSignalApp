//
//  File.swift
//  SmokeSignalMobileApp
//
//  Created by Harshita Gupta on 2/14/15.
//  Copyright (c) 2015 The Smoke Signal. All rights reserved.
//

import Foundation

final class Article : NSObject {
    
    var articleJSONDictionary : NSDictionary?
    
    var headline : String?
    
    var previewText : String?
    
    var categoriesString : String?
    
    var postedDate : NSDate?
    var postedDateText : String?
    
    var updatedDate: NSDate?
    var updatedDateText : String?
    
    var writerString : String?
    
    var content : String?
    
    var thumbnailURL : NSURL?

    var mediumImageURL : NSURL?
    
    var articleURL : NSURL?
    
    var imageExists : Bool?
    
    var juiceBoxExists : Bool?
    var juiceBoxImageLinks : [NSURL]?
    
    override init () {
    }
    
    init(article: NSDictionary) {
        articleJSONDictionary = article
        if ((articleJSONDictionary!["thumbnail"] as! String!) != nil) {
            self.imageExists = true
        }
        else {
            self.imageExists = false
        }
        super.init()
        setHeadline()
        setPostedDateString()
        setUpdatedDateString()
        setWriter()
        setPreviewText()
        setCategoriesString()
        setImageURLs()
        setContent()
        setURL()
        
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.handleJuicebox()
        }

        
    }
    
    func setImageURLs() {
        
        if (imageExists == true) {

            let thumbnailsLib = articleJSONDictionary!["thumbnail_images"] as! NSDictionary!

            let mediumSizeImageDict = thumbnailsLib["medium"] as! NSDictionary!

            self.mediumImageURL = NSURL(string: (mediumSizeImageDict["url"] as! NSString) as String ) as NSURL!

            self.thumbnailURL = NSURL(string: (articleJSONDictionary!)["thumbnail"] as! String) as NSURL!

        }
        else {
            self.thumbnailURL = nil
            self.mediumImageURL = nil
        }
        
    }

    
    func setHeadline() {
        self.headline = ((articleJSONDictionary!)["title"] as! String).kv_decodeHTMLCharacterEntities()
    }
    
    func setPostedDateString() {
        let dateStringFromJSON : String = articleJSONDictionary!["date"] as! String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d H:m:s"
        self.postedDate = ((dateFormatter.dateFromString(dateStringFromJSON))) as NSDate!
        
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "MMMM d, yyyy"
        
        self.postedDateText = dateFormatter2.stringFromDate(self.postedDate!)
    }
    
    func setUpdatedDateString() {
        let dateStringFromJSON : String = articleJSONDictionary!["modified"] as! String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d H:m:s"
        self.updatedDate = ((dateFormatter.dateFromString(dateStringFromJSON))) as NSDate!
        
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "MMMM d, yyyy"
        
        self.updatedDateText = dateFormatter2.stringFromDate(self.updatedDate!)
    }
    
    func setWriter() {
        let writerNameString = parsing.extractWriter((articleJSONDictionary!["content"]) as! NSMutableString)
        if writerNameString == nil {
            self.writerString = ""
        }
        else {
            self.writerString = (writerNameString!).kv_decodeHTMLCharacterEntities()
        }
    }
    
    func setPreviewText() {
        self.previewText = (articleJSONDictionary!["previewContents"] as! String)
    }
    
    func setCategoriesString() {
        var categoryLabelString : String = ""
        if articleJSONDictionary!["categories"] != nil {
            let categoriesArray : NSArray = articleJSONDictionary!["categories"] as! NSArray
            if (categoriesArray.count != 0) {
                for var index = 0; index < categoriesArray.count; ++index {
                    let currTitle : String = (categoriesArray[index] as! NSDictionary)["title"] as! String
                    if index == 0 {
                        categoryLabelString += currTitle
                    }
                    else {
                        categoryLabelString += " | " + currTitle
                    }
                }
                self.categoriesString = categoryLabelString
            }
            else {
                self.categoriesString = ""
            }
        }
        else {
            self.categoriesString = ""
        }
    }
    
    
    func setContent() {
        if ((articleJSONDictionary!["content"] as! String!) != nil) {
            self.content = (articleJSONDictionary!["content"] as! String)
        }
        else {
            self.content = ""
        }
    }
    
    func setURL() {
        if ((articleJSONDictionary!["url"] as! String!) != nil){
            self.articleURL = NSURL(fileURLWithPath: articleJSONDictionary!["url"] as! String!)
        }
        else {
            self.articleURL = nil
        }
    }
    
    func handleJuicebox() {
        let rangeOfJB = NSString(string: self.content!).rangeOfString("<!--START JUICEBOX EMBED-->")
        
        if (rangeOfJB.location) == NSNotFound {
            self.juiceBoxExists = false
            return
        }
        
        else {
            self.juiceBoxExists = true
        }
        
        //TODO ACTUALLY USE METHOD
        let jbURL = parsing.extractJuiceboxLink(self.content!)
        
        self.juiceBoxImageLinks = parsing.extractJuiceboxGalleryImageURLs(jbURL)
    }
    
}