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
        
        self.tableView.estimatedRowHeight = 400 //todo find right cell height
            
            
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
        print("finished adding top Navigation Bar, view set to : ", appendNewline: false)
        print(mainNavBar.titleView, appendNewline: true)


        
        
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
            return UITableViewAutomaticDimension
        }
        
        else {
            return 110
        }
    }
    
    //populates table with cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell : ArticleTableViewCell
        
        if (indexPath.row == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("mostRecentPreview", forIndexPath: indexPath) as! LeadArticleTableViewCell
        }
        
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("article", forIndexPath: indexPath) as! GeneralArticleTableViewCell
        }

        let currentArticle = parsing.articleForPostAtIndex(indexPath.row)
        
        cell.setArticle(currentArticle)
        
//        cell.setNeedsDisplay()
        
        return cell
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

