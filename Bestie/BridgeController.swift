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
    
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var newView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Globals.bridgeController = self
        
        self.newView.hidden = false
        self.progressView.hidden = false
        self.resultsView.hidden = false
        
        let backgroundView = UIView(frame: self.view.frame)
        let image = UIImage(named: "HeaderBackground")
        
        backgroundView.backgroundColor = UIColor(patternImage: image!)
        backgroundView.alpha = Globals.bridgeBackgroundAlpha
        self.view.insertSubview(backgroundView, atIndex: 0)
        
        self.reloadController()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier: String = segue.identifier {
            switch(identifier) {
            case "new":
                self.newBatchController = segue.destinationViewController as! NewBatchController
                self.newBatchController.view.backgroundColor = UIColor.clearColor()
            
            case "progress":
                self.progressController = segue.destinationViewController as! BatchProgressController
                self.progressController.view.backgroundColor = UIColor.clearColor()
            
            default:
                self.resultsController = segue.destinationViewController as! ResultsController
                self.resultsController.view.backgroundColor = UIColor.clearColor()
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
            self.resultsController.updateBatch(self.user.batch)
        }
        
        self.newView.hidden = state != 0
        self.progressView.hidden = state != 1
        self.resultsView.hidden = state != 2
    }
}
