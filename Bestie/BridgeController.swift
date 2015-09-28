//
//  ResultsController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/25/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class BridgeController: UIViewController {
    
    private var user = User.current()
    
    @IBOutlet weak var newBatchController: UIView!
    @IBOutlet weak var progressController: UIView!
    @IBOutlet weak var resultsController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Globals.bridgeController = self
        
        self.reloadController()
    }
    
    func reloadController() {
        self.user.fetch { () -> Void in
            var state = 0
            
            if self.user.batch == nil {
                state = 0
            } else if self.user.batch.active == true {
                state = 1
            } else {
                state = 2
            }
            
            self.newBatchController.hidden = state != 0
            self.progressController.hidden = state != 1
            self.resultsController.hidden = state != 2
        }
    }
}
