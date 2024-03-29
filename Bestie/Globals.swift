//
//  Globals.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/24/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class Globals {
    
    static var pageController: PageController!
    static var bridgeController: BridgeController!
    static var progressController: BatchProgressController!
    static var voterController: VoteController!
    static var logoImage: NavigationBarItem!
    
    static let progressBarWidth: CGFloat = 7
    
    static let spinner: CGFloat = 100
    static let spinnerDuration: Double = 0.6

    static let onboardAlpha: CGFloat = 0.05
    static let onboardChange: NSTimeInterval = 3
    
    static let voterTextLabel: CGFloat = 50
    static let voterTextLabelBig: CGFloat = 150
    static let voterTextLabelInterval: NSTimeInterval = 0.5
    static let votingBarTutorial: Double = 5
    
    static let voterSetVerticalPadding: CGFloat = 6
    static let voterSetMiddlePadding: CGFloat = 5
    static let voterSetInterval: NSTimeInterval = 0.2
    
    static let voterImageBorder: CGFloat = 1
    static let voterImageRadius: CGFloat = 8
    static let voterImagePop: CGFloat = 1.1
    static let voterImageInterval: NSTimeInterval = 0.1

    static let batchCellRadius: CGFloat = 5
    static let batchPlusCellBorder: CGFloat = 2
    static let batchImageCellBorder: CGFloat = 1
    
    static let resultsFirstPhotoPercentHeight: CGFloat = 0.85
    
    static let shareCardSize: CGFloat = 600
    static let shareCardContainerHeight: CGFloat = 560
    static let shareCardBackgroundAlpha: CGFloat = 0.2
    static let bridgeBackgroundAlpha: CGFloat = 0.08
    
    static let infoDictionary = NSBundle.mainBundle().infoDictionary!
    
    class func batchSubmitButtonRadius(width: CGFloat) -> CGFloat {        
        return 23 - ((220 - width)/60)
    }
    
    class func switchLogoFace() {
        self.logoImage.switchFace()
    }
    
    class func reloadBridgeController() {
        if self.bridgeController != nil {
            self.bridgeController.reloadController()
        }
    }
    
    class func showVoterAlert() {
        NavNotification.show(Strings.votingAlertMessage, duration: 8) { () -> Void in
            Globals.slideToBatchScreen()
        }
    }
    
    class func showBatchAlert() {
        NavNotification.show(Strings.batchResultsReady, duration: 3) { () -> Void in
            Globals.slideToBatchScreen()
        }
    }
    
    class func showVoterBarsTutorial() {
        if self.voterController != nil {
            self.voterController.showBarsTutorial()
        }
    }
    
    class func slideToVotingScreen() {
        if self.pageController != nil {
            self.pageController.pageController.setCurrentPage(1, animated: true)
        }
    }
    
    class func slideToBatchScreen() {
        if self.pageController != nil {
            self.pageController.pageController.setCurrentPage(2, animated: true)
        }
    }
    
    class func showOnboarding() {
        if self.voterController != nil {
            self.voterController.stopTimer()
        }
        
        if self.progressController != nil {
            self.progressController.stopTimer()
            self.progressController.stopBirdTimer()
        }
    
        if self.pageController != nil {
            self.pageController.navigationController?.popToRootViewControllerAnimated(false)
        }
    }
    
    class func reloadUser() {
        if let user = User.current() {
            user.fetch({ () -> Void in
                if user.batch != nil {
                    user.batch.fetch({ () -> Void in
                        self.reloadBridgeController()
                    })
                }
            })
        }
    }
    
    class func reloadBatch() {
        if let user = User.current() {
            if user.batch != nil {
                user.batch.fetch({ () -> Void in
                    self.reloadBridgeController()
                })
            }
        }
    }
    
    class func progressBarsUpdate() {
        if self.voterController != nil {
            self.voterController.progressBarUpdate()
        }
    }
    
    class func batchUpdated() {
        self.progressBarsUpdate()
        self.reloadBridgeController()
    }
    
    class func parseCredentials() -> [String] {
        let parseApplicationID = self.infoDictionary["ParseApplicationID"] as! String
        let parseClientKey = self.infoDictionary["ParseClientKey"] as! String
        
        return [parseApplicationID, parseClientKey]
    }
    
    class func mixpanelToken() -> String {
        return self.infoDictionary["MixpanelToken"] as! String
    }
    
    class func appBuildVersion() -> String {
        let version = self.infoDictionary["CFBundleShortVersionString"] as! NSString
        let build = self.infoDictionary[String(kCFBundleVersionKey)] as! NSString
        
        return "\(version) - \(build)"
    }
    
    class func appVersion() -> String {
        return self.infoDictionary["CFBundleShortVersionString"] as! String
    }
    
}
