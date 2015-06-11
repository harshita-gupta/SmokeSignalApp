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
    @IBOutlet var webViewHeightConstraint: NSLayoutConstraint!
    
    var currentArticle : Article = Article()

    var detailItem: Article? {
        didSet {
            currentArticle = detailItem!
            // Update the view.
            //self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.delegate = self
        self.configureValues()
        self.configureView()
        self.configureWebViewValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        let webViewHeightString : String = webView.stringByEvaluatingJavaScriptFromString("document.body.scrollHeight")!
        let webViewHeight = (webViewHeightString as NSString).floatValue
        webViewHeightConstraint.constant = CGFloat(webViewHeight)
        webView.setNeedsUpdateConstraints()
    }
    
    func configureValues() {
        //updates all the UILabels that hold values.
        
        let currentArticle = (self.detailItem)
        
        self.categoryLabel.text = currentArticle!.categoriesString!
        self.headlineLabel.text = currentArticle!.headline!
        self.writerNameLabel.text = (currentArticle!.writerString!).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        self.postedDateLabel.text = currentArticle!.postedDateText!
        
        if (currentArticle!.postedDateText == currentArticle!.updatedDateText) {
            updatedDateLabel.text = ""
        }
        else {
            self.updatedDateLabel.text = "Updated: " + currentArticle!.updatedDateText!
        }
    }
    
    func configureWebViewValues(){
        // loads webview with content
        let loadContent = self.currentArticle.content!
        
        // if debugging, add "body {background: green}" to CSS
        let stringToBeLoadedPt1 = "<html><head><style>" + "p { font-size: 13px;}" + (Singleton.sharedInstance.universalCSS as String)
        let stringToBeLoadedPt2 = "</head></style><body>" + (loadContent) + "</body></html>"
        let stringToBeLoaded = ( stringToBeLoadedPt1 + stringToBeLoadedPt2 )
        webView.loadHTMLString(stringToBeLoaded, baseURL: nil)
    }
    
    func configureView() {
        self.headlineLabel.sizeToFit()
        self.writerNameLabel.sizeToFit()
        //self.writerNameLabel.needsUpdateConstraints()
        //self.headlineLabel.needsUpdateConstraints()
    }
        
   
}

