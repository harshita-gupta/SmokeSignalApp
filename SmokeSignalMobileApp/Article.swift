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
    
    var postedDate : Date?
    var postedDateText : String?
    
    var updatedDate: Date?
    var updatedDateText : String?
    
    var writerString : String?
    
    var content : String?
    
    var thumbnailURL : URL?

    var mediumImageURL : URL?
    
    var fullImageURL : URL?
    
    var articleURL : URL?
    
    var imageExists : Bool?
    
    var juiceboxGalleryLink : URL?
    var juiceBoxExists : Bool?
    var juiceBoxImageLinks : [URL]?
    
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

            let mediumSizeImageDict = thumbnailsLib?["medium"] as! NSDictionary!
            let fullSizeImageDict = thumbnailsLib?["full"] as! NSDictionary!

            self.fullImageURL = URL(string: (fullSizeImageDict?["url"] as! NSString) as String ) as URL!

            self.mediumImageURL = URL(string: (mediumSizeImageDict?["url"] as! NSString) as String ) as URL!

            
            self.thumbnailURL = URL(string: (articleJSONDictionary!)["thumbnail"] as! String) as URL!

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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d H:m:s"
        self.postedDate = ((dateFormatter.date(from: dateStringFromJSON))) as Date!
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMMM d, yyyy"
        
        self.postedDateText = dateFormatter2.string(from: self.postedDate!)
    }
    
    func setUpdatedDateString() {
        let dateStringFromJSON : String = articleJSONDictionary!["modified"] as! String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d H:m:s"
        self.updatedDate = ((dateFormatter.date(from: dateStringFromJSON))) as Date!
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMMM d, yyyy"
        
        self.updatedDateText = dateFormatter2.string(from: self.updatedDate!)
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
                for index in (0 ..< categoriesArray.count) {
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
            self.articleURL = URL(fileURLWithPath: articleJSONDictionary!["url"] as! String!)
        }
        else {
            self.articleURL = nil
        }
    }
    
    func handleJuicebox() {
        let rangeOfJB = NSString(string: self.content!).range(of: "<!--START JUICEBOX EMBED-->")
        
        if (rangeOfJB.location) == NSNotFound {
            self.juiceBoxExists = false
            return
        }
        
        self.juiceBoxExists = true
        self.juiceBoxImageLinks = [URL]()
        
        let priority = DispatchQueue.GlobalAttributes.qosDefault
        DispatchQueue.global(attributes: priority).async {
            self.extractJuiceboxGalleryURL()
            self.extractJuiceboxGalleryImageURLs()
            //            let jbURL = parsing.extractJuiceboxLink(self.content!)
//            self.juiceBoxImageLinks = parsing.extractJuiceboxGalleryImageURLs(jbURL)

        }
        
    }
    
    private func extractJuiceboxGalleryURL() {
    
        var text = self.content! as NSString
        
        let startConfigRange = text.range(of: "configUrl")
        
        let beforeStartOfURL = (text.range(of: "\"", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(startConfigRange.location, 20))).location
        
        
        text = text.substring(from: beforeStartOfURL + 1)
        
        let afterEndOfURL = (text.range(of: "\"")).location
        
        let stringToClear = text.substring(from: afterEndOfURL)
        
        text = text.replacingOccurrences(of: stringToClear, with: "")
        
        let jbLink = (URL(string: text as String)) as URL?!
        
        print("juicebox link: ")
        print(jbLink)
        
        self.juiceboxGalleryLink = jbLink!
        
    }
    
    private func extractJuiceboxGalleryImageURLs () {
        print("started extracting juicebox gallery links")
        
        let url = self.juiceboxGalleryLink
        var error : NSError?
        
        let urlData = try? Data(contentsOf: url!)
        
        if let xmlDoc = AEXMLDocument(xmlData: urlData!, error: &error) {
            
            if let allImages = xmlDoc.root["image"].all {
                for image in allImages {
                    
                    let priority = DispatchQueue.GlobalAttributes.qosDefault
                    DispatchQueue.global(attributes: priority).async {
                        
                        if let imageLink = image.attributes["imageURL"] {
                            print("image link: ", terminator: "")
                            print (imageLink)
                            self.juiceBoxImageLinks!.append(URL(string: imageLink as! String)!)
                        }
                    }
                }
            }
        }
    }
    
    
    
}
