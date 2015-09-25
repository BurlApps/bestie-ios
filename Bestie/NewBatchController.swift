//
//  NewBatchController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/25/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class NewBatchController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, PlusCollectionCellDelegate, ImageCollectionCellDelegate {
    
    private let reuseIdentifier = "cell"
    private let firstReuseIdentifier = "firstCell"
    private let uploadedImages: NSMutableArray = NSMutableArray()
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 25.0, bottom: 20.0, right: 25.0)
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var informationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView?.backgroundColor = UIColor.clearColor()
        
        self.submitButton.tintColor = UIColor.whiteColor()
        self.submitButton.backgroundColor = Colors.batchSubmitButton
        self.submitButton.layer.cornerRadius = Globals.batchSubmitButtonRadius
        self.submitButton.layer.masksToBounds = true
        
        self.informationLabel.textColor = Colors.batchInfomation
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let ready = self.uploadedImages.count >= 2
        
        self.submitButton.hidden = !ready
        self.informationLabel.hidden = ready
        
        return self.uploadedImages.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = indexPath.row == 0 ? self.firstReuseIdentifier : self.reuseIdentifier
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        
        if indexPath.row == 0 {
            let temp = cell as! PlusCollectionCell
            
            temp.delegate = self
            temp.setup()
        } else {
            let temp = cell as! ImageCollectionCell
            
            temp.delegate = self
            temp.setup()
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
        print(123)
    }
    
    func removeTapped(cell: ImageCollectionCell) {
        print(cell)
    }
    
    @IBAction func submitBatch(sender: AnyObject) {
    
    }
}
