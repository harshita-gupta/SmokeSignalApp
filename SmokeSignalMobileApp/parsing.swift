//
//  parsing.swift
//  SmokeSignalMobileApp
//
//  Created by Harshita Gupta on 1/25/15.
//  Copyright (c) 2015 The Smoke Signal. All rights reserved.
//

import Foundation
import UIKit

 struct parsing {
    
    //var posts = NSMutableArray()
    
    //used to pull data from the website
    // doesnt return any value
    // category_slug is if it is a category-specific load, left as "" if it is not
    //page number must always be specified
    static func getWebDataFromCategory (category_slug: String, page_number: Int, completion: (()->())? = nil) ->Void{
        
        print("webdatarequested", appendNewline: true)
        print(category_slug, appendNewline: true)
        print(page_number, appendNewline: true)
        
        var baseURLString : String = ("http://thesmokesignal.org/json_api/")
       
        if (category_slug=="") {
            baseURLString = baseURLString + "get_posts/" + "?page=" + (String(page_number))
        }
        else {
            baseURLString = baseURLString + "get_category_posts/"
            baseURLString = baseURLString + "?slug=" + category_slug + "&page=" + (String(page_number))
        }
        
        baseURLString = baseURLString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
        
        let url : NSURL = (NSURL(string:baseURLString)) as NSURL!
        
        let request = NSURLRequest(URL: url)
        

        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            var jsonResult : NSMutableDictionary?
            
            do {
                try jsonResult = NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments) as? NSMutableDictionary
            }
            catch {
                
            }
            
            print("sent request for json", appendNewline: true)
            var updatedPostsArray = [NSMutableDictionary]()
            
            if (jsonResult != nil) {
                print("found a json result", appendNewline: true)
                let postsArray = (jsonResult!["posts"] as! NSArray).mutableCopy() as! [NSMutableDictionary]
                print("stored JSON in array", appendNewline: true)
                for post in postsArray {
                   
                    let updatedPost = post.mutableCopy() as! NSMutableDictionary
                    
                    var previewContents  = parsing.createPreview(post["content"] as! NSMutableString)  //created to store the string that will contain the preview text
                    previewContents = ((previewContents as String).kv_decodeHTMLCharacterEntities()).mutableCopy() as! NSMutableString
                    previewContents = NSMutableString(string: previewContents.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
                    updatedPost["previewContents"] = NSMutableString(string: previewContents)
                    updatedPostsArray.append(updatedPost)//append(updatedPost as NSMutableDictionary)
                }

                    
                if (page_number == 1) {
                    Singleton.sharedInstance.posts = updatedPostsArray as [NSMutableDictionary]
                    Singleton.sharedInstance.articleCache = [NSInteger: Article]()
                }
                else {
                    Singleton.sharedInstance.posts = Singleton.sharedInstance.posts + (updatedPostsArray)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let completion = completion {
                        completion()
                    }
                    
                    Singleton.sharedInstance.masterViewControllerReference.tableView.reloadData()
                    
                })
                
                
            } else {
                // couldn't load JSON, look at error
            }
            
            
        })
    }
    
    static func articleForPostAtIndex(row: NSInteger) -> Article {
        // Return article if already computed
        if let article = Singleton.sharedInstance.articleCache[row] {
            return article
        }
        // Otherwise, create a new article and cache it.
        let currentPostDictionary : NSDictionary = Singleton.sharedInstance.posts[row] as NSDictionary
        let currentArticle : Article = Article(article: currentPostDictionary)
        
        Singleton.sharedInstance.articleCache[row] = currentArticle
        
        return currentArticle
    }

    
    
    //resizing image function
     static func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    //returns a string of the writer name    
     static func extractWriter (text: NSMutableString) -> NSMutableString? {
        var writer : NSMutableString = text.mutableCopy() as! NSMutableString
        
        let loc : NSRange? = text.rangeOfString("By:")
        
        // if the writer name isn't present, returns nil
        if loc!.location == NSNotFound || loc!.location == NSNotFound{
            return nil
        }
        
        else { // writer name is present, continues with extraction
            
            var rangeBefore : NSRange
            // this pair of if-else identifies the range of anything before the writer name, including the "By:"
            if loc?.location == 0 {
                    //removes the "By: " -> this is 4 characters, b y : and " "
                    rangeBefore = NSMakeRange(0, 4)
            }
            else {
                rangeBefore = NSMakeRange(0, ((loc!.location)-1)+4) //first everything up to the By, then the 4 after it
            }
            // above lines create a range of all characters before the actual name
            
            writer = clearCharactersFromString(writer, rangeToBeCleared: rangeBefore) //writer now name at the start of the string, and the characters after it
//            
//            writer.replaceOccurrencesOfString("Staff Writer", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, writer.length))
//            writer.replaceOccurrencesOfString("News Editor", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, writer.length))
//            writer.replaceOccurrencesOfString("Opinion Editor", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, writer.length))
//            writer.replaceOccurrencesOfString("Feature Editor", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, writer.length))
//            writer.replaceOccurrencesOfString("Centerspread Editor", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, writer.length))
//            writer.replaceOccurrencesOfString("Arts and Entertainment Editor", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, writer.length))
//            writer.replaceOccurrencesOfString("Arts & Entertainment Editor", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, writer.length))
//            writer.replaceOccurrencesOfString("A&E Editor", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, writer.length))
//            writer.replaceOccurrencesOfString("A & E Editor", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, writer.length))
//            writer.replaceOccurrencesOfString("Sports editor", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, writer.length))
//            writer.replaceOccurrencesOfString("graphics editor", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, writer.length))
//            writer.replaceOccurrencesOfString("photo editor", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, writer.length))
//            writer.replaceOccurrencesOfString("photos editor", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, writer.length))
//            writer.replaceOccurrencesOfString("web editor", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, writer.length))
//            writer.replaceOccurrencesOfString("editor in chief", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, writer.length))
//            writer.replaceOccurrencesOfString("editor-in-chief", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, writer.length))
//
            //we proceed to remove everything after the name.
            //after name, there is always a <
            //we create an optional just in case, but highly unlikely that article will only be writer name LOL. unless it's an image. so good robustness gj harshita
            let firstCharAfterName: NSRange? = writer.rangeOfString("<")
            
            if firstCharAfterName!.location == NSNotFound {
                // we do nothing, bc there's nothing after the name so like LOL
            }
            else {
                let rangeAfter : NSRange = NSMakeRange(firstCharAfterName!.location, (  (writer.length) -  (firstCharAfterName!.location) ))
                writer = clearCharactersFromString(writer, rangeToBeCleared: rangeAfter)
            }
            
            return writer
        }
    }

    // this will clear the links and stuff at the start of the article, and any stuff at the end of it. will also remove writer name.
     static func createPreview (text: NSMutableString) -> NSMutableString {
        
        var clearedText : NSMutableString = text.mutableCopy() as! NSMutableString
        
        // removes all \ slashes from the string
        clearedText.replaceOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: (NSMakeRange(0, clearedText.length)))

        //removes all newlines from string bc preview
        clearedText.replaceOccurrencesOfString("\n", withString: " ", options: NSStringCompareOptions.CaseInsensitiveSearch, range: (NSMakeRange(0, clearedText.length)))
        
        //removes all header images and stuff before the writer name
        clearedText = clearTillNextTag( clearedText , tagToClear: "<p>")
        
        //removes the writer name
        clearedText = clearTillEndWriterName(clearedText)
        
        //removes juicebox script if present
        clearedText = deleteAllScripts( clearedText )
        
        //removes any closing tags left after the writer name
        clearedText = clearTillNextTag(clearedText, tagToClear: "<p>")
        
        //removes all triangle tags
        clearedText = clearAllTriangeTags(clearedText)
        
        if (clearedText.hasPrefix("Local")) {
            clearedText.replaceCharactersInRange(NSMakeRange(0, 5), withString: "")
            
        }

        if (clearedText.hasPrefix(": ")) {
            clearedText.replaceCharactersInRange(NSMakeRange(0, 2), withString: "")
            
        }

        let finalString: NSMutableString = (clearedText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())).mutableCopy() as! NSMutableString
         
        return finalString
    
    }

     static func clearTillEndWriterName (textToBeCleared : NSMutableString) -> NSMutableString {
        
        if extractWriter(NSMutableString(string: textToBeCleared)) != nil { //there is a writer name
            let writerName = extractWriter(NSMutableString(string: textToBeCleared))!
            let locWriterName : NSRange? = textToBeCleared.rangeOfString( (writerName as String).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) ) as NSRange
            let endWriterNamePos = locWriterName!.location + locWriterName!.length - 1//this is the variable we want to clear till
            let clearTill_Range : NSRange = NSMakeRange(0, endWriterNamePos + 1 )
            let finalString = clearCharactersFromString(textToBeCleared, rangeToBeCleared: clearTill_Range)
            
            return finalString
        }
            
        else {
            return textToBeCleared
        }

    }
    
     static func clearTillNextTag (textToBeCleared : NSMutableString, tagToClear : NSString) -> NSMutableString {
        let locTagRange : NSRange? = textToBeCleared.rangeOfString(tagToClear as String)
        if locTagRange != nil {
            let posTag = locTagRange!.location
            
            if posTag == NSNotFound {// checks if there isnt anything before the <p>, if there is, then the else executes-- removed everything before the p
                return textToBeCleared
            }
            else {
                var unneededRange : NSRange
                if posTag == 0 { //if its the first character in the range, why clear? LOL
                    return textToBeCleared
                }
                else {
                    unneededRange = NSMakeRange(0, (posTag))

                }
                let clearedString: NSMutableString = textToBeCleared.mutableCopy() as! NSMutableString
                clearedString.replaceCharactersInRange(unneededRange, withString: "")
                return clearedString
            }
        }
            
        else {
            return textToBeCleared
        }

    }
    
     static func findRangeOfFirstTriangleTag (incoming: NSMutableString) -> NSRange? {
        var text = incoming as NSString
        let rangeOfTag : NSRange? = (text.rangeOfString("<"))
        if (rangeOfTag?.location == NSNotFound) {
            return nil
        }
        var locOfStartTag = rangeOfTag!.location
        var locOfCloseTag = (text.rangeOfString(">") as NSRange).location
        while (locOfCloseTag < locOfStartTag) {
            text = clearCharactersFromString(text.mutableCopy() as! NSMutableString, rangeToBeCleared: NSMakeRange(locOfCloseTag, 1))
            locOfStartTag = (text.rangeOfString("<") as NSRange).location
            locOfCloseTag = (text.rangeOfString(">") as NSRange).location
        }
        let rangeToReturn = NSMakeRange(locOfStartTag, ((locOfCloseTag - locOfStartTag) + 1))
        return rangeToReturn
    }
    
     static func clearAllTriangeTags (incoming: NSMutableString) -> NSMutableString {
        
        print("value before clearing all triangle tags: ", appendNewline: false)
        print(incoming, appendNewline: true)
        let freshText = incoming.mutableCopy() as! NSMutableString
        var triangeTagsLeft : NSRange? = findRangeOfFirstTriangleTag(freshText)
        while (triangeTagsLeft != nil)  {
            if ((triangeTagsLeft?.location) > 700) {
             break;
            }
            freshText.replaceCharactersInRange(triangeTagsLeft!, withString: "")
            triangeTagsLeft = findRangeOfFirstTriangleTag(freshText)
        }
        
        print("value after clearing all triangle tags: ", appendNewline: false)
        print(freshText, appendNewline: true)

        return freshText
        
        
    }
    
     static func clearCharactersFromString(text: NSMutableString, rangeToBeCleared: NSRange) -> NSMutableString {
        
        let finalString: NSMutableString = text.mutableCopy() as! NSMutableString
        finalString.replaceCharactersInRange(rangeToBeCleared , withString: "")

        return finalString
    }
   
    
    static func deleteAllScripts(incoming: NSMutableString) -> NSMutableString {
        
        
        print("value before deleting all scripts tags: ", appendNewline: false)
        print(incoming, appendNewline: true)

        
        let text = incoming as NSString
        let rangeOfTag : NSRange? = (text.rangeOfString("<script"))
        
        
        print("range of <script tag :", appendNewline: false)
        print(rangeOfTag, appendNewline: true)

        
        if (rangeOfTag?.location == NSNotFound) {
            
            print("no <script tags found, method exited ", appendNewline: true)

            return incoming
        }
        let locOfStartTag = rangeOfTag!.location
        let rangeOfCloseTag = text.rangeOfString("</script>") as NSRange
        
        
        print("range of closing </script> tag :", appendNewline: false)
        print(rangeOfCloseTag, appendNewline: true)

        
        let locOfCloseTag = rangeOfCloseTag.location
        
        let rangeOfScriptContent = NSMakeRange(locOfStartTag, (locOfCloseTag + rangeOfCloseTag.length - 1 ) - locOfStartTag + 1)

        print("range of  script content to be cleared :", appendNewline: false)
        print(rangeOfScriptContent, appendNewline: true)
        
        let finalText = clearCharactersFromString(text.mutableCopy() as! NSMutableString, rangeToBeCleared: rangeOfScriptContent)
        
        print("value before deleting all scripts tags: ", appendNewline: false)
        print(finalText, appendNewline: true)
        
        return finalText
    }
    
//    
//    // this will extract the juicebox embed XML Link
//     static func extractJuiceboxLink (var text: NSString) -> NSURL {
//        
//        let startConfigRange = text.rangeOfString("configUrl")
//        
//        let beforeStartOfURL = (text.rangeOfString("\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(startConfigRange.location, 20))).location
//        
//        text = text.substringFromIndex(beforeStartOfURL + 1)
//        
//        let afterEndOfURL = (text.rangeOfString("\"")).location
//
//        let stringToClear = text.substringFromIndex(afterEndOfURL)
//        
//        text = text.stringByReplacingOccurrencesOfString(stringToClear, withString: "")
//        
//        let jbLink = (NSURL(string: text as String)) as NSURL!!
//        
//        print("juicebox link: ")
//        print(jbLink)
//        
//        return (jbLink)
//    }
//    
//    
//    // this will go through the XML link and return an array with all the images in it
//     static func extractJuiceboxGalleryImageURLs (url: NSURL) -> [NSURL] {
//
//        print("started extracting juicebox gallery links")
//        
//        var imageURLGallery = [NSURL]()
//        
//        var error : NSError?
//        
//        let urlData = NSData(contentsOfURL: url)
//        
//        if let xmlDoc = AEXMLDocument(xmlData: urlData!, error: &error) {
//            
//            if let allImages = xmlDoc.root["image"].all {
//                for image in allImages {
//                    
//                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
//                        
//                        if let imageLink = image.attributes["imageURL"] {
//                            print("image link: ", appendNewline: false)
//                            print (imageLink)
//                            imageURLGallery.append(NSURL(string: imageLink as! String)!)
//                        }
//                        
//                    }
//                    
//                }
//            }
//        }
//        
//        return imageURLGallery
//    }
    
    

}
