//
//  Model.swift
//  Bliss Chapman
//
//  Created by Bliss Chapman on 4/17/15.
//  Copyright (c) 2015 Bliss Chapman. All rights reserved.
//


import Foundation
import UIKit
import QuartzCore

public struct Controls {
    static let SwitchTabsAnimationTime = 1.5
    static let PulsingWaveTime: NSTimeInterval = 0.15
}

public struct ProjectPageTemplate {
    var Icon: UIImage!
    var Description: String!
    var Title: String!
    var ThemeColor: UIColor!
    var MoreInfoButtonTitle: String!
    
    init (title: String, icon: UIImage, description: String, color: UIColor, moreInfoButtonTitle: String) {
        Icon = icon
        Description = description
        Title = title
        ThemeColor = color
        MoreInfoButtonTitle = moreInfoButtonTitle
    }
}

public struct EducationPageTemplate {
    var PrimaryImage: UIImage!
    var BodyText: String!
    var Title: String!
    var ThemeColor: UIColor!
    
    init (title: String, primaryImage: UIImage, bodyText: String, color: UIColor) {
        PrimaryImage = primaryImage
        BodyText = bodyText
        Title = title
        ThemeColor = color
    }
}

//MARK: Model
class Model {
    init(){}
    
    private struct Constants {
        static let RGBConversion: CGFloat = 255
    }
    
    //MARK: Professional Page
    //Agrible
    let agribleDescription = "At Agrible Inc., I work with a team of backend developers and professional designers to create applications that serve the farming community and enrich Agrible's ecosystem of products."
    let agribleImage = UIImage(named: "Agrible Icon")
    
    //Mobile Dev Day
    let mobileDevDayDescription = "This January, I had the privilege of speaking at Mobile Development Day in Champaign, IL about the role of mobile apps and trends in user interface design.  Mobile Development Day is a daylong conference that highlights work done in the community and promotes a serious discussion about the direction of the mobile platform.  At this year's conference there were over 200 attendees and 30 speakers."
    let mobileDevDayImage = UIImage(named: "Mobile Development Day Icon")
    
    //CocoaNuts
    let cocoaNutsDescription = "CocoaNuts is a vibrant community of iOS developers in the Champaign-Urbana area that includes student and professional developers from a broad range of backgrounds.  As a member of the leadership team, I coordinate with other leaders and help to develop weekly demonstrations that introduce the fundamental concepts of object oriented programming, the iOS development environment, and the Swift language."
    let cocoaNutsImage = UIImage(named: "CocoaNuts Logo")
    
    //MARK: Projects Page
    var ProjectPages: [ProjectPageTemplate] = [
        ProjectPageTemplate(title: "Pocket Rain Gauge", icon: UIImage(named: "Pocket Rain Gauge Icon")!, description: "Pocket Rain Gauge interfaces with a custom designed REST API and the power of Morning Farm Report to deliver accurate rainfall measurements to the palm of your hand.  Take Pocket Rain Gauge with you in your field or garden and find out how much it's rained in the last 24-hours right at your location.  You can think of it as a universal rain gauge, with you wherever and whenever you need it.  It's the perfect app for farmers, home gardeners, event planners, hikers, golfers, or just plain ole’ weather geeks!", color: UIColor(red: 211/Constants.RGBConversion, green: 62/Constants.RGBConversion, blue: 42/Constants.RGBConversion, alpha: 0.9), moreInfoButtonTitle: "View on App Store"),
        
        ProjectPageTemplate(title: "Cloud Inventory", icon: UIImage(named: "Cloud Inventory Icon")!, description: "Cloud Inventory is currently a private project that uses the camera to create a powerful organizational tool revolving around QR codes.  This app is targeted at small businesses and uses Core Data, Cloud Kit, Air Print, advanced image processing, and barcode recognition to create an inventory system accessed by scanning, generating, and printing QR codes unique to each item.  Cloud Inventory has uses ranging from 'remind me to bring' luggage tags and scavenger hunts, to wine cellars and home libraries.", color: UIColor(red: 108/Constants.RGBConversion, green: 192/Constants.RGBConversion, blue: 229/Constants.RGBConversion, alpha: 1.0), moreInfoButtonTitle: "View on Github"),
        
        ProjectPageTemplate(title: "CocoaNuts Demos", icon: UIImage(named: "CocoanutsIcon")!, description: "Below are demo slides I created as part of the leadership team of the CocoaNuts University of Illinois student organization.  In these demos, we guide members through the steps of creating mini applications designed to demonstrate aspects of the new language Swift and powerful iOS technologies.", color: UIColor(red: 128/Constants.RGBConversion, green: 102/Constants.RGBConversion, blue: 65/Constants.RGBConversion, alpha: 1.0), moreInfoButtonTitle: "View More Content"),
    ]
    
    //MARK: Profile Page
    let aboutMeText = "Hi!  I’m Bliss Chapman, a 16 year old iOS developer from Mahomet, Illinois.  I was first exposed to the iOS development ecosystem was when I was 13 yrs old at a meeting of a local student group on the University of Illinois campus called CocoaNuts.  Today, I am a member of the leadership team of CocoaNuts and my experience with the group has come full circle.  By far my favorite part of programming is working to solve problems with and being a part of a larger community.  Being able to create something for a device you use every day is an incredibly empowering experience and working with fellow student and professional developers makes it infinitely more exciting."
    
    //MARK: Education Page
    var EducationPages: [EducationPageTemplate] = [
        EducationPageTemplate(title: "Parkland", primaryImage: UIImage(named: "Parkland Logo")!, bodyText: "General Chemistry, College Trigonometry, Introduction to Cultural Anthropology, Introduction to Advertising, Introduction to Political Science, Principles of Macroeconomics.", color: UIColor(red: 27.0/Constants.RGBConversion, green: 104/Constants.RGBConversion, blue: 62/Constants.RGBConversion, alpha: 1.0)),
        
        EducationPageTemplate(title: "Independent Study", primaryImage: UIImage(named: "EducationHat")!, bodyText: "Highlights: Stanford's Developing iOS 8 Apps with Swift, Stanford's Programming Methodology (CS106a), Harvard's Justice, Yale's Introduction to Psychology, Stanford's Programming Abstractions, Yale's Game Theory, etc.", color: UIColor(red: 251/Constants.RGBConversion, green: 202/Constants.RGBConversion, blue: 61/Constants.RGBConversion, alpha: 1.0)),
        
        EducationPageTemplate(title: "Homeschooling", primaryImage: UIImage(named: "JiL Logo")!, bodyText: "Joy in Learning Homeschool Academy was founded in 2009 in order to create an academically-focused, college preparatory, and nonsectarian learning environment for homeschooling families in the Champaign-Urbana, Illinois area.  I attend JiL classes part-time.", color: UIColor(red: 108/Constants.RGBConversion, green: 192/Constants.RGBConversion, blue: 229/Constants.RGBConversion, alpha: 1.0))
    ]
    
    //MARK: Art Page
    let artTextDescription = "I have played classical viola and violin for 7 years and been a classical ballet dancer for more than a decade.  These experiences have had an immeasurable impact on who I am today.  Music and ballet are highly structured art forms and yet, somehow, they are deeply conducive to artistic expression and the creative process.  When I consider challenges in software engineering today, I can easily see how the artistic perspective translates into a powerful problem-solving approach.  Engineers operate under strict rules and yet these “restrictions” can actually enhance creativity and our problem-solving capacity.  Devoting so much time to both of these pursuits taught me to value the process, to take pleasure in working towards a goal rather than placing all value on the end result.  The details of how something is done matter, not because somebody else will ever see it, but because you know it was done right. \n\nThese lessons will continue to serve me throughout the rest of my life."
    
    //MARK: Helper Functions
    func openURL(url: String) {
        if let myURL: NSURL = NSURL(string: url) {
            UIApplication.sharedApplication().openURL(myURL)
        }
    }
}


// A navigation bubble class could also encapsulate all this behavior but I would prefer to leave it as an extension in case I want to use these functions on buttons in a future update or in other views.
extension UIButton {
    func shake() {
        var shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.1
        shakeAnimation.repeatCount = 2
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(CGPoint: CGPointMake(self.center.x - 3, self.center.y))
        shakeAnimation.toValue  = NSValue(CGPoint: CGPointMake(self.center.x + 3, self.center.y))
        self.layer.addAnimation(shakeAnimation, forKey: "position")
    }
    
    func pulseGently(#percent: CGFloat) {
        let scale = 1.0 - (percent/100)
        
        UIView.animateWithDuration(Controls.PulsingWaveTime * 4, delay: 0.0, options: .AllowUserInteraction | .CurveEaseInOut |
            .BeginFromCurrentState, animations: {
                self.transform = CGAffineTransformMakeScale(1/scale, 1/scale)
            }) { action in
                UIView.animateWithDuration(0.9, delay: 0.0, options: .AllowUserInteraction, animations: {
                    self.transform = CGAffineTransformMakeScale(scale, scale)
                    }) { action in
                        //self.pulseGently(percent: percent)
                }
        }
    }
    
    func isSelected(selected: Bool) {
        if selected {
            self.layer.borderColor = UIColor.grayColor().CGColor
            self.layer.borderWidth = 4.0
            self.alpha = 1.0
        } else {
            self.layer.borderWidth = 0.0
            self.alpha = 1.0
        }
    }
    
    func isCircular(circular: Bool) {
        if circular {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = self.frame.size.height
        }
    }
}
