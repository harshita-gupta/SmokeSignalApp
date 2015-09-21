//
//  ArticleTableViewCell.swift
//  The Smoke Signal
//
//  Created by Harshita Gupta on 6/9/15.
//  Copyright © 2015 The Smoke Signal. All rights reserved.
//

import Foundation
import UIKit

class ArticleTableViewCell : UITableViewCell {
    
    var currentArticle : Article?
    
    @IBOutlet final var categoryLabel: UILabel!
    @IBOutlet final var textPreview: UILabel!
    @IBOutlet final var datePostedLabel: UILabel!
    @IBOutlet final var writerLabel: UILabel!
    @IBOutlet final var imView: UIImageView!
    @IBOutlet final var headline: UILabel!

    
    final func setArticle(currArticle: Article) {
        
        self.currentArticle = currArticle
        
        if (self.currentArticle!.categoriesString != nil) {
            categoryLabel.text = self.currentArticle!.categoriesString!
        }
        
        if (self.currentArticle!.headline != nil) {
            headline.text = self.currentArticle!.headline!
        }
        
        if (self.currentArticle!.postedDateText != nil) {
            datePostedLabel.text = self.currentArticle!.postedDateText!
        }
        
        if (self.currentArticle!.writerString != nil) {
            writerLabel.text = self.currentArticle!.writerString!
        }
        else {
            writerLabel.text = ""
        }
        
        if (self.currentArticle!.previewText != nil) {
            textPreview.text = self.currentArticle!.previewText!
        }
        
        if (self.currentArticle!.imageExists!) {
            
            imView.hidden = false
            imView.sd_setImageWithURL(self.currentArticle!.fullImageURL!)
        }
        else {
            imView.hidden = true
        }
        
        imView.clipsToBounds = true

        checksLayout()
        
    }

    func checksLayout() {
        
    }

}