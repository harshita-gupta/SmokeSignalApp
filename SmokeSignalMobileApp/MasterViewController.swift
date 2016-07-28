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

final class MasterViewController: UITableViewController{
    
    @IBOutlet var activityBar: UIProgressView!
    
    @IBOutlet var postTable: UITableView!
    
    @IBOutlet var mainNavBar: UINavigationItem!
    
    @IBOutlet var refresher: UIRefreshControl!
    
    var currentCategory : Category = Category()
    
    var currentPage = 0
    var currentlyLoading = false
    
    override func viewDidLoad() {
        print("master view loaded", terminator: "\n")

        ((self.parent)?.parent as! MainViewController).panGestureRecognizer()

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let gesture = ((self.parent)?.parent as! MainViewController).panGestureRecognizer()
        gesture?.isEnabled = true
    }
    
    func setBarButton() {
        print("starts setting leftBarButtonItem", terminator: "\n")
        self.mainNavBar!.leftBarButtonItem = DrawerBarButtonItem(target: self, action: #selector(MasterViewController.toggleLeft))
        print("leftBarButtonItem set to: ", terminator: "")
        print(self.mainNavBar!.leftBarButtonItem, terminator: "\n")
        print("finished setting leftBarButtonItem", terminator: "\n")
        print("", terminator: "\n")

    }
    
    func toggleLeft() {
        print("DrawerBarButtonItem tapped.", terminator: "\n")
        ((Singleton.sharedInstance.mainViewControllerReference) as SWRevealViewController).revealToggle(animated: true)
    }
    
    func refreshWithNewCatSort(_ slug_name: String) {
        currentCategory = Category(slug_name: slug_name)
        addNavBarBanner()
        activityBar.progressTintColor = currentCategory.highlightColor
        refresher.backgroundColor = currentCategory.highlightColor
        currentPage = 1
        parsing.getWebDataFromCategory(currentCategory.slug!, page_number: currentPage, completion: nil)
    }
 
    func addNavBarBanner() {
        print("started adding top Navigation Bar", terminator: "\n")
        var imPresent : Bool
        if self.currentCategory.slug! == "" {
            imPresent = true
        }
        else {
            imPresent = false
        }
        let titleView = NavBarTitleView(frame: CGRect.zero, title: currentCategory.catName!,imagePresent: imPresent)

        let titleSize = titleView.systemLayoutSizeFitting(CGSize.zero)
        titleView.frame = CGRect(x: 0, y: 0, width: titleSize.width, height: titleSize.height)
        mainNavBar.titleView = titleView
        print("finished adding top Navigation Bar, view set to : ", terminator: "")
        print(mainNavBar.titleView, terminator: "\n")


        
        
    }
    
    
    //handles loading of extra table cells
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.sharedInstance.posts.count
    }

   // cell heights
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ((indexPath as NSIndexPath).row == 0) {
            return UITableViewAutomaticDimension
        }
        
        else {
            return 110
        }
    }
    
    //populates table with cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell : ArticleTableViewCell
        
        if ((indexPath as NSIndexPath).row == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: "mostRecentPreview", for: indexPath) as! LeadArticleTableViewCell
        }
        
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "article", for: indexPath) as! GeneralArticleTableViewCell
        }

        let currentArticle = parsing.articleForPostAtIndex((indexPath as NSIndexPath).row)
        
        cell.setArticle(currentArticle)
        
//        cell.setNeedsDisplay()
        
        return cell
    }
 
    
    @IBAction func refreshPulled(_ sender: AnyObject) {
        currentPage = 1;
        parsing.getWebDataFromCategory(currentCategory.slug!, page_number: currentPage, completion: nil)
        refresher.endRefreshing()
    }
    
    //DONE
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if ((segue.identifier == "showDetail") || (segue.identifier == "showDetailFirst")) {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedPost: Article = Singleton.sharedInstance.articleCache[(indexPath as NSIndexPath).row]!
                (segue.destinationViewController as! DetailViewController).detailItem = selectedPost
            }
            
            let gesture = ((self.parent)?.parent as! MainViewController).panGestureRecognizer()
            gesture?.isEnabled = false
        }
    }

}

