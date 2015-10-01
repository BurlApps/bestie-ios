//
//  InterestOnboardController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/30/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class InterestOnboardController: OnboardPageController, VoterImageSetDelegate {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var setContainer: UIView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let male = Image()
        let female = Image()
        let set = VoterSet()
        
        set.fake = true
        
        male.gender = "male"
        male.image = UIImage(named: "Male")
        set.image1 = male
        
        female.gender = "female"
        female.image = UIImage(named: "Female")
        set.image2 = female
        
        let voterSet = VoterImageSet(frame: self.setContainer.bounds, set: set)
        
        voterSet.delegate = self
        voterSet.alpha = 1
        voterSet.flyOff = false
        voterSet.downloadImages()
        
        self.setContainer.backgroundColor = UIColor.clearColor()
        self.setContainer.addSubview(voterSet)
        self.headerLabel.textColor = Colors.batchNumbers
    }
    
    func setFinished(set: VoterImageSet, image: Image) {
        self.onboardController.user.changeInterest(image.gender)
        self.onboardController.nextController()
    }
    
    func setDownloaded(set: VoterImageSet) {
        
    }

}
