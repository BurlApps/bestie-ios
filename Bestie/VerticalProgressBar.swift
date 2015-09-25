//
//  VerticalProgressBar.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/24/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class VerticalProgressBar: UIView {
    
    private var progress: CGFloat = 0
    private var bar: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = Colors.progressBar
        self.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2 * 2))
        
        self.bar = UIView()
        self.bar.backgroundColor = Colors.yellow
        self.progress(0, animation: false)
        
        self.addSubview(self.bar)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func progress(percent: CGFloat, animation: Bool) {
        let frame = self.frame
        let height = frame.height * percent
        
        UIView.animateWithDuration(animation ? 0.2 : 0, animations: {
            self.bar.frame = CGRectMake(0,  0, frame.width, height)
        }, completion: nil)
    }
}
