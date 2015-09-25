//
//  PlusCollectionCell.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/25/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

protocol PlusCollectionCellDelegate {
    func newImageTapped()
}

class PlusCollectionCell: UICollectionViewCell {

    var delegate: PlusCollectionCellDelegate!
    private var border: CAShapeLayer!
    @IBOutlet weak var plusLabel: UILabel!
    
    func setup() {
        self.layer.cornerRadius = Globals.batchCellRadius
        self.layer.masksToBounds = true
        self.backgroundColor = Colors.batchPlusCellBackground
        self.userInteractionEnabled = true
        
        self.border = CAShapeLayer()
        self.border.strokeColor = Colors.batchPlusCellBorder.CGColor
        self.border.fillColor = nil
        self.border.lineWidth = Globals.batchPlusCellBorder
        self.border.lineDashPattern = [4, 2]
        self.layer.addSublayer(border)
        
        self.plusLabel.textColor = Colors.batchPlusCellIcon
        self.plusLabel.font = UIFont.boldSystemFontOfSize(70)
        
        let gesture = UITapGestureRecognizer(target: self, action: "tapped:")
        self.addGestureRecognizer(gesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: Globals.batchCellRadius).CGPath
        self.border.frame = self.bounds
    }
    
    func tapped(gesture: UIGestureRecognizer) {
        self.delegate.newImageTapped()
    }
}
