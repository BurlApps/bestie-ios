//
//  VoterImageView.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/24/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

protocol VoterImageDelegate {
    func imageSelected(image: VoterImage)
}

class VoterImage: UIImageView {
    
    var delegate: VoterImageDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.image = UIImage(named: "Temp")
        
        self.backgroundColor = Colors.voterImageBackground
        self.layer.cornerRadius = Globals.voterImageRadius
        self.layer.borderWidth = Globals.voterImageBorder
        self.layer.borderColor = Colors.voterImageBorder.CGColor
        self.layer.masksToBounds = true
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapped:")
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapped(gesture: UIGestureRecognizer) {
        self.scaleUp(false, completion: {
            self.delegate.imageSelected(self)
        })
    }
    
    func scaleUp(hold: Bool, completion: (() -> Void)!) {
        UIView.animateWithDuration(Globals.voterImageInterval, animations: {
            self.transform = CGAffineTransformMakeScale(Globals.voterImagePop, Globals.voterImagePop);
        }, completion: { (finished: Bool) -> Void in
            if finished && !hold {
                completion()
                self.scaleDown()
            }
        })
    }
    
    func scaleDown() {
        UIView.animateWithDuration(Globals.voterImageInterval, animations: {
            self.transform = CGAffineTransformMakeScale(1, 1);
        }, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.scaleUp(true, completion: nil)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.scaleDown()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.scaleDown()
    }
}
