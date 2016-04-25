//
//  EducationTableViewController.swift
//  Bliss Chapman
//
//  Created by Bliss Chapman on 4/24/15.
//  Copyright (c) 2015 Bliss Chapman. All rights reserved.
//

import UIKit

class EducationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private struct Constants {
        static let ReuseIdentifier = "EducationPageCell"
        static let RGBConversion: CGFloat = 255
    }
    
    private struct URLs {
        static let Parkland = "http://www.parkland.edu"
        static let iTunesU = "https://www.apple.com/education/ipad/itunes-u/"
        static let Homeschooling = "https://sites.google.com/site/joyinlearningintro/"
    }
    
    private enum Cells: Int {
        case Parkland = 0
        case IndependentStudy = 1
        case Homeschooling = 2
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private let myModel = Model()
    
    //MARK: View Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: U
    private func configureUI() {
        tableView.separatorColor = UIColor(red: 251/Constants.RGBConversion, green: 202/Constants.RGBConversion, blue: 61/Constants.RGBConversion, alpha: 1.0)
        tableView.separatorInset = UIEdgeInsetsZero
    }
    
    // MARK: Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myModel.EducationPages.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.height / 2.2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: EducationPage = tableView.dequeueReusableCellWithIdentifier(Constants.ReuseIdentifier) as! EducationPage!
        
        let page = myModel.EducationPages[indexPath.row] as EducationPageTemplate
        
        cell.title.text = page.Title
        cell.primaryImage.image = page.PrimaryImage
        cell.bodyText.text = page.BodyText
        cell.backgroundColor = page.ThemeColor
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case Cells.Parkland.rawValue: myModel.openURL(URLs.Parkland)
        case Cells.IndependentStudy.rawValue: myModel.openURL(URLs.iTunesU)
        case Cells.Homeschooling.rawValue: myModel.openURL(URLs.Homeschooling)
        default: break
        }
    }
}
