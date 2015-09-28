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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = UIView(frame: self.view.frame)
        let image = UIImage(named: "HeaderBackground")
        
        backgroundView.backgroundColor = UIColor(patternImage: image!)
        backgroundView.alpha = Globals.shareCardBackgroundAlpha
        self.view.insertSubview(backgroundView, atIndex: 0)
        
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
        
        self.headerImage.image = UIImage(named: "Temp")
        self.headerImage.backgroundColor = Colors.batchImageCellBackground
        self.headerImage.contentMode = .ScaleAspectFill
        self.headerImage.clipsToBounds = true
    }
    
    func degreesToRadians (value:Double) -> CGFloat {
        return CGFloat(value * M_PI / 180.0)
    }
}
