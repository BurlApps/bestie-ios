//
//  ResultsController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/25/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class ResultsController: UITableViewController {
    
    private let reuseIdentifier = "cell"
    private var headerContainer: ImageTableHeaderCell!
    private var images: [UIImage?] = [
        UIImage(named: "Temp"),
        UIImage(named: "Temp"),
        UIImage(named: "Temp")
    ]
    
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.images[indexPath.row]!.size.height
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
        
        UIGraphicsBeginImageContext(bounds.size)
        
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
        
        UIGraphicsBeginImageContext(frame.size)
        
        view.drawViewHierarchyInRect(frame, afterScreenUpdates: true)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return snapshot
    }
}
