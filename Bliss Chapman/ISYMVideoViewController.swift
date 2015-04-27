//
//  ISYMVideoViewController.swift
//  Bliss Chapman
//
//  Created by Bliss Chapman on 4/25/15.
//  Copyright (c) 2015 Bliss Chapman. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ISYMVideoViewController: UIViewController {
    
    var moviePlayer: AVPlayer?
    
    //MARK: View Controller Lifecycle
    override func viewDidLoad() { setupPlayer() }
    
    private func setupPlayer() {
        if let path = NSBundle.mainBundle().pathForResource("MusicSample", ofType: "mov") {
            if let ISYMVideoURL = NSURL(fileURLWithPath: path) {
                
                moviePlayer = AVPlayer(URL: ISYMVideoURL)
                moviePlayer!.volume = 1.0
                let playerController = AVPlayerViewController()
                playerController.player = moviePlayer
                
                //I want the playback controls hidden when the view is displayed and then have them shown/enabled once all animations have settled down
                playerController.showsPlaybackControls = false
                
                self.addChildViewController(playerController)
                self.view.addSubview(playerController.view)
                playerController.view.frame = self.view.frame
                
                //play video and enable controls once all animations are finished
                let shortDelay = dispatch_time(DISPATCH_TIME_NOW, (Int64(Controls.SwitchTabsAnimationTime * 1.5) * Int64(NSEC_PER_SEC)))
                dispatch_after(shortDelay, dispatch_get_main_queue(), {
                    playerController.player.play()
                    playerController.showsPlaybackControls = true
                })
            }
        }
    }
}
