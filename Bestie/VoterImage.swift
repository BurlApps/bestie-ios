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
    func imageFlagged(image: VoterImage)
}

class VoterImage: UIImageView {
    
    var voterImage: Image!
    var delegate: VoterImageDelegate!
    
    private var tutorialLabel: UILabel!
    private var percentLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        self.percentLabel.layer.shadowColor = UIColor(white: 0, alpha: 0.7).CGColor
        self.percentLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.percentLabel.layer.shadowOpacity = 1
        self.percentLabel.font = UIFont(name: "Bariol-Bold", size: 36)
        self.percentLabel.alpha = 0
        
        self.addSubview(self.percentLabel)
        
        self.tutorialLabel = UILabel(frame: CGRectMake(0, 0, frame.width, frame.height))
        self.tutorialLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
        self.tutorialLabel.textColor = UIColor.whiteColor()
        self.tutorialLabel.textAlignment = .Center
        self.tutorialLabel.layer.shadowColor = UIColor(white: 0, alpha: 0.7).CGColor
        self.tutorialLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.tutorialLabel.layer.shadowOpacity = 1
        self.tutorialLabel.font = UIFont(name: "Bariol-Bold", size: 36)
        self.tutorialLabel.alpha = 0
        self.tutorialLabel.numberOfLines = 0
        self.tutorialLabel.text = Strings.votingTutorial
        
        self.addSubview(self.tutorialLabel)
        
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
    
    func updateImage(voterImage: Image) {
        self.voterImage = voterImage
        
        self.percentLabel.alpha = 0
        self.percentLabel.text = "\(Int(voterImage.percent() * 100))%"
        
        self.image = UIImage(named: "Placeholder")
        self.backgroundColor = Colors.batchPlaceholder
        
        self.voterImage.getImage { (image) -> Void in
            if image != nil {
                self.image = image
                self.backgroundColor = Colors.voterImageBackground
            }
        }
    }
    
    func tapped(gesture: UIGestureRecognizer) {
        self.scaleUp(false, completion: {
            self.delegate.imageSelected(self)
        })
    }
    
    func showPercent() {
        UIView.animateWithDuration(Globals.voterSetInterval, animations: {
            self.percentLabel.alpha = 1
            self.tutorialLabel.alpha = 0
        })
    }
    
    func showTutorial() {
        self.tutorialLabel.alpha = 1
    }
    
    func flag(gesture: UIGestureRecognizer) {
        let controller = UIAlertController(title: Strings.votingFlagAlertTitle,
            message: Strings.votingFlagAlertMessage, preferredStyle: .Alert)
        
        let cancel = UIAlertAction(title: Strings.votingFlagAlertCancel, style: .Cancel, handler: nil)
        let confirm = UIAlertAction(title: Strings.votingFlagAlertConfirm, style: .Destructive) { (action: UIAlertAction) -> Void in
            self.delegate.imageFlagged(self)
        }
        
        controller.addAction(cancel)
        controller.addAction(confirm)
        Globals.pageController.presentViewController(controller, animated: true, completion: nil)
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
