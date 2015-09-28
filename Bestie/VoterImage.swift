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
    
    private var voterImage: Image!
    var delegate: VoterImageDelegate!
    
    init(frame: CGRect, voterImage: Image) {
        super.init(frame: frame)
        
        self.voterImage = voterImage
        
        self.voterImage.getImage { (image) -> Void in
            self.image = image
        }
        
        self.backgroundColor = Colors.voterImageBackground
        self.layer.cornerRadius = Globals.voterImageRadius
        self.layer.borderWidth = Globals.voterImageBorder
        self.layer.borderColor = Colors.voterImageBorder.CGColor
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeZero
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        self.clipsToBounds = true
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = false
        self.contentMode = .ScaleAspectFill
        
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
