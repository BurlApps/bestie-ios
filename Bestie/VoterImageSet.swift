//
//  VoterImageSet.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/24/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

protocol VoterImageSetDelegate {
    func setDownloaded(set: VoterImageSet)
    func setFinished(set: VoterImageSet, image: Image)
    func setFailed(set: VoterImageSet)
}

class VoterImageSet: UIView, VoterImageDelegate {
    
    var delegate: VoterImageSetDelegate!
    var voterImages: [VoterImage] = []
    var voterSet: VoterSet!
    var next: VoterImageSet!
    var flyOff: Bool = true

    init(frame: CGRect, set: VoterSet) {
        super.init(frame: frame)
        
        self.voterSet = set
        self.backgroundColor = UIColor.clearColor()
        self.createVoterImage(true, voterImage: set.image1)
        self.createVoterImage(false, voterImage: set.image2!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createVoterImage(top: Bool, voterImage: Image) {
        let veritcal = Globals.voterSetVerticalPadding
        let middle = Globals.voterSetMiddlePadding
        let box = self.frame.height/2 - veritcal - middle/2
        let frame = CGRectMake((self.frame.width - box)/2, veritcal, box, box)
        let card = VoterImage(frame: frame, voterImage: voterImage, transparent: self.voterSet.fake)
        
        card.delegate = self
        card.frame.origin.y = top ? frame.origin.y : frame.height + veritcal + middle
        
        self.voterImages.append(card)
        self.addSubview(card)
    }
    
    func imageSelected(image: VoterImage) {
        let first: Bool = (self.voterImages.first?.loaded)!
        let second: Bool = (self.voterImages.last?.loaded)!
        
        if first && second {
            if self.flyOff {
                for voterImage in self.voterImages {
                    voterImage.showPercent()
                }
                
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64((Globals.voterSetInterval * 3) * Double(NSEC_PER_SEC)))
                
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    UIView.animateWithDuration(Globals.voterSetInterval, animations: {
                        self.frame.origin.y = -1 * self.frame.height
                    })
                    
                    self.delegate.setFinished(self, image: image.voterImage)
                }
            } else {
                self.delegate.setFinished(self, image: image.voterImage)
            }
            
            self.voterSet.voted(image.voterImage)
        }
    }
    
    func animateInToView() {
        self.downloadImages()
        
        UIView.animateWithDuration(Globals.voterSetInterval, animations: {
            self.frame.origin.y = 0
        }, completion: nil)
    }
    
    func imageFailed(image: VoterImage) {
        self.delegate.setFailed(self)
    }
    
    func imageFlagged(image: VoterImage) {
        UIView.animateWithDuration(Globals.voterSetInterval, animations: {
            self.frame.origin.y = -1 * self.frame.height
        })
        
        self.delegate.setFinished(self, image: image.voterImage)
        image.voterImage.flag()
    }
    
    func imageDownloaded(image: VoterImage) {
        let first: Bool = (self.voterImages.first?.loaded)!
        let second: Bool = (self.voterImages.last?.loaded)!
        
        if first && second {
            self.delegate.setDownloaded(self)
        }
    }
    
    func downloadImages() {
        for voterImage in self.voterImages {
            if !voterImage.loaded {
                voterImage.downloadImage()
            }
        }
    }
}
