//
//  VoterImageSet.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/24/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

protocol VoterImageSetDelegate {
    func setFinished(set: VoterImageSet)
}

class VoterImageSet: UIView, VoterImageDelegate {
    
    var delegate: VoterImageSetDelegate!
    var voterImages: [VoterImage] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.alpha = 0
        
        self.createVoterImage(true)
        self.createVoterImage(false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createVoterImage(top: Bool) {
        let veritcal = Globals.voterSetVerticalPadding
        let middle = Globals.voterSetMiddlePadding
        let box = self.frame.height/2 - veritcal - middle/2
        let frame = CGRectMake((self.frame.width - box)/2, veritcal, box, box)
        let image = VoterImage(frame: frame)
        
        image.delegate = self
        image.frame.origin.y = top ? frame.origin.y : frame.height + veritcal + middle
        
        self.voterImages.append(image)
        self.addSubview(image)
    }
    
    func imageSelected(image: VoterImage) {
        UIView.animateWithDuration(Globals.voterSetInterval, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
            self.frame.origin.y = -1 * self.frame.height
            self.alpha = 0.5
        }) { (finished: Bool) -> Void in
            self.hidden = true
            self.frame.origin.y = self.frame.height
        }
        
        self.delegate.setFinished(self)
    }
    
    func animateInToView() {
        self.hidden = false
        
        UIView.animateWithDuration(Globals.voterSetInterval, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
            self.frame.origin.y = 0
            self.alpha = 1
        }, completion: nil)
    }
}
