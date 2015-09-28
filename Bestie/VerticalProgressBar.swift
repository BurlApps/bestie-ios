//
//  VerticalProgressBar.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/24/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class VerticalProgressBar: UIView {
    
    private var progress: Float = 0
    private var bar: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = Colors.progressTrack
        self.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2 * 2))
        
        self.bar = UIView()
        self.bar.backgroundColor = Colors.progressBar
        self.progress(0, animation: false)
        
        self.addSubview(self.bar)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func increment(increment: Float, animation: Bool) {
        self.progress += increment
        self.progress(self.progress, animation: animation)
    }
    
    func progress(percent: Float, animation: Bool) {
        self.progress = min(percent, 1)
        
        let frame = self.frame
        let height = frame.height * CGFloat(self.progress)
            
        UIView.animateWithDuration(animation ? 0.2 : 0, animations: {
            self.bar.frame = CGRectMake(0,  0, frame.width, height)
        }, completion: { (finished: Bool) -> Void in
            if finished && percent >= 1 {
                self.progress(0, animation: true)
            }
        })
    }
}
