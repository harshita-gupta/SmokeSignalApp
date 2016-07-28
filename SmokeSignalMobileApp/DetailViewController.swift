//
//  DetailViewController.swift
//  SmokeSignalMobileApp
//
//  Created by Harshita Gupta on 11/8/14.
//  Copyright (c) 2014 The Smoke Signal. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController, UIWebViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {


    @IBOutlet var featuredImageAspectRatioConstraint: NSLayoutConstraint!
    @IBOutlet var featuredImageView: UIImageView!
    @IBOutlet var centerBar: UINavigationItem!
    @IBOutlet var webView: UIWebView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var writerNameLabel: UILabel!
    @IBOutlet var postedDateLabel: UILabel!
    @IBOutlet var updatedDateLabel: UILabel!
    @IBOutlet var webViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var imageGalleryCollView: UICollectionView!
    @IBOutlet var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var shareBarButtonItem: UIBarButtonItem!
    @IBOutlet var galleryTopBorder: UIView!
    @IBOutlet var galleryBottomBorder: UIView!
    
    @IBAction func shareButtonPressed(_ sender: AnyObject) {
        let textToShare = currentArticle.headline!
        if let myWebsite = currentArticle.articleURL
        {
            let objectsToShare = [textToShare + "- Read it on the Smoke Signal Website! " + String(myWebsite)]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            if #available(iOS 9.0, *) {
                activityVC.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeAssignToContact,UIActivityTypeOpenInIBooks, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll]
            } else {
                activityVC.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll]
            }
            
            self.present(activityVC, animated: true, completion: nil)
        }

        
    }
    
    
    @IBAction func favorited(_ sender: AnyObject) {
        
        
    }
    
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
        
        self.configureGalleryView()
        
        webView.delegate = self
        imageGalleryCollView.delegate = self
        imageGalleryCollView.dataSource = self;
        
        self.configureValues()
        self.configureView()
        self.configureWebViewValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        let webViewHeightString : String = webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight")!
        let webViewHeight = (webViewHeightString as NSString).floatValue
        webViewHeightConstraint.constant = CGFloat(webViewHeight)
        webView.setNeedsUpdateConstraints()
    }
    
    func configureValues() {
        //updates all the UILabels that hold values.
        
        let currentArticle = (self.detailItem)
        
        self.categoryLabel.text = currentArticle!.categoriesString!
        self.headlineLabel.text = currentArticle!.headline!
        self.writerNameLabel.text = (currentArticle!.writerString!).trimmingCharacters(in: CharacterSet.whitespaces)
        self.postedDateLabel.text = currentArticle!.postedDateText!
        
        if (currentArticle!.postedDateText == currentArticle!.updatedDateText) {
            updatedDateLabel.text = ""
        }
        else {
            self.updatedDateLabel.text = "Updated: " + currentArticle!.updatedDateText!
        }
        if (self.currentArticle.imageExists!) {
            featuredImageView.sd_setImage(with: self.currentArticle.fullImageURL! as URL!)
        }
        else {
            featuredImageView.isHidden = true
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
    
    func configureGalleryView() {
        if currentArticle.juiceBoxExists!  {
            self.collectionViewHeightConstraint.constant = scrollView.frame.size.width / 1.5
            
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
            flowLayout.minimumInteritemSpacing = 0.0
            flowLayout.minimumLineSpacing = 0.0
            self.imageGalleryCollView.isPagingEnabled = true
            self.imageGalleryCollView.collectionViewLayout = flowLayout
            print(imageGalleryCollView)
        }
        else {
            self.imageGalleryCollView.removeFromSuperview()
            self.galleryBottomBorder.removeFromSuperview()
            self.galleryTopBorder.removeFromSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (currentArticle.juiceBoxImageLinks?.count)!
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        
        let imageView: UIImageView = cell.viewWithTag(100) as! UIImageView
        imageView.sd_setImage(with: currentArticle.juiceBoxImageLinks![(indexPath as NSIndexPath).item] as URL, placeholderImage: UIImage(named: "placeholderMoutains"))
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.imageGalleryCollView.frame.size
    }
    
    
    
    func configureView() {
        self.scrollView.flashScrollIndicators()
        self.imageGalleryCollView.flashScrollIndicators()
        self.scrollView.indicatorStyle = UIScrollViewIndicatorStyle.black
        self.imageGalleryCollView.indicatorStyle = UIScrollViewIndicatorStyle.black
        self.scrollView.scrollsToTop = true
        self.scrollView.bounces = true
        self.scrollView.alwaysBounceVertical = true
    }
    
    
}

