//
//  ResultsController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/25/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class BridgeController: UIViewController {
    @IBOutlet weak var newBatchController: UIView!
    @IBOutlet weak var progressController: UIView!
    @IBOutlet weak var resultsController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultsController.hidden = true
        self.progressController.hidden = false
        self.newBatchController.hidden = true
    }
}
