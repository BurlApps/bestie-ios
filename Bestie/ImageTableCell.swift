//
//  ImageTableCell.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/25/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class ImageTableCell: UITableViewCell {
    
    @IBOutlet weak var imageViewer: UIImageView!
    @IBOutlet weak var separator: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    func setup() {
        self.layer.masksToBounds = true
        self.layoutMargins = UIEdgeInsetsZero
    }
    
    func loadImage(voterImage: Image) {
        self.imageViewer.clipsToBounds = true
        self.imageViewer.contentMode = .ScaleAspectFill
        self.imageViewer.image = UIImage(named: "Placeholder")
        self.imageViewer.tintColor = Colors.batchPlaceholderIcon
        self.imageViewer.backgroundColor = Colors.batchPlaceholder
        self.separator.backgroundColor = Colors.voterImageBorder
        
        
        voterImage.getImage { (image) -> Void in
            self.imageViewer.image = image
            self.imageViewer.backgroundColor = Colors.batchImageCellBackground
        }
    }
}
