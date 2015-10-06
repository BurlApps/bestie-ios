//
//  VoteController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/24/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class VoteController: UIViewController, VoterImageSetDelegate {

    private var tutorialShown = false
    private var downloading = false
    private var progressBar1: VerticalProgressBar!
    private var progressBar2: VerticalProgressBar!
    private var sets: [VoterSet] = []
    private var voterSets: [VoterImageSet] = []
    private var textLabel: UILabel!
    private var user: User! = User.current()
    private var timer: NSTimer!
    private var spinner: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Globals.voterController = self
        
        self.tutorialShown = StateTracker.hadVotingTutorial()
        
        self.setupProgressBars()
        self.setUpLabel()
        self.setupSpinner()
        self.updateSets()
        
        let image = UIImage(named: "HeaderBackground")
        
        self.backgroundView.backgroundColor = UIColor(patternImage: image!)
        self.backgroundView.alpha = Globals.onboardAlpha
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.textLabel.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        self.spinner.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
    }
    
    func setupSpinner() {
        self.spinner = UIImageView(image: UIImage(named: "Sticker"))
        self.spinner.frame = CGRectMake(0, 0, Globals.spinner, Globals.spinner)
        self.spinner.contentMode = .ScaleAspectFit
        self.spinner.hidden = false
        self.view.insertSubview(self.spinner, aboveSubview: self.textLabel)
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = NSNumber(double: M_PI)
        animation.duration = Globals.spinnerDuration
        animation.cumulative = true
        animation.repeatCount = Float.infinity
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        
        self.spinner.layer.addAnimation(animation, forKey: "rotation")
    }
    
    func createVoterSet(first: Bool) {
        let frame = CGRectMake(Globals.progressBarWidth, self.view.frame.height,
            self.view.frame.width - (Globals.progressBarWidth * 2), self.view.frame.height)
        
        let voterSet = VoterImageSet(frame: frame)
        voterSet.delegate = self
        
        if first {
            voterSet.frame.origin.y = 0
        }
        
        if !self.tutorialShown {
            self.tutorialShown = true
            voterSet.showTutorial()
        }
        
        voterSet.updateSet(self.sets[0])
        self.sets.removeFirst()
        
        self.voterSets.append(voterSet)
        self.view.insertSubview(voterSet, belowSubview: self.textLabel)
    }
    
    func flushSets() {
        self.downloading = false
        self.sets.removeAll()
        
        for set in self.voterSets {
            set.removeFromSuperview()
        }
        
        self.voterSets.removeAll()
        self.updateSets()
    }
    
    func updateSets() {
        if !self.downloading {
            self.downloading = true
            self.spinner.hidden = !self.voterSets.isEmpty
            
            if self.timer != nil {
                self.timer.invalidate()
                self.timer = nil
            }
            
            self.user.pullSets { (sets) -> Void in
                self.downloading = false
                
                if sets.isEmpty {
                    NSTimer.scheduledTimerWithTimeInterval(5, target: self,
                        selector: Selector("updateSets"), userInfo: nil, repeats: false)
                } else {
                    self.spinner.hidden = true
                    
                    for set in sets {
                        set.image1.getImage(nil)
                        set.image2.getImage(nil)
                        
                        self.sets.append(set)
                    }
                    
                    if self.voterSets.count == 0 {
                       self.createVoterSet(true)
                    }
                    
                    if self.voterSets.count == 1 {
                        self.createVoterSet(false)
                    }
                }
            }
        }
    }
    
    func setUpLabel() {
        self.textLabel = UILabel()
        self.textLabel.frame = CGRectMake(0, 0, Globals.voterTextLabel, Globals.voterTextLabel)
        self.textLabel.text = Strings.votingBubble
        self.textLabel.font = UIFont(name: "Bariol-Bold", size: 18)
        self.textLabel.layer.cornerRadius = Globals.voterTextLabel/2
        self.textLabel.layer.masksToBounds = true
        self.textLabel.clipsToBounds = true
        self.textLabel.backgroundColor = UIColor.whiteColor()
        self.textLabel.textColor = Colors.voterTextLabel
        self.textLabel.textAlignment = .Center
        self.textLabel.autoresizingMask = .FlexibleWidth
        self.view.addSubview(self.textLabel)
    }
    
    func setupProgressBars() {
        let width = Globals.progressBarWidth
        let frame1 = CGRectMake(0, 0, width, self.view.frame.height)
        let frame2 = CGRectMake(self.view.frame.width - width, 0, width, self.view.frame.height)
        
        self.progressBar1 = VerticalProgressBar(frame: frame1)
        self.progressBar2 = VerticalProgressBar(frame: frame2)
        self.progressBarUpdate()
        
        self.view.addSubview(self.progressBar1)
        self.view.addSubview(self.progressBar2)
    }
    

    func progressBarUpdate() {
        var percent: Float = 0
        
        if self.progressBar1 == nil {
            return
        }
        
        if self.user.batch != nil && self.user.batch!.active == true {
            let tmp = self.user.batch!.userPercent()
            percent = tmp
            
            if tmp >= 1 {
                percent = 0
            }
        }
        
        self.progressBar1.progress(percent, animation: true)
        self.progressBar2.progress(percent, animation: true)
    }
    
    func showVoteAlert() {
        let controller = UIAlertController(title: Strings.votingAlertTitle, message: Strings.votingAlertMessage, preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: Strings.votingAlertCancel, style: .Cancel, handler: nil))
        Globals.pageController.presentViewController(controller, animated: true, completion: nil)
    }
    
    func setOffScreen(set: VoterImageSet) {
        self.voterSets.removeFirst()
        self.spinner.hidden = !self.voterSets.isEmpty
        
        if self.sets.isEmpty {
            set.removeFromSuperview()
            set.voterSet = nil
            set.voterImages.removeAll()
        
        } else {
            set.resetPosition()
            set.updateSet(self.sets[0])
            
            self.sets.removeFirst()
            self.voterSets.append(set)
        }
    }
    
    func setFinished(set: VoterImageSet, image: Image) {
        self.user.mixpanel.track("Mobile.Set.Voted")
        
        if (arc4random_uniform(10) + 1) <= 3 {
            Globals.switchLogoFace()
        }
        
        if self.voterSets.count > 1 {
            self.voterSets[1].animateInToView()
        }
        
        if self.sets.count < 5 {
            self.updateSets()
        }
    }
}
