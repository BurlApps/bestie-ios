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
    private var lastState: Int!
    
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
        backgroundView.alpha = Globals.onboardAlpha
        self.view.insertSubview(backgroundView, atIndex: 0)
        
        self.reloadController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.newView.frame = self.view.bounds
        self.progressView.frame = self.view.bounds
        self.resultsView.frame = self.view.bounds
        
        self.newBatchController.view.frame = self.view.bounds
        self.progressController.view.frame = self.view.bounds
        self.resultsController.view.frame = self.view.bounds
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
            self.progressController.stopTimer()
            self.progressController.stopBirdTimer()
        }
        
        if self.lastState == nil || self.lastState != state {            
            self.newView.hidden = state != 0
            self.progressView.hidden = state != 1
            self.resultsView.hidden = state != 2
            self.lastState = state
        }
    }
}
