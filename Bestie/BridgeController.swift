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
    private var newBatchController: NewBatchController!
    private var progressController: BatchProgressController!
    private var resultsController: ResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Globals.bridgeController = self
        
        self.newBatchController.view.hidden = false
        self.progressController.view.hidden = false
        self.resultsController.view.hidden = false
        
        self.reloadController()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier: String = segue.identifier {
            switch(identifier) {
            case "new":
                self.newBatchController = segue.destinationViewController as! NewBatchController
            
            case "progress":
                self.progressController = segue.destinationViewController as! BatchProgressController
            
            default:
                self.resultsController = segue.destinationViewController as! ResultsController
            }
        }
    }
    
    func reloadController() {
        var state = 0
        
        if self.user.batch == nil {
            state = 0
        } else if self.user.batch.active == true {
            state = 1
            self.progressController.updateBatch(self.user.batch)
        } else {
            state = 2
        }
        
        self.newBatchController.view.hidden = state != 0
        self.progressController.view.hidden = state != 1
        self.resultsController.view.hidden = state != 2
    }
}
