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
    private var user: User = User.current()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !setup {
            self.setupProgressBars()
            self.setUpLabel()
            self.setup = true
        }
        
        self.updateSets()
    }
    
    func sizeTextLabel(big: Bool) {
        if big == self.textLabelBig {
            return
        }
        
        self.textLabelBig = big
        self.textLabel.frame.size.width = big ? Globals.voterTextLabelBig : Globals.voterTextLabel
        self.textLabel.center.x = self.view.frame.width/2
    }
    
    func createVoterSet(first: Bool, set: [Image]) {
        let frame = CGRectMake(Globals.progressBarWidth, self.view.frame.height,
            self.view.frame.width - (Globals.progressBarWidth * 2), self.view.frame.height)
        
        let set = VoterImageSet(frame: frame, set: set)
        set.delegate = self
        
        if first {
            set.frame.origin.y = 0
            set.alpha = 1
        }
        
        self.voterSets.append(set)
        self.view.insertSubview(set, belowSubview: self.textLabel)
    }
    
    func updateSets() {
        self.downloading = true
        
        self.user.pullSets { (sets) -> Void in
            self.downloading = false
            
            for set in sets {
                self.createVoterSet(self.voterSets.count == 0, set: set)
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
        
        self.view.addSubview(self.progressBar1)
        self.view.addSubview(self.progressBar2)
    }
    
    func setFinished(set: VoterImageSet) {
        self.voterSets.removeFirst()
        self.voterSets.first?.animateInToView()
        
        if (arc4random_uniform(10) + 1) <= 3 {
            Globals.switchLogoFace()
        }
        
        if self.voterSets.count < 5 && !self.downloading {
            self.updateSets()
        }
        
        self.progressBar1.increment(0.02, animation: true)
        self.progressBar2.increment(0.02, animation: true)
    }
}
