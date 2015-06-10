//
//  GeneralArticleTableViewCell.swift
//  The Smoke Signal
//
//  Created by Harshita Gupta on 6/9/15.
//  Copyright © 2015 The Smoke Signal. All rights reserved.
//

import Foundation
import UIKit

class GeneralArticleTableViewCell : ArticleTableViewCell {
    
    @IBOutlet var categoriesConstraintExtra: NSLayoutConstraint!
    @IBOutlet var headlineConstraintExtra: NSLayoutConstraint!
    @IBOutlet var previewConstraintExtra: NSLayoutConstraint!
    @IBOutlet var writerNameConstraintExtra: NSLayoutConstraint!
    
    @IBOutlet var categoriesConstraintImage: NSLayoutConstraint!
    @IBOutlet var headlineConstraintImage: NSLayoutConstraint!
    @IBOutlet var previewContraintImage: NSLayoutConstraint!
    @IBOutlet var writerNameConstraintImage: NSLayoutConstraint!
    
    
    override func checksLayout() {
        if (super.currentArticle!.imageExists!) {
            
            imView.hidden = false
            
            //////////////////////////increasing priority of image constraints and minimizing it for extra constraints
            
            if (categoriesConstraintExtra.priority != 900) {
                categoriesConstraintExtra.priority = 900
            }
            if (categoriesConstraintImage.priority != 999) {
                categoriesConstraintImage.priority = 999
            }
            
            
            if (headlineConstraintExtra.priority != 900) {
                headlineConstraintExtra.priority = 900
            }
            if (headlineConstraintImage.priority != 999) {
                headlineConstraintImage.priority = 999
            }

            
            if (previewConstraintExtra.priority != 900) {
                previewConstraintExtra.priority = 900
            }
            if (previewContraintImage.priority != 999) {
                previewContraintImage.priority = 999
            }

            
            if (writerNameConstraintExtra.priority != 900) {
                writerNameConstraintExtra.priority = 900
            }
            if (writerNameConstraintImage.priority != 999) {
                writerNameConstraintImage.priority = 999
            }
            
            //////////////////////////////////////////////////////////////////////////////
            
            super.imView.sd_setImageWithURL(currentArticle!.fullImageURL!)
        }
        else {
            super.imView.hidden = true
            
            //////////////////////////increasing priority of extra constraints and minimizing it for image constraints
            if (categoriesConstraintExtra.priority != 999) {
                categoriesConstraintExtra.priority = 999
            }
            if (categoriesConstraintImage.priority != 900) {
                categoriesConstraintImage.priority = 900
            }
            
            
            if (headlineConstraintExtra.priority != 999) {
                headlineConstraintExtra.priority = 999
            }
            if (headlineConstraintImage.priority != 900) {
                headlineConstraintImage.priority = 900
            }
            
            
            if (previewConstraintExtra.priority != 999) {
                previewConstraintExtra.priority = 999
            }
            if (previewContraintImage.priority != 900) {
                previewContraintImage.priority = 900
            }
            
            
            if (writerNameConstraintExtra.priority != 999) {
                writerNameConstraintExtra.priority = 999
            }
            if (writerNameConstraintImage.priority != 900) {
                writerNameConstraintImage.priority = 900
            }
            //////////////////////////////////////////////////////////////////////////////
            
            super.setNeedsLayout()
            
        }
        
        super.imView.clipsToBounds = true

    }
    
}