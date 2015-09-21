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
    
    var fullImageURL : NSURL?
    
    var articleURL : NSURL?
    
    var imageExists : Bool?
    
    var juiceboxGalleryLink : NSURL?
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
        handleJuicebox()
        
    }
    
    func setImageURLs() {
        
        if (imageExists == true) {

            let thumbnailsLib = articleJSONDictionary!["thumbnail_images"] as! NSDictionary!

            let mediumSizeImageDict = thumbnailsLib["medium"] as! NSDictionary!
            let fullSizeImageDict = thumbnailsLib["full"] as! NSDictionary!

            self.fullImageURL = NSURL(string: (fullSizeImageDict["url"] as! NSString) as String ) as NSURL!

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
            var cont1 = (articleJSONDictionary!["content"]) as! NSMutableString
            cont1 = parsing.clearTillEndWriterName(NSMutableString(string: cont1))
            self.content = parsing.clearTillNextTag(cont1, tagToClear: "<p>") as String
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
        
        self.juiceBoxExists = true
        self.juiceBoxImageLinks = [NSURL]()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.extractJuiceboxGalleryURL()
            self.extractJuiceboxGalleryImageURLs()
            //            let jbURL = parsing.extractJuiceboxLink(self.content!)
//            self.juiceBoxImageLinks = parsing.extractJuiceboxGalleryImageURLs(jbURL)

        }
        
    }
    
    private func extractJuiceboxGalleryURL() {
    
        var text = self.content! as NSString
        
        let startConfigRange = text.rangeOfString("configUrl")
        
        let beforeStartOfURL = (text.rangeOfString("\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(startConfigRange.location, 20))).location
        
        
        text = text.substringFromIndex(beforeStartOfURL + 1)
        
        let afterEndOfURL = (text.rangeOfString("\"")).location
        
        let stringToClear = text.substringFromIndex(afterEndOfURL)
        
        text = text.stringByReplacingOccurrencesOfString(stringToClear, withString: "")
        
        let jbLink = (NSURL(string: text as String)) as NSURL!!
        
        print("juicebox link: ")
        print(jbLink)
        
        self.juiceboxGalleryLink = jbLink
        
    }
    
    private func extractJuiceboxGalleryImageURLs () {
        print("started extracting juicebox gallery links")
        
        let url = self.juiceboxGalleryLink
        var error : NSError?
        
        let urlData = NSData(contentsOfURL: url!)
        
        if let xmlDoc = AEXMLDocument(xmlData: urlData!, error: &error) {
            
            if let allImages = xmlDoc.root["image"].all {
                for image in allImages {
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        
                        if let imageLink = image.attributes["imageURL"] {
                            print("image link: ", terminator: "")
                            print (imageLink)
                            self.juiceBoxImageLinks!.append(NSURL(string: imageLink as! String)!)
                        }
                    }
                }
            }
        }
    }
    
    
    
}