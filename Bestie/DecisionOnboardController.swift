//
//  DecisionOnboardController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/30/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class DecisionOnboardController: OnboardPageController, VoterImageSetDelegate {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var setContainer: UIView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let male = Image()
        let female = Image()
        let set = VoterSet()
        
        set.fake = true
        
        male.gender = "upload"
        male.image = UIImage(named: "Upload")
        set.image1 = male
        
        female.gender = "vote"
        female.image = UIImage(named: "Vote")
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
        let application = UIApplication.sharedApplication()
        
        if application.respondsToSelector(Selector("registerUserNotificationSettings:")) {
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            application.registerForRemoteNotificationTypes([.Alert, .Badge, .Sound])
        }
        
        self.onboardController.nextPage = image.gender == "vote" ? 1 : 2
        self.onboardController.nextController()
    }
    
    func setDownloaded(set: VoterImageSet) {
        
    }

}
