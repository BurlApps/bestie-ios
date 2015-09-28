//
//  NavigationBarItem.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/24/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import THTinderNavigationController_ssuchanowski

class NavigationBarItem: UIView, THTinderNavigationBarItem {
    
    private var imageView: UIImageView!
    private var imageViewGray: UIImageView!
    private var special: Bool!
    private var faceLeft: Bool = true
    
    convenience init(namedImage: String, special: Bool) {
        self.init()
        
        var image = UIImage(named: namedImage)
        
        self.imageView = UIImageView(image: image)
        self.imageViewGray = UIImageView()
        self.special = special
        self.addSubview(self.imageView)
        
        if special {
            self.imageViewGray = UIImageView(image: UIImage(named: "\(namedImage)-Gray"))
            self.imageViewGray.alpha = 0

            self.insertSubview(self.imageViewGray, aboveSubview: self.imageView)
        } else {
            image = image!.imageWithRenderingMode(.AlwaysTemplate)
            self.imageView.tintColor = Colors.defaultIcon
        }
    }
    
    func switchFace() {
        let direction = self.faceLeft ? "Right" : "Left"
        self.faceLeft = !self.faceLeft
        
        self.imageView.image = UIImage(named: "Face-\(direction)")
        self.imageViewGray.image = UIImage(named: "Face-\(direction)-Gray")
    }
    
    func updateViewWithRatio(ratio: CGFloat) {
        var max: CGFloat = 0.75
        var tempRatio = ratio/2.0 + 0.5
        
        if !self.special {
            self.imageView.tintColor = Colors.mix(ratio, initC: Colors.defaultIcon, goal: Colors.primaryIcon)
            
        } else {
            max = 1
            self.imageViewGray.alpha = 1 - ratio
        }
        
        tempRatio = min(tempRatio, max);
        
        let height = self.frame.size.height * tempRatio;
        let width = self.frame.size.width * tempRatio;
        let x = (self.frame.size.width - width) / 2.0;
        let y = (self.frame.size.height - height) / 2.0;
        let frame = CGRectMake(x, y, width, height)
        
        self.imageView.frame = frame
        self.imageViewGray.frame = frame
    }

}
