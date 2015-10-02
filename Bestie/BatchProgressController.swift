//
//  BatchProgressController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/25/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit
import KDCircularProgress

class BatchProgressController: UIViewController {

    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var votingButton: UIButton!
    @IBOutlet weak var circleChart: KDCircularProgress!
    @IBOutlet weak var progressLabel: UILabel!
    
    private var setup: Bool = false
    private var user: User! = User.current()
    //private var cirlceChart: PNCircleChart!
    private var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.votingButton.tintColor = UIColor.whiteColor()
        self.votingButton.backgroundColor = Colors.batchSubmitButton
        self.votingButton.layer.cornerRadius = Globals.batchSubmitButtonRadius
        self.votingButton.layer.masksToBounds = true
        
        self.informationLabel.textColor = Colors.batchInstructions
        self.progressLabel.textColor = Colors.batchProgressBar
        
        self.circleChart.startAngle = -90
        self.circleChart.glowMode = .NoGlow
        self.circleChart.trackColor = UIColor.clearColor()
        self.circleChart.setColors(Colors.batchProgressBar)
        
        self.view.addSubview(self.circleChart)
    }
    
    @IBAction func votingButtonTapped(sender: AnyObject) {
        Globals.slideToVotingScreen()
    }
    
    func startTimer() {
        self.stopTimer()
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self,
            selector: Selector("updateUser"), userInfo: nil, repeats: false)
    }
    
    func stopTimer() {
        if self.timer != nil {
            self.timer.invalidate()
        }
    }
    
    func updateUser() {
        if self.user.batch != nil {
            self.user.batch.fetch(nil)
        }
    }
    
    func updateBatch(batch: Batch) {
        if self.circleChart != nil {
            self.progressLabel.text = "\(Int(batch.percent() * 100))%"
            self.circleChart.animateToAngle(Int(batch.percent() * 360), duration: 0.5, completion: nil)
        }
    }
}
