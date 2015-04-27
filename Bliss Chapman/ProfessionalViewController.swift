//
//  ProfessionalViewController.swift
//  Bliss Chapman
//
//  Created by Bliss Chapman on 4/25/15.
//  Copyright (c) 2015 Bliss Chapman. All rights reserved.
//

import UIKit

class ProfessionalViewController: UIViewController {
    
    @IBOutlet weak var agribleDescription: UILabel!
    @IBOutlet weak var agribleImageView: UIImageView!
    
    @IBOutlet weak var mobileDevDayDescription: UILabel!
    @IBOutlet weak var mobileDevDayImageView: UIImageView!
    
    @IBOutlet weak var cocoanutsImageView: UIImageView!
    @IBOutlet weak var cocoaNutsDescription: UILabel!
    
    
    private var myModel = Model()
    
    private struct URLs {
        static let MobileDevDay = "http://researchpark.illinois.edu/mobile-development-day"
        static let CocoaNuts = "http://facebook.us7.list-manage.com/subscribe?u=996a85f390f51daa7d0288ee6&id=2f297d0947"
        static let Agrible = "http://www.agrible.com"
    }
    
    private enum Image: Int {
        case Agrible = 1
        case MobileDevDay = 2
        case CocoaNuts = 3
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        
        //fill in/interpret all data from the model
        agribleDescription.text = myModel.agribleDescription
        agribleImageView.image = myModel.agribleImage
        mobileDevDayDescription.text = myModel.mobileDevDayDescription
        mobileDevDayImageView.image = myModel.mobileDevDayImage
        cocoaNutsDescription.text = myModel.cocoaNutsDescription
        cocoanutsImageView.image = myModel.cocoaNutsImage
    }

    //open associated link if one of the images is tapped
    @IBAction private func imageTapped(sender: UITapGestureRecognizer) {
        if let image = sender.view?.tag {
            switch image {
            case Image.Agrible.rawValue:
                myModel.openURL(URLs.Agrible)
            case Image.MobileDevDay.rawValue:
                myModel.openURL(URLs.MobileDevDay)
            case Image.CocoaNuts.rawValue:
                myModel.openURL(URLs.CocoaNuts)
            default: break
            }
        }
    }

}
