//
//  Image.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/27/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import AlamofireImage

let imageCache = AutoPurgingImageCache()
let downloader = ImageDownloader()

class Image {
    
    // MARK: Instance Variables
    var batch: Batch!
    var score: Int!
    var votes: Int!
    var maxVotes: Int!
    var wins: Float!
    var losses: Float!
    var active: Bool!
    var gender: String!
    var imageURL: NSURL!
    var image: UIImage!
    var parse: PFObject!
    
    // MARK: Convenience Methods
    convenience init(_ object: PFObject) {
        self.init()
        
        self.active = object["active"] as? Bool
        self.score = object["score"] as? Int
        self.wins = object["wins"] as? Float
        self.losses = object["losses"] as? Float
        self.votes = object["votes"] as? Int
        self.maxVotes = object["maxVotes"] as? Int
        self.parse = object
        
        if self.maxVotes == nil {
            Config.sharedInstance({ (config) -> Void in
                self.maxVotes = config.imageMaxVotes
            })
        }
        
        if let image = object["image"] as? PFFile {
            if let url: String = image.url {
                self.imageURL = NSURL(string: url)
            }
        }
        
        if let batch = object["batch"] as? PFObject {
            batch.fetchIfNeededInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                if object != nil {
                    self.batch = Batch(batch)
                } else {
                    ErrorHandler.handleParseError(error!)
                }
            })
        }
    }
    
    class func create(image: UIImage, user: User) -> Image {
        let voterImage = PFObject(className: "Image")
        let imageData = UIImageJPEGRepresentation(image, 0.7)
        let imageFile = PFFile(name: "image.jpeg", data: imageData!)
        
        voterImage["gender"] = user.gender
        voterImage["creator"] = user.parse
        voterImage["active"] = false
        
        let voter = Image(voterImage)
        voter.image = image
        
        voterImage.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                voter.active = voterImage["active"] as? Bool
                voter.score = voterImage["score"] as? Int
                voter.votes = voterImage["votes"] as? Int
                
                voterImage["image"] = imageFile
                voterImage.saveInBackground()
            } else {
                ErrorHandler.handleParseError(error!)
            }
        }
        
        return voter
    }
    
    func percent() -> Float {
        let percent = self.wins/Float(self.votes)
        
        if percent.isFinite {
            return percent
        }
        
        return 0
    }
    
    func remove() {
        self.parse.deleteInBackground()
    }
    
    func flag() {
        self.parse["active"] = false
        self.parse["flagged"] = true
        self.parse.saveInBackground()
    }
    
    func activate(batch: Batch) {
        self.parse["active"] = true
        self.parse["batch"] = batch.parse
        self.parse.saveInBackground()
    }
    
    func getImage(callback: (image: UIImage) -> Void) {
        if self.image != nil {
            callback(image: self.image)
            return
        }
        
        let request = NSURLRequest(URL: self.imageURL)
        
        if let image = imageCache.imageForRequest(request) {
            callback(image: image)
        } else {
            downloader.downloadImage(URLRequest: request) { response in                
                if let image: UIImage = response.result.value {
                    callback(image: image)
                    imageCache.addImage(image, forRequest: request)
                }
            }
        }
    }
}
