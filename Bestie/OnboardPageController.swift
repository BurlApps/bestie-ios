//
//  OnboardPageController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/30/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class OnboardPageController: UIViewController {

    // MARK: Instance Variables
    var pageIndex: Int!
    var onboardController: OnboardController!
    
    // MARK: UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Background
        self.view.backgroundColor = UIColor.clearColor()
    }

}
