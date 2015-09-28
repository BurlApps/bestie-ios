//
//  ResultsController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/25/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class ResultsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let reuseIdentifier = "cell"
    private var headerContainer: ImageTableHeaderCell!
    private var images: [UIImage?] = [
        UIImage(named: "Temp"),
        UIImage(named: "Temp"),
        UIImage(named: "Temp")
    ]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startOverButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.shareButton.tintColor = UIColor.whiteColor()
        self.shareButton.backgroundColor = Colors.batchSubmitButton
        self.shareButton.layer.cornerRadius = Globals.batchSubmitButtonRadius
        self.shareButton.layer.masksToBounds = true
        
        self.startOverButton.tintColor = UIColor.whiteColor()
        self.startOverButton.backgroundColor = Colors.batchSubmitAlternateButton
        self.startOverButton.layer.cornerRadius = Globals.batchSubmitButtonRadius
        self.startOverButton.layer.masksToBounds = true
        
        self.view.layer.masksToBounds = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let percent = Globals.resultsFirstPhotoPercentHeight
        self.tableView.tableHeaderView!.frame.size.height = self.view.frame.height * percent
        self.tableView.tableHeaderView = self.tableView.tableHeaderView
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "headerContainer" {
            self.headerContainer = segue.destinationViewController as! ImageTableHeaderCell
        }
    }
    
    @IBAction func sharePressed(sender: AnyObject) {
        let share = ShareGenerator(sender: sender as! UIView, controller: Globals.pageController)
        
        share.share(self.createShareCard())
    }
    
    @IBAction func startOverPressed(sender: AnyObject) {
        print("start over")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.images[indexPath.row]!.size.height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: ImageTableCell! = tableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier) as? ImageTableCell
        let image = self.images[indexPath.row]
        
        if cell == nil {
            cell = ImageTableCell()
        }
        
        cell.imageView?.image = image
        
        return cell
    }
    
    func captureContainer() -> UIImage {
        let bounds = self.headerContainer.container.bounds
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        
        self.headerContainer.container.drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return snapshot
    }
    
    func createShareCard() -> UIImage {
        let frame = CGRectMake(0, 0, Globals.shareCardSize, Globals.shareCardSize)
        let view = UIView(frame: frame)
        let background = UIImage(named: "HeaderBackground")
        let image = self.captureContainer()
        let imageView = UIImageView(image: image)
        let backgroundView = UIView(frame: frame)
        let cardHeight = Globals.shareCardContainerHeight
        let cardWidth = (cardHeight/image.size.height) * image.size.width
        
        imageView.backgroundColor = UIColor.clearColor()
        imageView.contentMode = .ScaleAspectFit
        imageView.frame = CGRectMake(frame.width/2 - cardWidth/2, frame.height/2 - cardHeight/2,
            cardWidth, cardHeight)
        
        backgroundView.backgroundColor = UIColor(patternImage: background!)
        backgroundView.alpha = Globals.shareCardBackgroundAlpha
        
        view.addSubview(backgroundView)
        view.addSubview(imageView)
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        
        view.drawViewHierarchyInRect(frame, afterScreenUpdates: true)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return snapshot
    }
}
