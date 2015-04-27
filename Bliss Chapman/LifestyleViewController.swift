//
//  LifestyleViewController.swift
//  Bliss Chapman
//
//  Created by Bliss Chapman on 4/25/15.
//  Copyright (c) 2015 Bliss Chapman. All rights reserved.
//

import UIKit

class LifestyleViewController: UIViewController {
    
    @IBOutlet weak var bodyText: UILabel!
    @IBOutlet weak var balletContainerView: UIView!
    @IBOutlet weak var musicContainerView: UIView!
    
    private struct Segues {
        static let Ballet = "BalletVideo"
        static let Music = "MusicVideo"
    }
    
    private var myModel = Model()
    
    private var BalletVideoPlayer: CUBVideo?
    
    //ISYM stands for Illinois Summer Youth Music
    private var MusicVideoPlayer: ISYMVideoViewController?
    
    //MARK: View Controller Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //if the user switches tabs, be sure to pause the videos
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        BalletVideoPlayer?.moviePlayer?.pause()
        MusicVideoPlayer?.moviePlayer?.pause()
    }
    
    //MARK: User Interface
    private func configureUI() {
        bodyText.text = myModel.artTextDescription
        musicContainerView.layer.borderColor = UIColor.grayColor().CGColor
        musicContainerView.layer.borderWidth = 2.0
        balletContainerView.layer.borderColor = UIColor.grayColor().CGColor
        balletContainerView.layer.borderWidth = 2.0
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Segues.Ballet:
                if let vc = segue.destinationViewController as? CUBVideo {
                    BalletVideoPlayer = vc
                }
            case Segues.Music:
                if let vc = segue.destinationViewController as? ISYMVideoViewController {
                    MusicVideoPlayer = vc
                }
            default: break
            }
        }
    }
    
    
}
