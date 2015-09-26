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
        
        self.imageView?.image = UIImage(named: "Temp")
        self.imageView?.clipsToBounds = true
        self.imageView?.contentMode = .ScaleAspectFill
        self.backgroundColor = Colors.batchImageCellBackground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView?.frame = CGRectMake(0, 0, self.imageView!.frame.size.width, self.imageView!.frame.size.height);
    }
}
