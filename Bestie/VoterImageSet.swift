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
}

class VoterImageSet: UIView, VoterImageDelegate {
    
    var delegate: VoterImageSetDelegate!
    var voterImages: [VoterImage] = []
    var voterSet: VoterSet!
    var next: VoterImageSet!

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
        let card = VoterImage(frame: frame, voterImage: voterImage)
        
        card.delegate = self
        card.frame.origin.y = top ? frame.origin.y : frame.height + veritcal + middle
        
        self.voterImages.append(card)
        self.addSubview(card)
    }
    
    func imageSelected(image: VoterImage) {
        let first = self.voterImages.first?.hidden == false
        let second = self.voterImages.last?.hidden == false
        
        if first && second {
            UIView.animateWithDuration(Globals.voterSetInterval, animations: {
                self.frame.origin.y = -1 * self.frame.height
            }) { (finished: Bool) -> Void in
                self.hidden = true
                self.frame.origin.y = self.frame.height
            }
            
            self.delegate.setFinished(self, image: image.voterImage)
        }
        
        self.voterSet.voted(image.voterImage)
    }
    
    func animateInToView() {
        self.hidden = false
        
        UIView.animateWithDuration(Globals.voterSetInterval, animations: {
            self.frame.origin.y = 0
        }, completion: nil)
    }
    
    func imageDownloaded(image: VoterImage) {
        let first = self.voterImages.first?.image != nil
        let second = self.voterImages.last?.image != nil
        
        if first && second {
            self.delegate.setDownloaded(self)
        }
    }
    
    func downloadImages() {
        for voterImage in self.voterImages {
            voterImage.downloadImage()
        }
    }
}
