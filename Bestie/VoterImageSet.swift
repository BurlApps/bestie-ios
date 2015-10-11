//
//  VoterImageSet.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/24/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

protocol VoterImageSetDelegate {
    func setOffScreen(set: VoterImageSet)
    func setFinished(set: VoterImageSet, image: Image)
}

class VoterImageSet: UIView, VoterImageDelegate {
    
    var delegate: VoterImageSetDelegate!
    var voterImages: [VoterImage] = []
    var voterSet: VoterSet!
    var flyOff: Bool = true
    var tutorial: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.createVoterImage(true)
        self.createVoterImage(false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSet(voterSet: VoterSet) {
        self.voterSet = voterSet
        self.voterImages.first?.updateImage(voterSet.image1)
        self.voterImages.last?.updateImage(voterSet.image2)
    }
    
    func showTutorial() {
        self.tutorial = true
        self.voterImages.first?.showTutorial()
        self.voterImages.last?.showTutorial()
    }

    func createVoterImage(top: Bool) {
        let veritcal = Globals.voterSetVerticalPadding
        let middle = Globals.voterSetMiddlePadding
        let box = self.frame.height/2 - veritcal - middle/2
        let frame = CGRectMake((self.frame.width - box)/2, veritcal, box, box)
        let card = VoterImage(frame: frame)
        
        card.delegate = self
        card.frame.origin.y = top ? frame.origin.y : frame.height + veritcal + middle
        
        self.voterImages.append(card)
        self.addSubview(card)
    }
    
    func imageSelected(image: VoterImage) {
        if self.flyOff {
            self.voterImages.first?.showPercent()
            self.voterImages.last?.showPercent()
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64((Globals.voterSetInterval * 3) * Double(NSEC_PER_SEC)))
            
            dispatch_after(delayTime, dispatch_get_main_queue()) {                
                UIView.animateWithDuration(Globals.voterSetInterval, animations: { () -> Void in
                    self.frame.origin.y = -1 * self.frame.height
                }, completion: { (success: Bool) -> Void in
                    self.delegate.setOffScreen(self)
                })
                
                self.delegate.setFinished(self, image: image.voterImage)
            }
        } else {
            self.delegate.setFinished(self, image: image.voterImage)
        }
        
        if self.tutorial {
            StateTracker.votingTutorial(true)
        }
        
        self.voterSet.voted(image.voterImage)
    }
    
    func resetPosition() {
        self.frame.origin.y = self.frame.height
    }
    
    func animateInToView() {
        UIView.animateWithDuration(Globals.voterSetInterval, animations: {
            self.frame.origin.y = 0
        }, completion: nil)
    }
    
    func imageFlagged(image: VoterImage) {
        UIView.animateWithDuration(Globals.voterSetInterval, animations: { () -> Void in
            self.frame.origin.y = -1 * self.frame.height
        }, completion: { (success: Bool) -> Void in
            self.delegate.setOffScreen(self)
        })
        
        self.delegate.setFinished(self, image: image.voterImage)
        image.voterImage.flag()
    }
}
