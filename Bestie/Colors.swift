//
//  Colors.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/23/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class Colors {
    
    static let white = UIColor.whiteColor()
    static let red = UIColor(red:0.99, green:0.45, blue:0.43, alpha:1)
    static let gray = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1)
    static let blue = UIColor(red:0.07, green:0.58, blue:0.96, alpha:1)
    static let yellow = UIColor(red:1, green:0.85, blue:0.16, alpha:1)
    static let lightGray = UIColor.lightGrayColor()
    static let borderColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1)
    static let imageBackground = UIColor.blackColor()
    static let textGray = UIColor(red:0.57, green:0.57, blue:0.57, alpha:1)
    
    static let settingsBackground = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
    
    static let progressTrack = UIColor.clearColor()
    static let progressBar = blue
    
    static let navBar = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1)
    
    static let primaryIcon = yellow
    static let defaultIcon = gray
    
    static let onboardText = red
    static let onboardIndicator = red
    static let onboardIndicatorBackground = lightGray
    static let onboardSeparator = navBar
    
    static let voterTextLabel = blue
    static let voterImageBorder = borderColor
    static let voterImageBackground = imageBackground

    static let batchPlaceholder = UIColor(red:0.97, green:0.98, blue:0.98, alpha:1)
    static let batchPlaceholderIcon = UIColor(white: 0, alpha: 0.25)
    
    static let batchImageCellBackground = imageBackground
    static let batchImageCellBorder = borderColor
    static let batchImageCellRemove = white
    static let batchImageCellRemoveBorder = red
    
    static let batchPlusCellBackground = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
    static let batchPlusCellIcon = gray
    static let batchPlusCellBorder = gray
    
    static let batchSubmitButton = blue
    static let batchSubmitAlternateButton = red
    static let batchInfomation = textGray
    static let batchInstructions = textGray
    static let batchProgressBar = yellow
    static let batchBestie = blue
    static let batchNumbers = red
    
    class func mix(percent: CGFloat, initC: UIColor, goal: UIColor) -> UIColor{
        let cgInit = CGColorGetComponents(initC.CGColor)
        let cgGoal = CGColorGetComponents(goal.CGColor)
        
        
        let r = cgInit[0] + percent * (cgGoal[0] - cgInit[0])
        let g = cgInit[1] + percent * (cgGoal[1] - cgInit[1])
        let b = cgInit[2] + percent * (cgGoal[2] - cgInit[2])
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
