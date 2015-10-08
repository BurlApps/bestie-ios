//
//  ShareGenerator.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/26/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit
import Social

protocol ShareGeneratorDelegate {
    func generatorShared()
}

class ShareGenerator: NSObject, UIDocumentInteractionControllerDelegate {
    
    var delegate: ShareGeneratorDelegate!
    private var sender: UIView!
    private var controller: UIViewController!
    private var documentController:UIDocumentInteractionController?
    
    convenience init(sender: UIView, controller: UIViewController) {
        self.init()
        
        self.sender = sender
        self.controller = controller
    }
    
//    func getSharables(text: String, image: UIImage!) -> [UIAlertAction] {
//        var actions: [UIAlertAction] = []
//        
//        let instagramURL = NSURL(string: "instagram://app")
//        if UIApplication.sharedApplication().canOpenURL(instagramURL!) {
//            let instagram = UIAlertAction(title: "Instagram", style: .Default) { action -> Void in
//                let imageData = UIImageJPEGRepresentation(image, 100)
//                let captionString = "Your Caption"
//                let writePath = NSTemporaryDirectory().stringByAppendingPathComponent("instagram.igo")
//                
//                if(imageData!.writeToFile(writePath, atomically: true)) {
//                    let fileURL = NSURL(fileURLWithPath: writePath)
//                    
//                    self.documentController = UIDocumentInteractionController(URL: fileURL)
//                    self.documentController!.UTI = "com.instagram.exclusivegram"
//                    self.documentController!.delegate = self
//                    self.documentController!.annotation =  NSDictionary(object: captionString, forKey: "InstagramCaption")
//                    self.documentController!.presentOpenInMenuFromRect(self.controller.view.frame, inView: self.controller.view, animated: true)
//                }
//            }
//            
//            actions.append(instagram)
//        }
//        
//        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
//            let facebook = UIAlertAction(title: "Facebook", style: .Default) { action -> Void in
//                let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//                facebookSheet.setInitialText("Share on Facebook")
//                self.controller.presentViewController(facebookSheet, animated: true, completion: nil)
//            }
//            actions.append(facebook)
//        }
//        
//        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
//            let twitter = UIAlertAction(title: "Twitter", style: .Default) { action -> Void in
//                let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//                twitterSheet.setInitialText("Share on Twitter")
//                self.controller.presentViewController(twitterSheet, animated: true, completion: nil)
//            }
//            
//            actions.append(twitter)
//        }
//        
//        let everyone = UIAlertAction(title: "Everyone Else", style: .Default) { action -> Void in
//            self.shareSheet(text, image: image)
//        }
//        
//        actions.append(everyone)
//        
//        return actions
//    }
//    
//    func customSheet(text: String, var actions: [UIAlertAction]) {
//        let actionSheet: UIAlertController = UIAlertController(title: "Share Your Bestie",
//            message: "Show the world your best profile picture!", preferredStyle: .ActionSheet)
//        
//        let cancel = UIAlertAction(title: "Canel", style: .Cancel, handler: nil)
//        
//        actions.append(cancel)
//        
//        for action in actions {
//            actionSheet.addAction(action)
//        }
//        
//        
//        actionSheet.popoverPresentationController?.sourceView = self.sender;
//        self.controller.presentViewController(actionSheet, animated: true, completion: nil)
//    }
    
    func shareSheet(text: String, image: UIImage!) {
        var sharingItems = [AnyObject]()
        
        sharingItems.append(text)
        
        if image != nil {
            sharingItems.append(image)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: [])
        
        activityViewController.excludedActivityTypes = [
            UIActivityTypeAssignToContact,
            UIActivityTypePrint,
            UIActivityTypeAssignToContact,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToVimeo
        ]
        
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.delegate!.generatorShared()
            }
        }
        
        self.controller.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func share(text: String, image: UIImage!) {
        self.shareSheet(text, image: image)
        
//        let actions = self.getSharables(image)
//
//        if actions.count > 1 {
//            self.customSheet(actions)
//        } else {
//            self.shareSheet(image)
//        }
    }
}

extension String {
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathComponent(path)
    }
}
