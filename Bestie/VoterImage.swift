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
    var loaded: Bool = false
    
    private var percentLabel: UILabel!
    
    init(frame: CGRect, voterImage: Image, transparent: Bool) {
        super.init(frame: frame)
        
        self.voterImage = voterImage
        self.transparent = transparent
        
        if !self.transparent {
            self.image = UIImage(named: "Placeholder")
            self.tintColor = Colors.batchPlaceholderIcon
            self.backgroundColor = Colors.batchPlaceholder
            self.layer.cornerRadius = Globals.voterImageRadius
            self.layer.borderWidth = Globals.voterImageBorder
            self.layer.borderColor = Colors.voterImageBorder.CGColor
            self.layer.shadowColor = UIColor.blackColor().CGColor
            self.layer.shadowOffset = CGSizeZero
            self.layer.shadowOpacity = 0.5
            
            self.percentLabel = UILabel(frame: CGRectMake(0, 0, frame.width, frame.height))
            self.percentLabel.backgroundColor = UIColor(red:0.07, green:0.58, blue:0.96, alpha:0.5)
            self.percentLabel.textColor = UIColor.whiteColor()
            self.percentLabel.textAlignment = .Center
            self.percentLabel.text = "\(Int(voterImage.percent() * 100))%"
            self.percentLabel.layer.shadowColor = UIColor(white: 0, alpha: 0.7).CGColor
            self.percentLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
            self.percentLabel.layer.shadowOpacity = 1
            self.percentLabel.font = UIFont(name: "Bariol-Bold", size: 36)
            self.percentLabel.alpha = 0
            
            self.addSubview(self.percentLabel)
            
            let flag = UIImage(named: "Flag")
            let flagView = UIImageView(image: flag)
            let width: CGFloat = 25
            let height: CGFloat = 25
            
            flagView.contentMode = .ScaleAspectFit
            flagView.tintColor = UIColor(white: 1, alpha: 0.5)
            flagView.frame = CGRectMake(6, frame.height - width - 10, width, height)
            flagView.userInteractionEnabled = true
            self.addSubview(flagView)
            
            let flagTapGesture = UITapGestureRecognizer(target: self, action: "flag:")
            flagView.addGestureRecognizer(flagTapGesture)
        }

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
    
    func showPercent() {
        UIView.animateWithDuration(Globals.voterSetInterval, animations: {
            self.percentLabel?.alpha = 1
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
            self.loaded = true
            
            if !self.transparent {
                self.backgroundColor = Colors.voterImageBackground
            }
            
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
