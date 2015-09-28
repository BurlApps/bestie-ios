//
//  Image.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/27/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

class Image {
    
    // MARK: Instance Variables
    var batch: Batch!
    var score: Int!
    var good: Int!
    var bad: Int!
    var votes: Int!
    var active: Bool!
    var imageURL: NSURL!
    var image: UIImage!
    var parse: PFObject!
    
    // MARK: Convenience Methods
    convenience init(_ object: PFObject) {
        self.init()
        
        self.active = object["active"] as? Bool
        self.votes = object["votes"] as? Int
        self.score = object["score"] as? Int
        self.good = object["good"] as? Int
        self.bad = object["bad"] as? Int
        self.parse = object
        
        if let image = object["image"] as? PFFile {
            self.imageURL = NSURL(string: image.url!)
        }
        
        if let batch = object["batch"] as? PFObject {
            self.batch = Batch(batch)
        }
    }

    
    func getImage(callback: (image: UIImage) -> Void) {
        if self.image == nil {
            let request = NSURLRequest(URL: self.imageURL)
            let session = NSURLSession.sharedSession()
            
            session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if error == nil {
                    self.image = UIImage(data: data!)
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                        // Makes a 1x1 graphics context and draws the image into it
                        UIGraphicsBeginImageContext(CGSizeMake(1,1))
                        let context = UIGraphicsGetCurrentContext()
                        CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.image.CGImage)
                        UIGraphicsEndImageContext()
                        
                        // Now the image will have been loaded and decoded
                        // and is ready to rock for the main thread
                        dispatch_async(dispatch_get_main_queue(), {
                            callback(image: self.image)
                        })
                    })
                } else {
                    ErrorHandler.handleParseError(error!)
                }
            }).resume()
        } else {
            callback(image: self.image)
        }
    }
}
