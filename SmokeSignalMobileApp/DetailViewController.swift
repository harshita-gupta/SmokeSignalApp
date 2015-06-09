//
//  DetailViewController.swift
//  SmokeSignalMobileApp
//
//  Created by Harshita Gupta on 11/8/14.
//  Copyright (c) 2014 The Smoke Signal. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIWebViewDelegate {


    @IBOutlet var centerBar: UINavigationItem!
    
    @IBOutlet var webView: UIWebView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var categoryLabel: UILabel!
    
    @IBOutlet var headlineLabel: UILabel!
    
    @IBOutlet var writerNameLabel: UILabel!
    
    @IBOutlet var postedDateLabel: UILabel!
    
    @IBOutlet var updatedDateLabel: UILabel!
    
    var currentArticle : Article = Article()

    var detailItem: Article? {
        didSet {
            currentArticle = detailItem!
            // Update the view.
            self.configureView()
        }
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = true
        headlineLabel.translatesAutoresizingMaskIntoConstraints = true
        writerNameLabel.translatesAutoresizingMaskIntoConstraints = true
        postedDateLabel.translatesAutoresizingMaskIntoConstraints = true
        updatedDateLabel.translatesAutoresizingMaskIntoConstraints = true

        
        //////creates frame for webview and sets the webview to that frame//////////////
        var webFrame = webView.frame
        webFrame.size.width = scrollView.frame.width - 8
        webFrame.origin = CGPointMake(0, postedDateLabel.frame.origin.y + postedDateLabel.frame.height + 3)
        webView.frame = webFrame
        ////////////////////////////////////////////////////////////

        
        ////handles checking required height of webview//////
        let webViewHeightString : String = webView.stringByEvaluatingJavaScriptFromString("document.body.scrollHeight")!
        let webViewHeight = (webViewHeightString as NSString).floatValue
        let cgWebViewHeight : CGFloat = CGFloat(webViewHeight)
        ////////////////////////////////////////////////////////////
        
        print(cgWebViewHeight, appendNewline: true)
        print("", appendNewline: true)
        
        ////creates frame for scrollview and sets the scrollview to that frame////////
        var scrollFrame = scrollView.frame
        scrollFrame.size.height = cgWebViewHeight + 102
        scrollView.contentSize = scrollFrame.size
        ////////////////////////////////////////////////////////////

        
        //////creates frame for webview and sets the webview to that frame//////////////
        webFrame = webView.frame
        webFrame.size.height = cgWebViewHeight
        webFrame.origin = CGPointMake(0, postedDateLabel.frame.origin.y + postedDateLabel.frame.height + 3)
        webView.frame = webFrame
        ////////////////////////////////////////////////////////////
        
        
        webView.translatesAutoresizingMaskIntoConstraints = true
        scrollView.addSubview(webView)
        webView.frame = webFrame
        
        
    
}
    
    func moveBack() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewWillLayoutSubviews() {
        print("latermethod", appendNewline: true)
        print(self.navigationItem.leftBarButtonItem, appendNewline: true)
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        self.view.addSubview(webView)
        let currentArticle = (self.detailItem)
            if let _: Article = self.detailItem {
                if let label = self.centerBar {
                    label.title = ""//((self.currentArticle.headline!).kv_decodeHTMLCharacterEntities())
                }
    }
        

        //self.centerBar.leftBarButtonItem = nil
        print("view being configured", appendNewline: true)
        print(self.navigationItem.leftBarButtonItem, appendNewline: true)//leftBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: self, action: "moveBack")
        
        self.categoryLabel.text = currentArticle!.categoriesString!
        self.headlineLabel.text = currentArticle!.headline!

        categoryLabel.translatesAutoresizingMaskIntoConstraints = true
        headlineLabel.translatesAutoresizingMaskIntoConstraints = true
        writerNameLabel.translatesAutoresizingMaskIntoConstraints = true
        postedDateLabel.translatesAutoresizingMaskIntoConstraints = true
        updatedDateLabel.translatesAutoresizingMaskIntoConstraints = true
        
        
        var categoryFrame = categoryLabel.frame
//        categoryFrame.size.height = 17
        categoryFrame.size.width = self.view.frame.size.width - 16
//        categoryFrame.origin.x = scrollView.frame.origin.x
//        categoryFrame.origin.y = scrollView.frame.origin.y
        categoryLabel.frame = categoryFrame
        
        var headlineFrame = self.headlineLabel.frame
        headlineFrame.size.width = self.view.frame.size.width - 16
        print("headline frame size : ", appendNewline: false)
        print(headlineFrame.size.width, appendNewline: true)
        self.headlineLabel.frame = headlineFrame
        
        let heightBefore = self.headlineLabel.frame.height

        self.headlineLabel.sizeToFit()
        
        let heightAfter = self.headlineLabel.frame.height

        let changeInHeight = heightAfter - heightBefore
        
        self.headlineLabel.frame.height
        self.writerNameLabel.text = (currentArticle!.writerString!).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        self.postedDateLabel.text = currentArticle!.postedDateText!
        
        if (currentArticle!.postedDateText == currentArticle!.updatedDateText) {
            updatedDateLabel.text = ""
        }
        else {
            self.updatedDateLabel.text = "Updated: " + currentArticle!.updatedDateText!
        }
        
        
        //Moving writerlabel and postdate and updatedatelabel
        var writerLabelFrame = writerNameLabel.frame
        writerLabelFrame.origin.y = writerLabelFrame.origin.y + changeInHeight
        writerLabelFrame.size.width = self.view.frame.size.width - 16
        writerNameLabel.frame = writerLabelFrame
        
        var postedLabelFrame = postedDateLabel.frame
        postedLabelFrame.origin.y = postedLabelFrame.origin.y + changeInHeight
        postedDateLabel.frame = postedLabelFrame
        
        var updateFrame = updatedDateLabel.frame
        updateFrame.origin.y = updateFrame.origin.y + changeInHeight
        updatedDateLabel.frame = updateFrame
        
        
        
        // loads webview with content
        let loadContent = self.currentArticle.content!
        // if debugging, add "body {background: green}" to CSS
        let stringToBeLoadedPt1 = "<html><head><style>" + "p { font-size: 13px;}" + (Singleton.sharedInstance.universalCSS as String)
        let stringToBeLoadedPt2 = "</head></style><body>" + (loadContent) + "</body></html>"

        let stringToBeLoaded = ( stringToBeLoadedPt1 + stringToBeLoadedPt2 )
        webView.loadHTMLString(stringToBeLoaded, baseURL: nil)
        ///////////////////////////////////////////////////
    }
        
     override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        webView.delegate = self
        self.navigationController?.navigationBar.translucent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

