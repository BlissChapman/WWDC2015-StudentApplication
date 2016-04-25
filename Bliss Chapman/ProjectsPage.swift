//
//  InformationPageCollectionViewCell.swift
//  Bliss Chapman
//
//  Created by Bliss Chapman on 4/17/15.
//  Copyright (c) 2015 Bliss Chapman. All rights reserved.
//

import UIKit

class ProjectsPage: UICollectionViewCell {
    
    @IBOutlet weak var titleOfPage: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var moreInformationButton: UIButton!
    
    @IBOutlet weak var arrowIndicator: UIButton!
    @IBOutlet weak var screenshotOne: UIImageView!
    @IBOutlet weak var screenshotThree: UIImageView!
    @IBOutlet weak var screenshotTwo: UIImageView!
    
    @IBOutlet weak var pdfView: UIWebView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //interface builder doesnt recognize the nib as a collection view cell so no touch events will occur unless I programmatically move my buttons into the cells contentview
    override func awakeFromNib() {
        self.contentView.addSubview(moreInformationButton)
        self.contentView.addSubview(arrowIndicator)
        self.contentView.addSubview(pdfView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("deinit called")
    }
}
