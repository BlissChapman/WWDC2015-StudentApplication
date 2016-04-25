//
//  InformationCollectionViewController.swift
//  Bliss Chapman
//
//  Created by Bliss Chapman on 4/17/15.
//  Copyright (c) 2015 Bliss Chapman. All rights reserved.
//

import UIKit
import StoreKit
import SystemConfiguration

class PortfolioCollectionViewController: UICollectionViewController, SKStoreProductViewControllerDelegate {

    private struct URLs {
        static let CloudInventoryGithub = "https://github.com/Togira/QRCloudInventory"
        static let PocketRainGaugeAppStore = "https://itunes.apple.com/us/app/pocket-rain-gauge-precision/id958702490?mt=8&uo=6&at=&ct="
        static let ResolutionKeeper = "https://docs.google.com/viewer?a=v&pid=sites&srcid=ZGVmYXVsdGRvbWFpbnxjb2NvYW51dHNpb3N8Z3g6MWRiNjZhMmJiMmZmZTIxNw"
        static let WhosYourValentine = "Whos Your Valentine? - CocoaNuts Demo"
        static let CocoanutsWebsite = "https://sites.google.com/site/cocoanutsios/"
        static let PunxsutawneyPhil = "https://github.com/iluvcompsci/GreenDetector"
    }
    private struct Constants {
        static let ReuseIdentifier = "Cell"
        static let NibName = "ProjectsPage"
        static let MoreInfoButtonPulse: CGFloat = 3.5
    }

    private var cell: ProjectsPage?
    private var currentIndexPath: NSIndexPath?
    private var myModel = Model()
    private var cocoanutsCounter = 1


    //MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.hidden = true
        configureCollectionView()
    }

    //MARK: User Interface
    private func configureCollectionView() {
        //invalidate current layout before setting up new
        self.collectionView?.collectionViewLayout.invalidateLayout()

        // Configure horizontal layout
        let horizontalLayout = UICollectionViewFlowLayout()
        horizontalLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        horizontalLayout.minimumInteritemSpacing = 0.0
        horizontalLayout.minimumLineSpacing = 0.0
        horizontalLayout.itemSize = CGSize(width: view.frame.width, height: self.view.frame.height)
        horizontalLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.collectionView?.setCollectionViewLayout(horizontalLayout, animated: true)

        // Register custom cell nib with collection view
        self.collectionView?.registerNib(UINib(nibName: Constants.NibName, bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: Constants.ReuseIdentifier)
    }

    internal func pulseMoreInformationButton() {
        if let currentCell = cell {
            currentCell.moreInformationButton.pulseGently(percent: Constants.MoreInfoButtonPulse)
        }
    }

    // MARK: UICollectionView
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int { return 1 }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myModel.ProjectPages.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.ReuseIdentifier, forIndexPath: indexPath) as? ProjectsPage

        // Configure the cell
        let page = myModel.ProjectPages[indexPath.item] as ProjectPageTemplate

        //if its the last cell, make sure the arrow indicator to move to the next page is hidden
        currentIndexPath = indexPath
        if indexPath.item >= (self.collectionView!.numberOfItemsInSection(indexPath.section) - 1) {
            cell!.arrowIndicator.hidden = true
        } else {
            cell!.arrowIndicator.hidden = false
            cell!.arrowIndicator.addTarget(self, action: #selector(PortfolioCollectionViewController.arrowTapped), forControlEvents: .TouchUpInside)
            cell!.arrowIndicator.backgroundColor = page.ThemeColor
            cell!.arrowIndicator.layer.masksToBounds = true
            cell!.arrowIndicator.layer.cornerRadius = cell!.arrowIndicator.frame.height / 3.0 //3.0 is an arbitrary value
        }

        //default setup -> will change dependent on view but should always be reset
        cell?.screenshotOne.hidden = false
        cell?.screenshotTwo.hidden = false
        cell?.screenshotThree.hidden = false
        cell?.pdfView.hidden = true

        //remove all previous targets from more information button before adding the new one
        cell?.moreInformationButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)

        switch page.Title {
        case "Pocket Rain Gauge":
            let delayInSeconds = Controls.SwitchTabsAnimationTime/2
            let changeStaticImageToGifTime = dispatch_time(DISPATCH_TIME_NOW, (Int64(delayInSeconds) * Int64(NSEC_PER_SEC)))
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)

            if let url = NSBundle.mainBundle().URLForResource("RainGaugeView", withExtension: "gif") {
                if NSData(contentsOfURL: url) != nil {

                    //no gif here because collection view cells will start to trigger memory warnings and I can't handle the deallocation of the cells
                    cell!.screenshotTwo.image = UIImage(named: "RainGaugeView")
                }
            }
            if let url = NSBundle.mainBundle().URLForResource("SliderView", withExtension: "gif") {
                if let imageData = NSData(contentsOfURL: url) {

                    cell!.screenshotOne.image = UIImage(named: "SliderViewFirstScreen")

                    var gif: UIImage?
                    dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                        gif = UIImage.animatedImageWithData(imageData)
                        dispatch_async(dispatch_get_main_queue(), {
                            dispatch_after(changeStaticImageToGifTime, dispatch_get_main_queue(), {
                                self.cell?.screenshotOne.image = UIImage.animatedImageWithData(imageData)
                            })
                        })
                    })
                }
            }
            cell!.screenshotThree.image = UIImage(named: "PRGThankYou")
            cell!.moreInformationButton.addTarget(self, action: #selector(PortfolioCollectionViewController.openPRGInAppStore), forControlEvents: UIControlEvents.TouchUpInside)
        case "Cloud Inventory":
            cell!.moreInformationButton.addTarget(self, action: #selector(PortfolioCollectionViewController.viewCloudInventoryOnGithub), forControlEvents: .TouchUpInside)
            cell!.screenshotOne.image = UIImage(named: "Cloud Inventory Screenshot 3")
            cell!.screenshotTwo.image = UIImage(named: "Cloud Inventory Screenshot 2")
            cell!.screenshotThree.image = UIImage(named: "Cloud Inventory Screenshot 1")
        case "CocoaNuts Demos":
            cell!.moreInformationButton.addTarget(self, action: #selector(PortfolioCollectionViewController.viewMoreContent), forControlEvents: .TouchUpInside)
            cell?.screenshotOne.hidden = true
            cell?.screenshotTwo.hidden = true
            cell?.screenshotThree.hidden = true
            cell?.pdfView.hidden = false

            //display pdf in subview!
            loadURL(URLs.WhosYourValentine)
        default: break
        }

        //load the rest of the cell information that is not dependent on which cell we are currently creating
        cell!.titleOfPage.text = page.Title
        cell!.moreInformationButton.setTitle(page.MoreInfoButtonTitle, forState: .Normal)
        cell!.moreInformationButton.backgroundColor = page.ThemeColor
        cell!.icon.image = page.Icon
        cell!.descriptionLabel.text = page.Description

        //pulse more information 3 seconds after user starts reading a page
        _ = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(PortfolioCollectionViewController.pulseMoreInformationButton), userInfo: nil, repeats: false)

        return cell!

    }

    //MARK: Collection View Cell Helpers
    func arrowTapped() {
        if let currentIndex = currentIndexPath {
            if currentIndex.item < (self.collectionView!.numberOfItemsInSection(currentIndex.section) - 1) {
                let nextIndexPath = NSIndexPath(forItem: currentIndex.item + 1, inSection: currentIndex.section)
                self.collectionView?.scrollToItemAtIndexPath(nextIndexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
            }
        }
    }

    func openPRGInAppStore() {
        let appID: NSNumber = 958702490
        let storeKitViewController = SKStoreProductViewController()
        storeKitViewController.delegate = self
        self.cell!.moreInformationButton.setTitle("Loading...", forState: UIControlState.Normal)
        storeKitViewController.loadProductWithParameters([SKStoreProductParameterITunesItemIdentifier: appID], completionBlock: {
            (completed, error) -> Void in
            if completed {
                self.presentViewController(storeKitViewController, animated: true, completion: { action in
                })
            } else {
                //just open link in store...
                if let PRGURL: NSURL = NSURL(string: URLs.PocketRainGaugeAppStore) {
                    UIApplication.sharedApplication().openURL(PRGURL)
                }
            }
            self.cell?.moreInformationButton.setTitle("View on App Store", forState: UIControlState.Normal)
        })
    }

    //delegate function for handling when the product view controller was canceled/dismissed
    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //opens cloud inventory on github
    func viewCloudInventoryOnGithub() {
        if let CloudInventoryGithubURL: NSURL = NSURL(string: URLs.CloudInventoryGithub) {
            UIApplication.sharedApplication().openURL(CloudInventoryGithubURL)
        }
    }

    //the first url I load is cached on device but the others are fetched from the internet to save local storage space -> this will continuously rotate through all the different examples
    func viewMoreContent() {
        self.cell?.moreInformationButton.setTitle("Loading...", forState: .Normal)

        switch cocoanutsCounter {
        case 1: loadURL(URLs.ResolutionKeeper)
        case 2: loadURL(URLs.PunxsutawneyPhil)
        case 3: loadURL(URLs.ResolutionKeeper)
        default: loadURL(URLs.WhosYourValentine)
        }
        cocoanutsCounter += 1
    }

    //a generic function to load a web link or pdf in the webview
    private func loadURL(url: String) {
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        var request: NSURLRequest?

        let internetStatus = Reachability.reachabilityForInternetConnection().currentReachabilityStatus()

        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in

            //determine what type of url we are loading
            if let webURL = NSURL(string: url) {

                //if there isn't an internet connection, pop an alert or else load the url requested
                if internetStatus.rawValue == 0 {
                    let noInternetAlert = UIAlertController(title: "No Internet Connection.", message: "Please connect to a wifi or cellular network.", preferredStyle: .Alert)
                    noInternetAlert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: { action in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    noInternetAlert.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { action in
                        if let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.sharedApplication().openURL(settingsURL)
                        }
                    }))
                    self.presentViewController(noInternetAlert, animated: true, completion: nil)
                } else {
                    request = NSURLRequest(URL: webURL)
                }

            } else if let path: String = NSBundle.mainBundle().pathForResource(url, ofType: "pdf") {
                let url = NSURL(fileURLWithPath: path)
                request = NSURLRequest(URL: url)
            }

            dispatch_async(dispatch_get_main_queue(), {
                //if a request has been created, then load it up
                if let createdRequest = request {
                    self.cell?.pdfView.loadRequest(createdRequest)

                    // the loading sign typically is removed before the view actually loads up because it takes a few seconds to display the data.  So, once it has finsihed fetching, I will delay reverting the button title an extra 4 seconds -> should be enough time so as not to be confusing that loading has stopped but nothing has happened.
                    let delayInSeconds = 4.0
                    let changeTitleNow = dispatch_time(DISPATCH_TIME_NOW, (Int64(delayInSeconds) * Int64(NSEC_PER_SEC)))
                    dispatch_after(changeTitleNow, dispatch_get_main_queue(), {
                        self.cell?.moreInformationButton.setTitle("View More Content", forState: .Normal)
                    })
                }
            })
        })
    }
}
