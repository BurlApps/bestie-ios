//
//  ImageTableCell.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/25/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class ImageTableCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView?.frame = CGRectMake(0, 0, self.imageView!.frame.size.width, self.imageView!.frame.size.height);
    }
    
    func setup() {
        self.layer.masksToBounds = true
        self.imageView?.clipsToBounds = true
        self.imageView?.contentMode = .ScaleAspectFit
        self.backgroundColor = Colors.batchImageCellBackground
        self.layoutMargins = UIEdgeInsetsZero
    }
}
