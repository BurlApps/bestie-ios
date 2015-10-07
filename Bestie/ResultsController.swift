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
    private var images: [Image] = []
    private var firstImage: Image!
    private var config: Config!
    private var user: User!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startOverButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = User.current()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clearColor()
        
        self.saveButton.tintColor = UIColor.whiteColor()
        self.saveButton.backgroundColor = Colors.batchSubmitButton
        self.saveButton.layer.cornerRadius = Globals.batchSubmitButtonRadius
        self.saveButton.layer.masksToBounds = true
        self.saveButton.setTitle(Strings.batchResultsSaveButton, forState: .Normal)
        
        self.startOverButton.tintColor = UIColor.whiteColor()
        self.startOverButton.backgroundColor = Colors.batchSubmitAlternateButton
        self.startOverButton.layer.cornerRadius = Globals.batchSubmitButtonRadius
        self.startOverButton.layer.masksToBounds = true
        self.startOverButton.setTitle(Strings.batchResultsNewButton, forState: .Normal)
        
        self.view.layer.masksToBounds = true
        
        Config.sharedInstance { (config) -> Void in
            self.config = config
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let percent = Globals.resultsFirstPhotoPercentHeight
        self.tableView.tableHeaderView!.frame.size.height = self.view.frame.height * percent
        self.tableView.tableHeaderView = self.tableView.tableHeaderView
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "headerContainer" {
            self.headerContainer = segue.destinationViewController as! ImageTableHeaderCell
        }
    }
    
    @IBAction func savePressed(sender: AnyObject) {
        let text = self.saveButton.titleLabel?.text
        
        self.saveButton.setTitle("saving...", forState: .Normal)
        
        self.firstImage.getImage { (image) -> Void in
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            
            self.saveButton.setTitle(text, forState: .Normal)
            self.user.mixpanel.track("Mobile.User.Save")
            
            NavNotification.show(Strings.batchResultsAlertMessage)
        }
    }
    
    @IBAction func startOverPressed(sender: AnyObject) {
        User.current().resetBatch()
    }
    
    func updateBatch(batch: Batch) {
        self.images.removeAll()
        self.tableView.reloadData()
        self.headerContainer.resetBatch()
        
        self.user.mixpanel.track("Mobile.Batch.Results")
        
        batch.getImages { (images) -> Void in            
            if !images.isEmpty {
                self.firstImage = images.first
                self.headerContainer.updateBatch(images.first)
            }
            
            if images.count > 1 {
                self.images = Array(images[1..<images.count])
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height/1.2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: ImageTableCell! = tableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier) as? ImageTableCell
        let image = self.images[indexPath.row]
        
        if cell == nil {
            cell = ImageTableCell()
        }
        
        cell.setup()
        cell.loadImage(image)
        
        return cell
    }
    
    // NOT IN USE
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
