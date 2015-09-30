//
//  ImageTableHeaderCell.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/25/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class ImageTableHeaderCell: UIViewController {
   
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var votedLabel: UILabel!
    @IBOutlet weak var bestieLabel: UILabel!
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var innerContainer: UIView!
    @IBOutlet weak var sticker: UIImageView!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var dataContainer: UIView!
    @IBOutlet weak var infoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        
        self.separator.backgroundColor = Colors.voterImageBorder
        
        self.votedLabel.textColor = Colors.batchNumbers
        self.bestieLabel.textColor = Colors.batchBestie
        self.infoText.textColor = Colors.batchInfomation
        self.sticker.transform = CGAffineTransformMakeRotation(self.degreesToRadians(-15))
        
        self.container.clipsToBounds = false
        self.container.layer.masksToBounds = false
        self.container.backgroundColor = UIColor.clearColor()
        
        self.innerContainer.backgroundColor = UIColor.whiteColor()
        self.innerContainer.layer.masksToBounds = true
        self.innerContainer.layer.cornerRadius = Globals.voterImageRadius
        self.innerContainer.layer.borderWidth = Globals.voterImageBorder
        self.innerContainer.layer.borderColor = Colors.voterImageBorder.CGColor
        
        self.headerImage.backgroundColor = Colors.batchImageCellBackground
        self.headerImage.contentMode = .ScaleAspectFill
        self.headerImage.clipsToBounds = true
        
        self.infoImage.tintColor = Colors.gray
        
        self.bottomConstraint.constant = self.dataContainer.frame.height * -1
        self.view.layoutIfNeeded()
        
        let gesture = UITapGestureRecognizer(target: self, action: "tapped:")
        self.bestieLabel.addGestureRecognizer(gesture)
        self.bestieLabel.userInteractionEnabled = true
    }
    
    func tapped(gesture: UIGestureRecognizer) {
        if self.bottomConstraint.constant < 0 {
            self.bottomConstraint.constant = 0
        } else {
            self.bottomConstraint.constant = self.dataContainer.frame.height * -1
        }
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func degreesToRadians (value:Double) -> CGFloat {
        return CGFloat(value * M_PI / 180.0)
    }
    
    func resetBatch() {
        self.votedLabel.text = "---"
        self.headerImage.image = nil
    }
    
    func updateBatch(image: Image!) {
        self.votedLabel.text = "\(Int(image.percent() * 100))%"
        
        image.getImage { (image) -> Void in
            self.headerImage.image = image
        }
    }
}
