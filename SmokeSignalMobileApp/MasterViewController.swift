//
//  MasterViewController.swift
//  SmokeSignalMobileApp
//
//  Created by Harshita Gupta on 11/8/14.
//  Copyright (c) 2014 The Smoke Signal. All rights reserved.
//

import UIKit
import Foundation
class MasterViewController: UITableViewController, UIScrollViewDelegate{
    
    @IBOutlet var activityBar: UIProgressView!
    
    @IBOutlet var postTable: UITableView!
    
    @IBOutlet var mainNavBar: UINavigationItem!
    
    @IBOutlet var refresher: UIRefreshControl!
    
    var currentCategory : Category = Category()
    
    
    var currentPage = 0
    var currentlyLoading = false
    
    override func viewDidLoad() {
        println("master view loaded")
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
    
    
    func setBarButton() {
        println("starts setting leftBarButtonItem")
        self.mainNavBar!.leftBarButtonItem = DrawerBarButtonItem(target: self, action: "toggleLeft")
        print("leftBarButtonItem set to: ")
        println(self.mainNavBar!.leftBarButtonItem)
        println("finished setting leftBarButtonItem")
        println("")

    }
    
    func toggleLeft() {
        println("DrawerBarButtonItem tapped.")
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
        println("started adding top Navigation Bar")
        
        var navBarVCFromCat = currentCategory.navBarFinal!
        
        mainNavBar.titleView = navBarVCFromCat.view
        
        
        var leftBarButtonWidth = mainNavBar!.leftBarButtonItem!.customView!.frame.width  + 10.0
        print("leftbarbutton width: ")
        println(mainNavBar!.leftBarButtonItem?.customView?.frame.width)

        print("titleView frame: ")
        println(mainNavBar.titleView?.frame)
        
        
        var totalAvailW = navigationController!.navigationBar.frame.size.width
        
        print("available width: ")
        println(totalAvailW)
        
        
        var contentW = navBarVCFromCat.topLabel.frame.size.width + navBarVCFromCat.topImage.frame.size.width + 3
        
        
        print("content width: ")
        println(contentW)

        
        var spaceEachSide = (totalAvailW - contentW) / 2
        
        print("space on either side: ")
        println(spaceEachSide)


        navBarVCFromCat.topLabel.setTranslatesAutoresizingMaskIntoConstraints(true)
        navBarVCFromCat.topImage.setTranslatesAutoresizingMaskIntoConstraints(true)

        
        var labelFrame = navBarVCFromCat.topLabel.frame
        
        labelFrame.origin.x = 0.0//spaceEachSide
        //CGRectMake(spaceEachSide, 0, navBarVCFromCat.topLabel.frame.size.width, self.navigationController!.navigationBar.frame.size.height)
        
        labelFrame.origin.y = floor(self.navigationController!.navigationBar.frame.size.height - labelFrame.size.height) / 2.0
        
        var imageFrame = navBarVCFromCat.topImage.frame//CGRectMake(spaceEachSide + navBarVCFromCat.topLabel.frame.size.width + 3, 0, navBarVCFromCat.topLabel.frame.size.width, self.navigationController!.navigationBar.frame.size.height)
        
        imageFrame.origin.x = labelFrame.origin.x + labelFrame.width + 3.0
        
        imageFrame.origin.y = floor(self.navigationController!.navigationBar.frame.size.height - imageFrame.size.height) / 2

        
        navBarVCFromCat.topLabel.frame = labelFrame
        navBarVCFromCat.topImage.frame = imageFrame

        print("label value: ")
        println(navBarVCFromCat.topLabel.text)

        print("image value: ")
        println(navBarVCFromCat.topImage.image)

    
        print("label frame: ")
        println(navBarVCFromCat.topLabel.frame)
        
        print("image frame: ")
        println(navBarVCFromCat.topImage.frame)
        
        var width = self.view.frame.size.width
        
        navBarVCFromCat.view.addSubview(navBarVCFromCat.topLabel!)
        navBarVCFromCat.view.addSubview(navBarVCFromCat.topImage!)

        
        //navBarVCFromCat.topLabel.backgroundColor = UIColor.yellowColor()
        
        var topLogoContainerView : UIView = UIView(frame: CGRectMake(leftBarButtonWidth, 0, self.navigationController!.navigationBar.frame.size.width - leftBarButtonWidth, self.navigationController!.navigationBar.frame.size.height))
        
        print("toplogocontainerview: ")
        println(topLogoContainerView)

        
        navBarVCFromCat.view.frame = CGRectMake(spaceEachSide - topLogoContainerView.frame.origin.x , 0, contentW, self.navigationController!.navigationBar.frame.size.height)
        
        //navBarVCFromCat.view.backgroundColor = UIColor.blueColor()
        topLogoContainerView.addSubview(navBarVCFromCat.view)
        
        navBarVCFromCat.view.frame = CGRectMake(spaceEachSide - topLogoContainerView.frame.origin.x , 0, contentW, self.navigationController!.navigationBar.frame.size.height)

        //topLogoContainerView.backgroundColor = UIColor.redColor()
        
        mainNavBar.titleView = topLogoContainerView
        //mainNavBar.titleView?.backgroundColor = UIColor.greenColor()
        Singleton.sharedInstance.headlineView = topLogoContainerView
        
        //self.view = topLogoContainerView
        
        print("navbar title view: ")
        println(navBarVCFromCat.view)

        
        print("title view: ")
        println(mainNavBar.titleView)

//        var testView = UIView()
//        var testLabel = UILabel(frame: CGRectMake(0, 0, 120, 44))
//        testLabel.text = "YOOOO"
//        testView.addSubview(testLabel)
//        
//        
//        mainNavBar.titleView = testView
//        mainNavBar.title = "Harshita is Great"
        
        
//        print(currentCategory.topBanner!.description)
//        var topLogo : UIImage = currentCategory.topBanner!
//        var topLogoView : UIImageView = UIImageView(image: topLogo)
//
//        var logoSizeLength :CGFloat = topLogo.size.width//(navigationController!.navigationBar.frame.size.width - 30) * 0.7
//        var logoSizeHeight : CGFloat = topLogo.size.height//logoSizeLength * (83/462)
//        
//        var logoSize = CGSizeMake(logoSizeLength, logoSizeHeight)
//        
//        print(logoSize)
//        print(topLogo)
//        
//        var resizedImage = topLogo//parsing.RBResizeImage(topLogo, targetSize: logoSize)
//        
//        var yPos = floor(self.navigationController!.navigationBar.frame.size.height - resizedImage.size.height) / 2
//        
//        var xPos = floor(self.navigationController!.navigationBar.frame.size.width - resizedImage.size.width) / 2
//        
//        topLogoView.frame = CGRectMake(xPos, yPos, resizedImage.size.width, resizedImage.size.height)
//        
//        println(topLogoView.frame)
//        
//        var width = 0.9 * self.view.frame.size.width
//        
//        var topLogoContainerView : UIView = UIView(frame: CGRectMake(0, 0, width, self.navigationController!.navigationBar.frame.size.height))
//        topLogoContainerView.addSubview(topLogoView)
//        mainNavBar.titleView = topLogoContainerView
   
    
        println("finished adding top navigation bar")
    }
    
    
    //handles loading of extra table cells
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        var currentOffset : CGFloat = scrollView.contentOffset.y
        var maximumOffset : CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        
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

    //cell heights
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 250
        }
        
        else {
            return 120
        }
    }
    
    //populates table with cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell : UITableViewCell
        
        if (indexPath.row == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("mostRecentPreview", forIndexPath: indexPath) as! UITableViewCell
        }
        
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("article", forIndexPath: indexPath) as! UITableViewCell
        }
        
        fillCells(cell, indexPath: indexPath)
        cell.setNeedsDisplay()
        return cell
    }
    
    // configures stuff for cells
    func fillCells(cell: UITableViewCell, indexPath: NSIndexPath) {
        var currentPostDictionary : NSDictionary = Singleton.sharedInstance.posts[indexPath.row] as NSDictionary
        
        var currentArticle : Article = Article(article: currentPostDictionary)
        
        var categoryLabel = cell.viewWithTag(8) as! UILabel
        var headline = cell.viewWithTag(1) as! UILabel
        var dateLabel = cell.viewWithTag(4) as! UILabel
        var writerLabel = cell.viewWithTag(5) as! UILabel
        var textPreview = cell.viewWithTag(2) as! UILabel
        var imageView = cell.viewWithTag(3) as! UIImageView

        
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
            
            var leadingSpaceToImg : CGFloat = 3.0
            var imWidth = imageView.frame.size.width
            imageView.hidden = true
            
            headline.setTranslatesAutoresizingMaskIntoConstraints(true)
            writerLabel.setTranslatesAutoresizingMaskIntoConstraints(true)
            textPreview.setTranslatesAutoresizingMaskIntoConstraints(true)
            categoryLabel.setTranslatesAutoresizingMaskIntoConstraints(true)

            var headFrame = headline.frame
            headFrame.size.width = headline.frame.size.width + imWidth //+ leadingSpaceToImg
            headline.frame = headFrame
            
            var writerFrame = writerLabel.frame
            writerFrame.size.width = writerLabel.frame.size.width + imWidth //+ leadingSpaceToImg
            writerLabel.frame = writerFrame
            
            var textFrame = textPreview.frame
            textFrame.size.width = textPreview.frame.size.width + imWidth //+ leadingSpaceToImg
            textPreview.frame = textFrame
            
            var catFrame = categoryLabel.frame
            catFrame.size.width = categoryLabel.frame.size.width + imWidth //+ leadingSpaceToImg
            categoryLabel.frame = catFrame
            
            headline.setTranslatesAutoresizingMaskIntoConstraints(true)
            writerLabel.setTranslatesAutoresizingMaskIntoConstraints(true)
            textPreview.setTranslatesAutoresizingMaskIntoConstraints(true)
            categoryLabel.setTranslatesAutoresizingMaskIntoConstraints(true)


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
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                Singleton.sharedInstance.currIndex = indexPath.row
                let selectedPost: NSDictionary = Singleton.sharedInstance.posts[indexPath.row] as NSDictionary
                (segue.destinationViewController as! DetailViewController).detailItem = Article(article: selectedPost)
            }
        }
    }

}

