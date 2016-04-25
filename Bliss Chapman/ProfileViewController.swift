//
//  ProfileTableViewController.swift
//  Bliss Chapman
//
//  Created by Bliss Chapman on 4/23/15.
//  Copyright (c) 2015 Bliss Chapman. All rights reserved.
//

import UIKit
import MapKit

class ProfileViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet { mapView.delegate = self }
    }
    
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    private struct Constants {
        static let MyHouseLatitude = 40.200353
        static let MyHouseLongitude = -88.373299
        static let approximateMilesToDegrees = 0.01449275 //this depends on the actual latitude but for the purposes of this app its precise enough
        static let MilesPerMKSpanOf1 = 48.3333333333
    }
    
    private var myModel = Model()
    
    
    //MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    //MARK: User Interface
    private func updateUI() {
        self.tabBarController?.tabBar.hidden = true
        updateMap()
        bodyTextLabel.text = myModel.aboutMeText
    }
    
    private struct Buttons {
        static let Github = "Github ➤"
        static let CocoaNuts = "CocoaNuts ➤"
        static let LinkedIn = "LinkedIn ➤"
    }
    
    private struct URLs {
        static let Github = "https://github.com/Togira"
        static let CocoaNuts = "http://facebook.us7.list-manage.com/subscribe?u=996a85f390f51daa7d0288ee6&id=2f297d0947"
        static let LinkedIn = "https://www.linkedin.com/pub/bliss-chapman/b2/465/784"
    }
    
    @IBAction private func openLink(sender: UIButton) {
        if let button = sender.currentTitle {
            switch button {
            case Buttons.Github:
                myModel.openURL(URLs.Github)
            case Buttons.CocoaNuts:
                myModel.openURL(URLs.CocoaNuts)
            case Buttons.LinkedIn:
                myModel.openURL(URLs.LinkedIn)
            default: break
            }
        }
    }
    
    //MARK: MapKit
    private func updateMap() {
        let startingSpan = 0.03
        
        // We need to shift the map upwards by a certain amount so that the pin is centered in the visible region of the map (dependent on span).  This is by no means an elegant solution, but it is functional for now and works no matter what the span of the map is
        let offset = Constants.MilesPerMKSpanOf1 * startingSpan * Constants.approximateMilesToDegrees
        
        let span = MKCoordinateSpanMake(startingSpan, startingSpan)
        let coordinate2D = CLLocationCoordinate2D(latitude: Constants.MyHouseLatitude - offset, longitude: Constants.MyHouseLongitude)
        let region = MKCoordinateRegion(center: coordinate2D, span: span)
        
        mapView.setRegion(region, animated: true)
        
        let wavingAnnotation = MKPointAnnotation()
        wavingAnnotation.coordinate = CLLocationCoordinate2DMake(Constants.MyHouseLatitude, Constants.MyHouseLongitude)
        wavingAnnotation.title = "Hi!" //annotation needs a title for user interaction to be allowed
        self.mapView.addAnnotation(wavingAnnotation)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else if annotation is MKPointAnnotation {
            
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotationView.image = UIImage(named: "MapAnnotation")
            annotationView.frame = CGRectMake(0, 0, annotationView.image!.size.width/13, annotationView.image!.size.height/13) //scale so image looks resonably sized relative to the map - 13 is an arbitrary amount
            annotationView.canShowCallout = true
            
            return annotationView
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        //create popover view controller
        let content = UIViewController(nibName: "MapPopoverViewController", bundle: NSBundle.mainBundle())
        let popover = UIPopoverController(contentViewController: content)
        
        content.view.frame = CGRectMake(0, 0, 240, 140)
        popover.popoverContentSize = content.view.frame.size
        popover.presentPopoverFromRect(view.bounds, inView: view, permittedArrowDirections: [.Left, .Right], animated: true)
        
        //create image view that will hold my gif
        let imageView = UIImageView(frame: content.view.frame)
        imageView.frame.size.height = imageView.frame.size.height * 2.8/4
        imageView.frame.size.width = content.view.frame.width
        imageView.transform = CGAffineTransformMakeTranslation(0, imageView.frame.height / 2.4)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        //set the imageview's image to the first frame of my gif
        imageView.image = UIImage(named: "FamilyWavingFrame1")
        content.view.addSubview(imageView)
        
        //asynchronously load gif so that the popover can appear without having to load up the entire gif first
        var gif: UIImage?
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
            if let url = NSBundle.mainBundle().URLForResource("FamilyWaving", withExtension: "gif") {
                if let gifData = NSData(contentsOfURL: url) {
                    if let image = UIImage.animatedImageWithData(gifData) {
                        gif = image
                    }
                }
                dispatch_async(dispatch_get_main_queue(), {
                    if gif != nil {
                        imageView.image = gif
                    }
                })
            }
        })
    }
    
    //error handling if map could not load
    func mapViewDidFailLoadingMap(mapView: MKMapView, withError error: NSError) {
        // Map failed -> check internet connectivity and issue alerts depending on if that was the issue
        
        let internetStatus = Reachability.reachabilityForInternetConnection().currentReachabilityStatus()
        
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
            let unknownErrorAlert = UIAlertController(title: "Error Loading Map", message: error.description, preferredStyle: .Alert)
            unknownErrorAlert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: { action in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(unknownErrorAlert, animated: true, completion: nil)
        }
    }
}


