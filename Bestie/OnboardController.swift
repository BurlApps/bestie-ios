//
//  OnboardController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/27/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class OnboardController: UIViewController, VoterImageSetDelegate {
    
    enum State {
        case Gender, Interest
    }
    
    private var user: User!
    private var state: State = .Gender
    private var voterSets: [VoterImageSet] = []
    private var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Globals.onboardController = self
        self.setUpLabel()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
         self.user = User.current()
        
        if self.user != nil {
            self.performSegueWithIdentifier("onboardedSegue", sender: self)
        } else {
            //self.resetController()
            
            User.register("male", interested: "female", callback: { (user) -> Void in
                self.performSegueWithIdentifier("onboardedSegue", sender: self)
            })
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
    
    func resetController() {
        self.state = .Gender
    }
    
    func createGender(gender: String) -> Image {
        let image = Image()
        
        image.image = UIImage(named: gender)
        
        return image
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
    
    func setDownloaded(set: VoterImageSet) {
        
    }
    
    func setFinished(set: VoterImageSet, image: Image) {
        
    }
}
