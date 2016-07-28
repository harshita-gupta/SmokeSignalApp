//
//  GeneralArticleTableViewCell.swift
//  The Smoke Signal
//
//  Created by Harshita Gupta on 6/9/15.
//  Copyright © 2015 The Smoke Signal. All rights reserved.
//

import Foundation
import UIKit

final class GeneralArticleTableViewCell : ArticleTableViewCell {
    
    @IBOutlet var categoriesConstraintExtra: NSLayoutConstraint!
    @IBOutlet var headlineConstraintExtra: NSLayoutConstraint!
    @IBOutlet var previewConstraintExtra: NSLayoutConstraint!
    @IBOutlet var dateConstraintExtra: NSLayoutConstraint!
    
    @IBOutlet var categoriesConstraintImage: NSLayoutConstraint!
    @IBOutlet var headlineConstraintImage: NSLayoutConstraint!
    @IBOutlet var previewContraintImage: NSLayoutConstraint!
    @IBOutlet var dateConstraintImage: NSLayoutConstraint!
    
    
    override func checksLayout() {
        if (super.currentArticle!.imageExists!) {
            
            imView.isHidden = false
            
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

            
            if (dateConstraintExtra.priority != 900) {
                dateConstraintExtra.priority = 900
            }
            if (dateConstraintImage.priority != 999) {
                dateConstraintImage.priority = 999
            }
            
            //////////////////////////////////////////////////////////////////////////////
        }
        else {
            super.imView.isHidden = true
            
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
            
            
            if (dateConstraintExtra.priority != 999) {
                dateConstraintExtra.priority = 999
            }
            if (dateConstraintImage.priority != 900) {
                dateConstraintImage.priority = 900
            }
            //////////////////////////////////////////////////////////////////////////////
            
            super.setNeedsLayout()
            
        }
        
        super.imView.clipsToBounds = true

    }
    
}
