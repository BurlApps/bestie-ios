//
//  ImageCollectionCell.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/25/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

protocol ImageCollectionCellDelegate {
    func removeTapped(cell: ImageCollectionCell)
}

class ImageCollectionCell: UICollectionViewCell {
    
    var delegate: ImageCollectionCellDelegate!
    var voterImage: Image!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var removeIcon: UIButton!
    
    func setup(voterImage: Image) {
        self.voterImage = voterImage
        
        self.layer.masksToBounds = false
        
        self.imageView.layer.cornerRadius = Globals.batchCellRadius
        self.imageView.backgroundColor = Colors.batchImageCellBackground
        self.imageView.layer.borderWidth = Globals.batchImageCellBorder
        self.imageView.layer.borderColor = Colors.batchImageCellBorder.CGColor
        self.imageView.layer.masksToBounds = true
        self.imageView?.clipsToBounds = true
        self.imageView?.contentMode = .ScaleAspectFill
        self.imageView?.image = voterImage.image
        
        self.removeIcon.backgroundColor = Colors.batchImageCellRemove
        self.removeIcon.layer.cornerRadius = 15
        self.removeIcon.layer.borderWidth = 3
        self.removeIcon.layer.borderColor = Colors.batchImageCellRemoveBorder.CGColor
        self.removeIcon.layer.masksToBounds = true
        self.removeIcon.tintColor = Colors.red
        self.removeIcon.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
    }
    
    @IBAction func tapped(sender: UIButton) {
        self.delegate.removeTapped(self)
    }

}
