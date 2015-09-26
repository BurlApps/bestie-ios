//
//  Colors.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/23/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class Colors {
    
    static let red = UIColor(red:1, green:0.26, blue:0.32, alpha:1)
    static let gray = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1)
    static let yellow = UIColor(red: 0.98, green: 0.82, blue: 0.114, alpha: 1)
    
    static let progressTrack = UIColor.clearColor()
    static let progressBar = yellow
    
    static let navBar = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1)
    
    static let primaryIcon = UIColor(red:0.98, green:0.82, blue:0.12, alpha:1)
    
    static let voterTextLabel = red
    static let voterImageBorder = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1)
    static let voterImageBackground = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)

    static let batchImageCellBackground = UIColor.blackColor()
    static let batchImageCellBorder = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1)
    static let batchImageCellRemove = UIColor.whiteColor()
    static let batchImageCellRemoveBorder = UIColor(red:1, green:0.26, blue:0.32, alpha:1)
    
    static let batchPlusCellBackground = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
    static let batchPlusCellIcon = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1)
    static let batchPlusCellBorder = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1)
    
    static let batchSubmitButton = UIColor(red:0.98, green:0.82, blue:0, alpha:1)
    static let batchInfomation = UIColor(red:0.67, green:0.67, blue:0.67, alpha:1)
    static let batchInstructions = UIColor(red:0.6, green:0.6, blue:0.6, alpha:1)
    static let batchProgressBar = UIColor(red:0.96, green:0.52, blue:0, alpha:1)
    static let batchHeaderLabel = UIColor(red:1, green:0.59, blue:0.28, alpha:1)
    static let batchHeaderSeparator = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1)
    
    class func mix(percent: CGFloat, initC: UIColor, goal: UIColor) -> UIColor{
        let cgInit = CGColorGetComponents(initC.CGColor)
        let cgGoal = CGColorGetComponents(goal.CGColor)
        
        
        let r = cgInit[0] + percent * (cgGoal[0] - cgInit[0])
        let g = cgInit[1] + percent * (cgGoal[1] - cgInit[1])
        let b = cgInit[2] + percent * (cgGoal[2] - cgInit[2])
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
