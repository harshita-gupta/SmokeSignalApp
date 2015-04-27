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
        
        println("webdatarequested")
        println(category_slug)
        println(page_number)
        
        var baseURLString : String = ("http://thesmokesignal.org/json_api/")
       
        if (category_slug=="") {
            baseURLString = baseURLString + "get_posts/" + "?page=" + (String(page_number))
        }
        else {
            baseURLString = baseURLString + "get_category_posts/"
            baseURLString = baseURLString + "?slug=" + category_slug + "&page=" + (String(page_number))
        }
        
        baseURLString = baseURLString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
        
        var url : NSURL = (NSURL(string:baseURLString)) as NSURL!
        
        var request = NSMutableURLRequest(URL: url)
        

        let backgroundQueue: dispatch_queue_t = dispatch_queue_create("com.a.identifier", DISPATCH_QUEUE_CONCURRENT)
        

        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments, error: error) as? NSMutableDictionary
            println("sent request for json")
            var updatedPostsArray = [NSMutableDictionary]()
            
            if (jsonResult != nil) {
                println("found a json result")
                let postsArray = (jsonResult!["posts"] as! NSArray).mutableCopy() as! [NSMutableDictionary]
                println("stored JSON in array")
                for post in postsArray {
                   
                    var updatedPost = post.mutableCopy() as! NSMutableDictionary
                    
//                    //IMAGE STUFF
//                    if ((post["thumbnail"] as! String!) != nil) {
//                        
//                        println("a thumbnail and image exists, we shall download them in the background")
//                        var thumbnailsLib = post["thumbnail_images"] as! NSDictionary!
//                        
//                        var fullsizeImageDic = thumbnailsLib["full"] as! NSDictionary!
//                        
//                        var fullImageURL = NSURL(string: (fullsizeImageDic["url"] as! NSString) as String ) as NSURL!
//                        
//                        var thumbnailURL = NSURL(string: post["thumbnail"] as! String) as NSURL!
//                        
//                        // can be called as often as needed
//                        dispatch_async(backgroundQueue) {
//                            var imageDataThumbnail = NSData(contentsOfURL: thumbnailURL)
//                            var imageDataFull = NSData(contentsOfURL: fullImageURL)
//                            
//                            post["savedThumbImage"] = UIImage(data: imageDataThumbnail!)
//                            post["savedFullImage"] = UIImage(data: imageDataFull!)
//                        }
//                        
//                        
//                    }
//                    else {//if there isnt an image, it hides the imageview
//                        post["savedThumbImage"] = nil
//                        post["savedFullImage"] = nil
//                    }
//                    
                    var previewContents  = parsing.createPreview(post["content"] as! NSMutableString)  //created to store the string that will contain the preview text
                    previewContents = ((previewContents as String).kv_decodeHTMLCharacterEntities()).mutableCopy() as! NSMutableString
                    previewContents = NSMutableString(string: previewContents.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
                    updatedPost["previewContents"] = NSMutableString(string: previewContents)
                    updatedPostsArray.append(updatedPost)//append(updatedPost as NSMutableDictionary)
                }

                    
                if (page_number == 1) {
                    Singleton.sharedInstance.posts = updatedPostsArray as [NSMutableDictionary]
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
        
        var loc : NSRange? = text.rangeOfString("By:")
        
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
            var firstCharAfterName: NSRange? = writer.rangeOfString("<")
            
            if firstCharAfterName!.location == NSNotFound {
                // we do nothing, bc there's nothing after the name so like LOL
            }
            else {
                var rangeAfter : NSRange = NSMakeRange(firstCharAfterName!.location, (  (writer.length) -  (firstCharAfterName!.location) ))
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
        
        //removes any closing tags left after the writer name
        clearedText = clearTillNextTag(clearedText, tagToClear: "<p>")
        
        clearedText = clearAllTriangeTags(clearedText)
        
        if (clearedText.hasPrefix("Local")) {
            clearedText.replaceCharactersInRange(NSMakeRange(0, 5), withString: "")
            
        }

        var finalString: NSMutableString = (clearedText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())).mutableCopy() as! NSMutableString
         
        return finalString
    
    }

     static func clearTillEndWriterName (textToBeCleared : NSMutableString) -> NSMutableString {
        
        if extractWriter(NSMutableString(string: textToBeCleared)) != nil { //there is a writer name
            var writerName = extractWriter(NSMutableString(string: textToBeCleared))!
            var locWriterName : NSRange? = textToBeCleared.rangeOfString( writerName as String ) as NSRange
            var endWriterNamePos = locWriterName!.location + locWriterName!.length - 1//this is the variable we want to clear till
            var clearTill_Range : NSRange = NSMakeRange(0, endWriterNamePos + 1 )
            var finalString = clearCharactersFromString(textToBeCleared, rangeToBeCleared: clearTill_Range)
            
            return finalString
        }
            
        else {
            return textToBeCleared
        }

    }
    
     static func clearTillNextTag (textToBeCleared : NSMutableString, tagToClear : NSString) -> NSMutableString {
        var locTagRange : NSRange? = textToBeCleared.rangeOfString(tagToClear as String)
        if locTagRange != nil {
            var posTag = locTagRange!.location
            
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
                var clearedString: NSMutableString = textToBeCleared.mutableCopy() as! NSMutableString
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
        var rangeOfTag : NSRange? = (text.rangeOfString("<"))
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
        var rangeToReturn = NSMakeRange(locOfStartTag, ((locOfCloseTag - locOfStartTag) + 1))
        return rangeToReturn
    }
    
     static func clearAllTriangeTags (incoming: NSMutableString) -> NSMutableString {
        var freshText = incoming.mutableCopy() as! NSMutableString
        var triangeTagsLeft : NSRange? = findRangeOfFirstTriangleTag(freshText)
        while (triangeTagsLeft != nil)  {
            if ((triangeTagsLeft?.location) > 300) {
             break;
            }
            freshText.replaceCharactersInRange(triangeTagsLeft!, withString: "")
            triangeTagsLeft = findRangeOfFirstTriangleTag(freshText)
        }
        return freshText
    }
    
     static func clearCharactersFromString(text: NSMutableString, rangeToBeCleared: NSRange) -> NSMutableString {
        
        var finalString: NSMutableString = text.mutableCopy() as! NSMutableString
        finalString.replaceCharactersInRange(rangeToBeCleared , withString: "")

        return finalString
    }
   
    
    
    // this will extract the juicebox embed XML Link
     static func extractJuiceboxLink (text: String) -> NSURL {
    
        //TODO
        
        var jbLink = (NSURL(string: text)) as NSURL!!
        
        return (jbLink)
    }
    
    
    // this will go through the XML link and return an array with all the images in it
     static func extractJuiceboxGallery (url: NSURL) -> NSMutableArray {
        
        var imageGallery = NSMutableArray()
        //TODO
        return imageGallery
    }
    
    //replace HTML tags with text
     static func convertToPlain (text: NSMutableString) -> NSMutableString {
        var finalText = text
        
       // TODO
        
        return finalText
    }
    
    

}
