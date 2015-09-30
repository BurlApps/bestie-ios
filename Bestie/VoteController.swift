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
    private var setup: Bool = false
    private var textLabelBig = false
    private var progressBar1: VerticalProgressBar!
    private var progressBar2: VerticalProgressBar!
    private var voterSets: [VoterImageSet] = []
    private var textLabel: UILabel!
    private var user: User! = User.current()
    private var timer: NSTimer!
    private var spinner: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Globals.voterController = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !setup {
            self.setupProgressBars()
            self.setUpLabel()
            self.setupSpinner()
            self.setup = true
            
            let backgroundView = UIView(frame: self.view.frame)
            let image = UIImage(named: "HeaderBackground")
            
            backgroundView.backgroundColor = UIColor(patternImage: image!)
            backgroundView.alpha = Globals.bridgeBackgroundAlpha
            self.view.addSubview(backgroundView)
        }
        
        self.updateSets()
    }
    
    func setupSpinner() {
        self.spinner = UIImageView(image: UIImage(named: "Sticker"))
        self.spinner.frame = CGRectMake(0, 0, Globals.spinner, Globals.spinner)
        self.spinner.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
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
            voterSet.alpha = 1
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
                    self.spinner.hidden = false
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
        self.textLabel.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        self.textLabel.text = "VS"
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
            percent = self.user.batch!.userPercent()
            percent = percent >= 1 ? 0 : percent
        }
        
        self.progressBar1.progress(percent, animation: true)
        self.progressBar2.progress(percent, animation: true)
    }
    
    func setFinished(set: VoterImageSet, image: Image) {
        self.voterSets.removeFirst()
        self.voterSets.first?.animateInToView()
        
        if (arc4random_uniform(10) + 1) <= 3 {
            Globals.switchLogoFace()
        }
        
        if self.voterSets.count < 5 {
            self.updateSets()
        }
        
        if self.user.batch != nil {
            self.user.batch!.userVoted()
            self.progressBarUpdate()
        }
    }
}
