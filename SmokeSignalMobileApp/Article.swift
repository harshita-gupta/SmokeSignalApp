//
//  File.swift
//  SmokeSignalMobileApp
//
//  Created by Harshita Gupta on 2/14/15.
//  Copyright (c) 2015 The Smoke Signal. All rights reserved.
//

import Foundation
import UIKit

class Article : NSObject {
    
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
  //  var thumbnailImage : UIImage?
    
    //var fullImage : UIImage?
    var fullImageURL : NSURL?
    
    var articleURL : NSURL?
    
    var imageExists : Bool?
    
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
        

    }
    
    func setImageURLs() {
//        self.thumbnailImage = (self.articleJSONDictionary!["savedThumbImage"] as? UIImage)
//        self.fullImage = self.articleJSONDictionary!["savedFullImage"] as? UIImage
        
        if (imageExists == true) {

            var thumbnailsLib = articleJSONDictionary!["thumbnail_images"] as! NSDictionary!

            var fullsizeImageDic = thumbnailsLib["full"] as! NSDictionary!

            self.fullImageURL = NSURL(string: (fullsizeImageDic["url"] as! NSString) as String ) as NSURL!

            self.thumbnailURL = NSURL(string: (articleJSONDictionary!)["thumbnail"] as! String) as NSURL!

//            var imageDataThumbnail = NSData(contentsOfURL: thumbnailURL)
//            var imageDataFull = NSData(contentsOfURL: fullImageURL)
//
//            self.thumbnailImage = UIImage(data: imageDataThumbnail!)
//            self.fullImage = UIImage(data: imageDataFull!)

        }
        else {//if there isnt an image, it hides the imageview
            self.thumbnailURL = nil
            self.fullImageURL = nil
        }
        
    }

    
    func setHeadline() {
        self.headline = ((articleJSONDictionary!)["title"] as! String).kv_decodeHTMLCharacterEntities()
    }
    
    func setPostedDateString() {
        var dateStringFromJSON : String = articleJSONDictionary!["date"] as! String
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d H:m:s"
        self.postedDate = ((dateFormatter.dateFromString(dateStringFromJSON))) as NSDate!
        
        var dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "MMMM d, yyyy"
        
        self.postedDateText = dateFormatter2.stringFromDate(self.postedDate!)
    }
    
    func setUpdatedDateString() {
        var dateStringFromJSON : String = articleJSONDictionary!["modified"] as! String
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d H:m:s"
        self.updatedDate = ((dateFormatter.dateFromString(dateStringFromJSON))) as NSDate!
        
        var dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "MMMM d, yyyy"
        
        self.updatedDateText = dateFormatter2.stringFromDate(self.updatedDate!)
    }
    
    func setWriter() {
        var writerNameString = parsing.extractWriter((articleJSONDictionary!["content"]) as! NSMutableString)
        if writerNameString == nil {
            self.writerString = ""
        }
        else {
            self.writerString = (writerNameString!).kv_decodeHTMLCharacterEntities()
        }
    }
    
    func setPreviewText() {
        self.previewText = (articleJSONDictionary!["previewContents"] as! String)
//        var previewContents = parsing.createPreview(unclearedPreviewContents) as NSMutableString //created to store the string that will contain the preview text
//        previewContents = ((previewContents as String).kv_decodeHTMLCharacterEntities()).mutableCopy() as! NSMutableString
     //   self.previewText = previewContents.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    func setCategoriesString() {
        var categoryLabelString : String = ""
        if articleJSONDictionary!["categories"] != nil {
            var categoriesArray : NSArray = articleJSONDictionary!["categories"] as! NSArray
            if (categoriesArray.count != 0) {
                for var index = 0; index < categoriesArray.count; ++index {
                    var currTitle : String = (categoriesArray[index] as! NSDictionary)["title"] as! String
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
    
}