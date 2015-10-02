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
    @IBOutlet weak var birdImage: UIImageView!
    
    private var setup: Bool = false
    private var user: User! = User.current()
    private var timer: NSTimer!
    private var birderTimer: NSTimer!
    private var birdDirectionLeft: Bool = true
    
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
        self.circleChart.hidden = true
        
        self.view.addSubview(self.circleChart)
    }
    
    @IBAction func votingButtonTapped(sender: AnyObject) {
        Globals.slideToVotingScreen()
    }
    
    func startTimer() {        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self,
            selector: Selector("updateUser"), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
    }
    
    func startBirdTimer() {
        self.birdImage.hidden = false
        
        if self.birderTimer == nil {
            self.birderTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self,
            selector: Selector("flipBird"), userInfo: nil, repeats: true)
        }
    }
    
    func stopBirdTimer() {
        self.birdImage.hidden = true
        
        if self.birderTimer != nil {
            self.birderTimer.invalidate()
            self.birderTimer = nil
        }
    }
    
    func flipBird() {
        let direction = self.birdDirectionLeft ? "Right" : "Left"
        self.birdDirectionLeft = !self.birdDirectionLeft
        
        self.birdImage.image = UIImage(named: "Face-\(direction)")
    }
    
    func updateUser() {
        if self.user.batch != nil {
            self.user.batch.fetch({ () -> Void in
                Globals.batchUpdated()
            })
        }
    }
    
    func updateBatch(batch: Batch) {
        if self.circleChart != nil {
            let percent = Int(batch.percent() * 100)
            
            if percent == 0 {
                self.startBirdTimer()
                
                self.circleChart.hidden = true
                self.progressLabel.text = "We Workin!"
            } else {
                self.stopBirdTimer()
                self.circleChart.hidden = false
                self.progressLabel.text = "\(percent)%"
                self.circleChart.animateToAngle(Int(batch.percent() * 360), duration: 0.5, completion: nil)
            }
        }
        
        if self.timer == nil {
            self.startTimer()
        }
    }
}
