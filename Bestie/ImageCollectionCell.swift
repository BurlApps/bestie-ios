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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var removeIcon: UILabel!
    
    func setup() {
        self.layer.masksToBounds = false
        
        self.imageView.layer.cornerRadius = Globals.batchCellRadius
        self.imageView.backgroundColor = Colors.batchImageCellBackground
        self.imageView.layer.borderWidth = Globals.batchImageCellBorder
        self.imageView.layer.borderColor = Colors.batchImageCellBorder.CGColor
        self.imageView.layer.masksToBounds = true
        self.imageView?.clipsToBounds = true
        self.imageView?.contentMode = .ScaleAspectFill
        self.imageView.image = UIImage(named: "Temp")
        
        self.removeIcon.backgroundColor = Colors.batchImageCellRemove
        self.removeIcon.layer.cornerRadius = 15
        self.removeIcon.layer.borderWidth = 3
        self.removeIcon.layer.borderColor = Colors.batchImageCellRemoveBorder.CGColor
        self.removeIcon.layer.masksToBounds = true
        self.removeIcon.textColor = Colors.red
        self.removeIcon.font = UIFont.boldSystemFontOfSize(16)
        self.removeIcon.userInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: "tapped:")
        self.removeIcon.addGestureRecognizer(gesture)
    }
    
    func tapped(gesture: UIGestureRecognizer) {
        self.delegate.removeTapped(self)
    }

}
