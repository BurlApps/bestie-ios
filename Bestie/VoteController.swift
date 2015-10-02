//
//  VoteController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/24/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class VoteController: UIViewController, VoterImageSetDelegate {

    private var downloading = false
    private var textLabelBig = false
    private var progressBar1: VerticalProgressBar!
    private var progressBar2: VerticalProgressBar!
    private var voterSets: [VoterImageSet] = []
    private var textLabel: UILabel!
    private var user: User! = User.current()
    private var timer: NSTimer!
    private var spinner: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Globals.voterController = self
        
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
        animation.duration = 0.8
        animation.cumulative = true
        animation.repeatCount = Float.infinity
        
        self.spinner.layer.addAnimation(animation, forKey: "rotation")
    }
    
    func sizeTextLabel(big: Bool) {
        if big == self.textLabelBig {
            return
        }
        
        self.textLabelBig = big
        self.textLabel.frame.size.width = big ? Globals.voterTextLabelBig : Globals.voterTextLabel
        self.textLabel.center.x = self.view.frame.width/2
    }
    
    func createVoterSet(set: VoterSet, first: Bool) {
        let frame = CGRectMake(Globals.progressBarWidth, self.view.frame.height,
            self.view.frame.width - (Globals.progressBarWidth * 2), self.view.frame.height)
        
        let voterSet = VoterImageSet(frame: frame, set: set)
        voterSet.delegate = self
        
        if self.voterSets.count == 0 {
            voterSet.frame.origin.y = 0
        }
        
        if first {
            voterSet.downloadImages()
        }
        
        self.voterSets.last?.next = voterSet
        self.voterSets.append(voterSet)
        self.view.insertSubview(voterSet, belowSubview: self.textLabel)
    }
    
    func flushSets() {
        self.downloading = false
        self.voterSets.removeAll()
        self.updateSets()
    }
    
    func updateSets() {
        if !self.downloading {
            self.downloading = true
            
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
                    
                    for (i, set) in sets.enumerate() {
                        self.createVoterSet(set, first: i == 0)
                    }
                }
            }
        }
    }
    
    func setUpLabel() {
        self.textLabel = UILabel()
        self.textLabel.frame = CGRectMake(0, 0, Globals.voterTextLabel, Globals.voterTextLabel)
        self.textLabel.text = "OR"
        self.textLabel.font = UIFont.boldSystemFontOfSize(20)
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
    
    func setDownloaded(set: VoterImageSet) {
        if let next = set.next {
            next.downloadImages()
        }
    }
    
    func progressBarUpdate() {
        var percent: Float = 0
        
        if self.user.batch != nil && self.user.batch!.active == true {
            let tmp = self.user.batch!.userPercent()
            percent = tmp
            
            if tmp >= 1 {
                percent = 0
            }
        }
        
        if self.progressBar1 != nil {
            self.progressBar1.progress(percent, animation: true)
            self.progressBar2.progress(percent, animation: true)
        }
    }
    
    func showVoteAlert() {
        let controller = UIAlertController(title: "You Are Awesome!", message: "We are almost done finding your Bestie, we will ping ou", preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "Thanks", style: .Cancel, handler: nil))
        Globals.pageController.presentViewController(controller, animated: true, completion: nil)
    }
    
    func setFinished(set: VoterImageSet, image: Image) {
        self.voterSets.removeFirst()
        self.voterSets.first?.animateInToView()
        self.user.mixpanel.track("Mobile.Set.Voted")
        
        if (arc4random_uniform(10) + 1) <= 3 {
            Globals.switchLogoFace()
        }
        
        if self.voterSets.count < 5 {
            self.updateSets()
        }
        
        if self.voterSets.isEmpty {
            self.spinner.hidden = false
        }
        
        if self.user.batch != nil {
            self.user.batch!.userVoted()
            self.progressBarUpdate()
        }
    }
}
