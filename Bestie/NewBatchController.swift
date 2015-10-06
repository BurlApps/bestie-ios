//
//  NewBatchController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/25/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit
import SVProgressHUD

class NewBatchController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, PlusCollectionCellDelegate, ImageCollectionCellDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let reuseIdentifier = "cell"
    private let firstReuseIdentifier = "firstCell"
    private let uploadedImages: NSMutableArray = NSMutableArray()
    private let sectionInsets = UIEdgeInsets(top: 25.0, left: 25.0, bottom: 25.0, right: 25.0)
    private var user: User! = User.current()
    private var config: Config!
    private var hitLimit: Bool = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var informationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Config.sharedInstance { (config) -> Void in
            self.config = config
        }
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView?.backgroundColor = UIColor.clearColor()
        
        self.submitButton.tintColor = UIColor.whiteColor()
        self.submitButton.backgroundColor = Colors.batchSubmitButton
        self.submitButton.layer.cornerRadius = Globals.batchSubmitButtonRadius
        self.submitButton.layer.masksToBounds = true
        self.submitButton.setTitle(Strings.newBatchButton, forState: .Normal)
        
        self.informationLabel.textColor = Colors.batchInfomation
        self.informationLabel.text = Strings.newBatchInformation
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionView.reloadData()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.uploadedImages.count
        let ready = count >= 2
        
        if self.config != nil {
            self.hitLimit = count >= self.config.uploadLimit
        }
            
        self.submitButton.hidden = !ready
        self.informationLabel.hidden = ready
        
        return self.uploadedImages.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let isFirst = indexPath.row == 0
        let identifier = isFirst ? self.firstReuseIdentifier : self.reuseIdentifier
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        
        if isFirst {
            let temp = cell as! PlusCollectionCell
            
            temp.delegate = self
            temp.setup()
            
        } else {
            let temp = cell as! ImageCollectionCell
            let image: Image = self.uploadedImages[indexPath.row - 1] as! Image
            
            temp.delegate = self
            temp.setup(image)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            var size = (self.collectionView?.frame.width)!/2 - self.sectionInsets.left - self.sectionInsets.right
        
            size += 10
        
            return CGSize(width: size, height: size)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 30
    }
    
    func newImageTapped() {
        if !self.hitLimit {
            let picker = UIImagePickerController()
            
            picker.delegate = self
            picker.sourceType = .PhotoLibrary
            picker.allowsEditing = true
            
            Globals.pageController.presentViewController(picker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: Strings.newBatchLimitAlertTitle,
                message: Strings.newbatchLimitAlertMessage, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: Strings.newBatchLimitAlertCancel, style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            
            Globals.pageController.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func removeTapped(cell: ImageCollectionCell) {
        cell.voterImage.remove()
        self.uploadedImages.removeObject(cell.voterImage)
        self.collectionView.reloadData()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.uploadedImages.addObject(Image.create(image, user: self.user))
        self.collectionView.reloadData()
    }
    
    @IBAction func submitBatch(sender: AnyObject) {
        SVProgressHUD.setBackgroundColor(UIColor.blackColor())
        SVProgressHUD.setForegroundColor(UIColor.whiteColor())
        SVProgressHUD.setDefaultMaskType(.Black)
        SVProgressHUD.setFont(UIFont(name: "Bariol-Bold", size: 24))
        SVProgressHUD.showWithStatus("Uploading...")
        
        var images: [Image] = []
        
        for image in self.uploadedImages {
            images.append(image as! Image)
        }
        
        Batch.create(images, user: self.user) { (batch) -> Void in
            SVProgressHUD.dismiss()
            Globals.showVoterBarsTutorial()
            Globals.slideToVotingScreen()
            Globals.batchUpdated()
            
            self.user.mixpanel.timeEvent("Mobile.Batch.Results")
            self.user.mixpanel.track("Mobile.Batch.Create", properties: [
                "images": images.count
            ])
        }
    }
}
