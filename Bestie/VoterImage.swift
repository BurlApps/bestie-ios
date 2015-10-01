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
    func imageDownloaded(image: VoterImage)
    func imageFlagged(image: VoterImage)
}

class VoterImage: UIImageView {
    
    var voterImage: Image!
    var delegate: VoterImageDelegate!
    var transparent: Bool = false
    
    init(frame: CGRect, voterImage: Image, transparent: Bool) {
        super.init(frame: frame)
        
        self.voterImage = voterImage
        self.transparent = transparent
        
        if !self.transparent {
            self.backgroundColor = Colors.voterImageBackground
            self.layer.cornerRadius = Globals.voterImageRadius
            self.layer.borderWidth = Globals.voterImageBorder
            self.layer.borderColor = Colors.voterImageBorder.CGColor
            self.layer.shadowColor = UIColor.blackColor().CGColor
            self.layer.shadowOffset = CGSizeZero
            self.layer.shadowOpacity = 0.5
        }

        self.layer.shadowRadius = 5
        self.clipsToBounds = true
        self.hidden = true
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = false
        self.contentMode = .ScaleAspectFill
        
        let flag = UIImage(named: "Flag")
        let flagView = UIImageView(image: flag)
        let width: CGFloat = 25
        let height: CGFloat = 25
        
        flagView.contentMode = .ScaleAspectFit
        flagView.tintColor = UIColor(white: 1, alpha: 0.5)
        flagView.frame = CGRectMake(6, frame.height - width - 10, width, height)
        flagView.userInteractionEnabled = true
        flagView.hidden = transparent
        self.addSubview(flagView)
        
        let flagTapGesture = UITapGestureRecognizer(target: self, action: "flag:")
        flagView.addGestureRecognizer(flagTapGesture)
        
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
    
    func flag(gesture: UIGestureRecognizer) {
        let controller = UIAlertController(title: "Flag Photo",
            message: "Please confirm this photo is spam or inappropriate.", preferredStyle: .Alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let confirm = UIAlertAction(title: "Confirm", style: .Destructive) { (action: UIAlertAction) -> Void in
            self.delegate.imageFlagged(self)
        }
        
        controller.addAction(cancel)
        controller.addAction(confirm)
        Globals.pageController.presentViewController(controller, animated: true, completion: nil)
    }
    
    func downloadImage() {
        self.voterImage.getImage { (image) -> Void in
            self.image = image
            self.hidden = false
            self.delegate.imageDownloaded(self)
        }
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
