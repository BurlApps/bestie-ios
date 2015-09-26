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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.container.backgroundColor = UIColor.whiteColor()
        self.container.layer.masksToBounds = true
        self.container.layer.cornerRadius = Globals.voterImageRadius
        self.container.layer.borderWidth = Globals.voterImageBorder
        self.container.layer.borderColor = Colors.voterImageBorder.CGColor
    }
    
}
