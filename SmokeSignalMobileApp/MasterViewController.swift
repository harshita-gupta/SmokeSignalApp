//
//  MasterViewController.swift
//  SmokeSignalMobileApp
//
//  Created by Harshita Gupta on 11/8/14.
//  Copyright (c) 2014 The Smoke Signal. All rights reserved.
//

import UIKit
import Foundation
//import Crashlytics

class MasterViewController: UITableViewController{
    
    @IBOutlet var activityBar: UIProgressView!
    
    @IBOutlet var postTable: UITableView!
    
    @IBOutlet var mainNavBar: UINavigationItem!
    
    @IBOutlet var refresher: UIRefreshControl!
    
    var currentCategory : Category = Category()
    
    
    var currentPage = 0
    var currentlyLoading = false
    
    override func viewDidLoad() {
        print("master view loaded", appendNewline: true)

        ((self.parentViewController)?.parentViewController as! MainViewController).panGestureRecognizer()

        super.viewDidLoad()
        Singleton.sharedInstance.masterViewControllerReference = self;
        // Do any additional setup after loading the view, typically from a nib.
        
        
        setBarButton()

        self.automaticallyAdjustsScrollViewInsets = false
        currentCategory = Category(slug_name: "")
        addNavBarBanner()
        activityBar.progressTintColor = currentCategory.highlightColor
        refresher.backgroundColor = currentCategory.highlightColor
        currentPage = 1;
    
        //getting the json data from thesmokesignal.org
        parsing.getWebDataFromCategory("", page_number: currentPage)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let gesture = ((self.parentViewController)?.parentViewController as! MainViewController).panGestureRecognizer()
        gesture.enabled = true
    }
    
    func setBarButton() {
        print("starts setting leftBarButtonItem", appendNewline: true)
        self.mainNavBar!.leftBarButtonItem = DrawerBarButtonItem(target: self, action: "toggleLeft")
        print("leftBarButtonItem set to: ", appendNewline: false)
        print(self.mainNavBar!.leftBarButtonItem, appendNewline: true)
        print("finished setting leftBarButtonItem", appendNewline: true)
        print("", appendNewline: true)

    }
    
    func toggleLeft() {
        print("DrawerBarButtonItem tapped.", appendNewline: true)
        ((Singleton.sharedInstance.mainViewControllerReference) as SWRevealViewController).revealToggleAnimated(true)
    }
    
    func refreshWithNewCatSort(slug_name: String) {
        currentCategory = Category(slug_name: slug_name)
        addNavBarBanner()
        activityBar.progressTintColor = currentCategory.highlightColor
        refresher.backgroundColor = currentCategory.highlightColor
        currentPage = 1
        parsing.getWebDataFromCategory(currentCategory.slug!, page_number: currentPage, completion: nil)
    }
 
    func addNavBarBanner() {
        print("started adding top Navigation Bar", appendNewline: true)
        
        var imPresent : Bool
        
        if self.currentCategory.slug! == "" {
            imPresent = true
        }
        else {
            imPresent = false
        }
        
        let titleView = NavBarTitleView(frame: CGRectZero, title: currentCategory.catName!,imagePresent: imPresent)

        let titleSize = titleView.systemLayoutSizeFittingSize(CGSizeZero)
        
        titleView.frame = CGRectMake(0, 0, titleSize.width, titleSize.height)
        
        mainNavBar.titleView = titleView
        
    }
    
    
    //handles loading of extra table cells
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentOffset : CGFloat = scrollView.contentOffset.y
        let maximumOffset : CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        
        //checks if user has scrolled to bottom
        if (  (maximumOffset - currentOffset <= 10.0)  &&  (currentlyLoading == false)   ) { //the boolean currentlyLoading was created so that we can make sure the getWebData method isn't called over and over again while the user is at the bottom. It is called once, then stops.
            currentlyLoading = true
            currentPage = currentPage + 1
            parsing.getWebDataFromCategory(currentCategory.slug!, page_number: currentPage, completion: { () -> () in self.currentlyLoading = false})// implemented a completion handler that shows that the loading has completed. Then the getWebData method can be called again.
        }
        
        
    }
    
    //number of sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    //number of rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.sharedInstance.posts.count
    }

   // cell heights
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 220
        }
        
        else {
            return 110
        }
    }
    
    //populates table with cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell : UITableViewCell
        
        if (indexPath.row == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("mostRecentPreview", forIndexPath: indexPath) as UITableViewCell
            (cell.viewWithTag(1) as! UILabel!).sizeToFit()
        }
        
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("article", forIndexPath: indexPath) as UITableViewCell
        }
        
        fillCells(cell, indexPath: indexPath)
        cell.setNeedsDisplay()
        return cell
    }
    
    // configures stuff for cells
    func fillCells(cell: UITableViewCell, indexPath: NSIndexPath) {
        let currentPostDictionary : NSDictionary = Singleton.sharedInstance.posts[indexPath.row] as NSDictionary
        
        let currentArticle : Article = Article(article: currentPostDictionary)
        
        let categoryLabel = cell.viewWithTag(8) as! UILabel
        let headline = cell.viewWithTag(1) as! UILabel
        let dateLabel = cell.viewWithTag(4) as! UILabel
        let writerLabel = cell.viewWithTag(5) as! UILabel
        let textPreview = cell.viewWithTag(2) as! UILabel
        let imageView = cell.viewWithTag(3) as! UIImageView

        
        if (currentArticle.categoriesString != nil) {
            categoryLabel.text = currentArticle.categoriesString!
        }
        
        if (currentArticle.headline != nil) {
            headline.text = currentArticle.headline!
        }
        
        if (currentArticle.postedDateText != nil) {
            dateLabel.text = currentArticle.postedDateText!
        }
        
        if (currentArticle.writerString != nil) {
            writerLabel.text = currentArticle.writerString!
        }
        
        if (currentArticle.previewText != nil) {
            textPreview.text = currentArticle.previewText!
        }
        
        if (currentArticle.imageExists!) {
            imageView.sd_setImageWithURL(currentArticle.fullImageURL!)
            //imageView.image = currentArticle.fullImage!
        }
        else {
            
            print("", appendNewline: false)
            print("", appendNewline: false)
            print("", appendNewline: false)
            
            
            //var leadingSpaceToImg : CGFloat = 3.0
            let imWidth = imageView.frame.size.width
            print("image width before change: ", appendNewline: false)
            print(imWidth, appendNewline: true)
            imageView.hidden = true
            
            headline.translatesAutoresizingMaskIntoConstraints = true
            writerLabel.translatesAutoresizingMaskIntoConstraints = true
            textPreview.translatesAutoresizingMaskIntoConstraints = true
            categoryLabel.translatesAutoresizingMaskIntoConstraints = true

            
            print("headline width before change: ", appendNewline: false)
            print(headline.frame.size.width, appendNewline: true)
            var headFrame = headline.frame
            headFrame.size.width = headline.frame.size.width + imWidth //+ leadingSpaceToImg
            headline.frame = headFrame
            print("headline width after change: ", appendNewline: false)
            print(headline.frame.size.width, appendNewline: true)

            
            print("writer width before change: ", appendNewline: false)
            print(writerLabel.frame.size.width, appendNewline: true)
            var writerFrame = writerLabel.frame
            writerFrame.size.width = writerLabel.frame.size.width + imWidth //+ leadingSpaceToImg
            writerLabel.frame = writerFrame
            print("headline width after change: ", appendNewline: false)
            print(writerLabel.frame.size.width, appendNewline: true)

            print("textframe width before change: ", appendNewline: false)
            print(textPreview.frame.size.width, appendNewline: true)
            var textFrame = textPreview.frame
            textFrame.size.width = textPreview.frame.size.width + imWidth //+ leadingSpaceToImg
            textPreview.frame = textFrame
            print("textframe width after change: ", appendNewline: false)
            print(textPreview.frame.size.width, appendNewline: true)

            print("catframe width before change: ", appendNewline: false)
            print(categoryLabel.frame.size.width, appendNewline: true)
            var catFrame = categoryLabel.frame
            catFrame.size.width = categoryLabel.frame.size.width + imWidth //+ leadingSpaceToImg
            categoryLabel.frame = catFrame
            print("catframe width after change: ", appendNewline: false)
            print(categoryLabel.frame.size.width, appendNewline: true)

            
            
            headline.translatesAutoresizingMaskIntoConstraints = true
            writerLabel.translatesAutoresizingMaskIntoConstraints = true
            textPreview.translatesAutoresizingMaskIntoConstraints = true
            categoryLabel.translatesAutoresizingMaskIntoConstraints = true


        }
        
        imageView.clipsToBounds = true 

    }
    
    @IBAction func refreshPulled(sender: AnyObject) {
        currentPage = 1;
        parsing.getWebDataFromCategory(currentCategory.slug!, page_number: currentPage, completion: nil)
        refresher.endRefreshing()
    }
    
    //DONE
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if ((segue.identifier == "showDetail") || (segue.identifier == "showDetailFirst")) {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                Singleton.sharedInstance.currIndex = indexPath.row
                let selectedPost: NSDictionary = Singleton.sharedInstance.posts[indexPath.row] as NSDictionary
                (segue.destinationViewController as! DetailViewController).detailItem = Article(article: selectedPost)
            }
            
            let gesture = ((self.parentViewController)?.parentViewController as! MainViewController).panGestureRecognizer()
            gesture.enabled = false
        }
    }

}

