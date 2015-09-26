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
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerSeparator: UIView!
    @IBOutlet weak var votedLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "HeaderBackground")
        self.view.backgroundColor = UIColor(patternImage: image!)
        
        self.container.backgroundColor = UIColor.whiteColor()
        self.container.layer.masksToBounds = true
        self.container.layer.cornerRadius = Globals.voterImageRadius
        self.container.layer.borderWidth = Globals.voterImageBorder
        self.container.layer.borderColor = Colors.voterImageBorder.CGColor
        
        self.headerLabel.textColor = Colors.batchHeaderLabel
        self.headerSeparator.backgroundColor = Colors.batchHeaderSeparator
        
        self.headerImage.image = UIImage(named: "Temp")
        self.headerImage.backgroundColor = Colors.batchImageCellBackground
        self.headerImage.contentMode = .ScaleAspectFill
        self.headerImage.clipsToBounds = true
    }
    
}
