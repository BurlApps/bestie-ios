//
//  OnboardImageController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/30/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class OnboardImageController: UIViewController {
    
    var imageView = UIImageView()
    var pageIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        
        self.imageView.backgroundColor = UIColor.clearColor()
        self.imageView.contentMode = .ScaleAspectFit
        
        self.view.addSubview(self.imageView)
    }
}
