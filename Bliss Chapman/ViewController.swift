//
//  ViewController.swift
//  Bliss Chapman
//
//  Created by Bliss Chapman on 4/17/15.
//  Copyright (c) 2015 Bliss Chapman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var profilePicture: UIButton!
    @IBOutlet weak var professionalBubble: UIButton!
    @IBOutlet weak var projectsBubble: UIButton!
    @IBOutlet weak var educationBubble: UIButton!
    @IBOutlet weak var lifestyleBubble: UIButton!
    
    
    private struct Constants {
        static let EmbedSegue = "Embedded Tab View Controller"
        static let NavigationBubblesPulsePercent: CGFloat = 3.0
        static let BubbleFlyOutTime: NSTimeInterval = 1.0
        static let BubbleAnimationSpringDamping: CGFloat = 0.70
        static let TimeForCompletePulse = 1.5
    }
    
    private enum Tabs: Int {
        case Professional = 1
        case ProfileOverview = 2
        case Projects = 0
        case Education = 4
        case Lifestyle = 3
    }
    
    private var pulseBubbleCounter = 1
    private var pulsingTimer: NSTimer?
    
    private var myTabBarController: UITabBarController? {
        didSet {
            myTabBarController?.selectedIndex = Tabs.ProfileOverview.rawValue
            myTabBarController?.tabBar.hidden = true
        }
    }
    
    private var lastSelected: UIButton?
    
    private var bubble1PulsingTimer: NSTimer?
    private var bubble2PulsingTimer: NSTimer?
    private var bubble3PulsingTimer: NSTimer?
    private var bubble4PulsingTimer: NSTimer?
    private var bubble5PulsingTimer: NSTimer?

    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        openingAnimation()
        flyInNavigationBubbles()
    }
    
    //MARK: User Interface Management
    private func configureUI() {
        // all navigation bubbles are circular
        profilePicture.isCircular(true)
        professionalBubble.isCircular(true)
        projectsBubble.isCircular(true)
        educationBubble.isCircular(true)
        lifestyleBubble.isCircular(true)
        
        // Translate all navigation bubbles off screen so I can animate them back in to their original constraints -> safer than animating/changing constraints
        profilePicture.transform = CGAffineTransformMakeTranslation(0, -profilePicture.bounds.size.height)
        view.addSubview(profilePicture)
        
        _ = self.view.frame.width
        professionalBubble.alpha = 0.0
        projectsBubble.alpha = 0.0
        educationBubble.alpha = 0.0
        lifestyleBubble.alpha = 0.0
        professionalBubble.transform = CGAffineTransformMakeTranslation(profilePicture.center.x - professionalBubble.center.x, 0)
        projectsBubble.transform = CGAffineTransformMakeTranslation(profilePicture.center.x - projectsBubble.center.x, 0)
        educationBubble.transform = CGAffineTransformMakeTranslation(profilePicture.center.x - educationBubble.center.x, 0)
        lifestyleBubble.transform = CGAffineTransformMakeTranslation(profilePicture.center.x - lifestyleBubble.center.x, 0)
        
        
        // Translate InformationCollectionViewController's view off screen so that I can animate it back in to its original constraints -> much safer than changing the constraints or animating them
        let offset = self.view.frame.height
        if let viewToTranslate = containerView {
            viewToTranslate.transform = CGAffineTransformMakeTranslation(0, offset)
            viewToTranslate.layer.masksToBounds = true
            viewToTranslate.layer.cornerRadius = 12 //12 is arbitrary
        }
    }
    
    private func openingAnimation() {
        UIView.animateWithDuration(0.8, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.profilePicture.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.height * 6/8)
            }, completion: { action in
                UIView.animateWithDuration(2, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.0, options: .CurveEaseIn, animations: {
                    self.profilePicture.transform = CGAffineTransformIdentity
                    self.containerView?.transform = CGAffineTransformIdentity
                    self.containerView?.alpha = 1.0
                    }, completion: nil)
        })
    }
    
    @IBAction private func navigationBubbleTapped(sender: UIButton) {
        //if the bubble is already selected, do a little shake animation
        if lastSelected == sender {
            sender.shake()
            return
        }
        
        //switch tabs to the selected bubble
        if let bubbleChosen = sender.currentTitle {
            if myTabBarController != nil {
                deselectAllBubbles()
                stopWaveAnimation()
                switch bubbleChosen {
                case "Bubble1":
                    switchTabs(professionalBubble, index: Tabs.Professional.rawValue)
                case "Projects":
                    switchTabs(projectsBubble, index: Tabs.Projects.rawValue)
                case "ProfileOverview":
                    switchTabs(profilePicture, index: Tabs.ProfileOverview.rawValue)
                case "Education":
                    switchTabs(educationBubble, index: Tabs.Education.rawValue)
                case "Lifestyle":
                    switchTabs(lifestyleBubble, index: Tabs.Lifestyle.rawValue)
                default: break
                }
            }
        }
    }
    
    private func switchTabs(bubble: UIButton, index: Int) {
        //disable all bubbles so that no conflicting switches are happening at the same time
        toggleBubblesEnabled(false)
        
        //select the bubble that was chosen
        bubble.isSelected(true)

        UIView.animateWithDuration(Controls.SwitchTabsAnimationTime/2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            bubble.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.height * 6.2/8)
            self.containerView.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.height * 6.2/8)
            self.containerView.alpha = 0.5
            }, completion: { action in
                self.myTabBarController?.selectedIndex = index
                self.lastSelected = bubble
                UIView.animateWithDuration(Controls.SwitchTabsAnimationTime, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.0, options: .CurveEaseIn, animations: {
                    bubble.transform = CGAffineTransformIdentity
                    self.containerView?.transform = CGAffineTransformIdentity
                    self.containerView?.alpha = 1.0
                    }, completion: { action in
                        self.toggleBubblesEnabled(true) //re-enable bubbles once animation is complete
                        self.startWaveAnimation() //restart wave animation - stopped to keep everything in sync
                })
        })
    }
    
    private func flyInNavigationBubbles() {
        self.profilePicture.isSelected(true)
        self.lastSelected = profilePicture
        
        //All bubbles will take the same time to animate into position -> bubble 4 will animate in right after bubble 1 finishes, bubble 3 will animate in right after bubble 2 finishes
        //Bubbles 1 and 4
        UIView.animateWithDuration(Constants.BubbleFlyOutTime, delay: 1.75, usingSpringWithDamping: Constants.BubbleAnimationSpringDamping, initialSpringVelocity: 0.0, options: .CurveEaseOut, animations: {
            self.professionalBubble.alpha = 1.0
            self.professionalBubble.transform = CGAffineTransformIdentity
            
            }, completion: { action in
                UIView.animateWithDuration(Constants.BubbleFlyOutTime, delay: 0.0, usingSpringWithDamping: Constants.BubbleAnimationSpringDamping, initialSpringVelocity: 0.0, options: .CurveEaseOut, animations: {
                    self.projectsBubble.alpha = 1.0
                    self.projectsBubble.transform = CGAffineTransformIdentity
                    }, completion: nil)
        })
        
        //Bubbles 2 and 3
        UIView.animateWithDuration(Constants.BubbleFlyOutTime, delay: 1.75 + (Constants.BubbleFlyOutTime/2), usingSpringWithDamping: Constants.BubbleAnimationSpringDamping, initialSpringVelocity: 0.0, options: .CurveEaseOut, animations: {
            self.lifestyleBubble.alpha = 1.0
            self.lifestyleBubble.transform = CGAffineTransformIdentity
            
            }, completion: { action in
                UIView.animateWithDuration(Constants.BubbleFlyOutTime, delay: 0.0, usingSpringWithDamping: Constants.BubbleAnimationSpringDamping, initialSpringVelocity: 0.0, options: .CurveEaseOut, animations: {
                    self.educationBubble.alpha = 1.0
                    self.educationBubble.transform = CGAffineTransformIdentity
                    }, completion: { action in
                        self.startWaveAnimation()
                })
        })
    }
    
    
    //MARK: Wave Animation of Navigation Bubbles
    private func startWaveAnimation() {
        pulseBubbleCounter = 1
        self.pulsingTimer = NSTimer.scheduledTimerWithTimeInterval(Controls.PulsingWaveTime, target: self, selector: #selector(ViewController.pulseNextBubbleInWave), userInfo: nil, repeats: true)
    }
    
    private func stopWaveAnimation() {
        //invalidate and set all timers controlling the bubble pulses equal to nil -> animation will stop
        bubble1PulsingTimer?.invalidate()
        bubble2PulsingTimer?.invalidate()
        bubble3PulsingTimer?.invalidate()
        bubble4PulsingTimer?.invalidate()
        bubble5PulsingTimer?.invalidate()
        
        bubble1PulsingTimer = nil
        bubble2PulsingTimer = nil
        bubble3PulsingTimer = nil
        bubble4PulsingTimer = nil
        bubble5PulsingTimer = nil
    }
    
    internal func pulseNextBubbleInWave() {
        switch pulseBubbleCounter {
        case 1:
            self.bubble1PulsingTimer = NSTimer.scheduledTimerWithTimeInterval(Constants.TimeForCompletePulse, target: self, selector: #selector(ViewController.pulseProfessionalButton), userInfo: nil, repeats: true)
        case 2:
            self.bubble2PulsingTimer = NSTimer.scheduledTimerWithTimeInterval(Constants.TimeForCompletePulse, target: self, selector: #selector(ViewController.pulseProjectsBubble), userInfo: nil, repeats: true)
        case 3:
            self.bubble3PulsingTimer = NSTimer.scheduledTimerWithTimeInterval(Constants.TimeForCompletePulse, target: self, selector: #selector(ViewController.pulseProfileButton), userInfo: nil, repeats: true)
        case 4:
            self.bubble4PulsingTimer = NSTimer.scheduledTimerWithTimeInterval(Constants.TimeForCompletePulse, target: self, selector: #selector(ViewController.pulseEducationBubble), userInfo: nil, repeats: true)
        case 5:
            self.bubble5PulsingTimer = NSTimer.scheduledTimerWithTimeInterval(Constants.TimeForCompletePulse, target: self, selector: #selector(ViewController.pulseLifestyleButton), userInfo: nil, repeats: true)
        default: if let timer = pulsingTimer { timer.invalidate(); pulsingTimer = nil}
        }
        pulseBubbleCounter += 1
    }
    
    internal func pulseProfessionalButton() {
        self.professionalBubble.pulseGently(percent: Constants.NavigationBubblesPulsePercent)
    }
    internal func pulseProjectsBubble() {
        self.projectsBubble.pulseGently(percent: Constants.NavigationBubblesPulsePercent)
    }
    internal func pulseProfileButton() {
        self.profilePicture.pulseGently(percent: Constants.NavigationBubblesPulsePercent)
    }
    internal func pulseEducationBubble() {
        self.educationBubble.pulseGently(percent: Constants.NavigationBubblesPulsePercent)
    }
    internal func pulseLifestyleButton() {
        self.lifestyleBubble.pulseGently(percent: Constants.NavigationBubblesPulsePercent)
    }
    
    private func deselectAllBubbles() {
        professionalBubble.isSelected(false)
        projectsBubble.isSelected(false)
        profilePicture.isSelected(false)
        educationBubble.isSelected(false)
        lifestyleBubble.isSelected(false)
    }
    
    private func toggleBubblesEnabled(enabled: Bool) {
        if enabled {
            professionalBubble.userInteractionEnabled = true
            profilePicture.userInteractionEnabled = true
            projectsBubble.userInteractionEnabled = true
            educationBubble.userInteractionEnabled = true
            lifestyleBubble.userInteractionEnabled = true
        } else {
            professionalBubble.userInteractionEnabled = false
            profilePicture.userInteractionEnabled = false
            projectsBubble.userInteractionEnabled = false
            educationBubble.userInteractionEnabled = false
            lifestyleBubble.userInteractionEnabled = false
        }
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.EmbedSegue:
                if let vc = segue.destinationViewController as? UITabBarController {
                    myTabBarController = vc
                }
            default: break
            }
        }
    }
}


