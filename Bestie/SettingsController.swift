//
//  SettingsController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/29/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController, ShareGeneratorDelegate {
    
    private var user = User.current()
    private var config: Config!
    @IBOutlet weak var interestedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.settingsBackground
        self.tableView.backgroundColor = Colors.settingsBackground
        
        self.loadInterest(self.user.interested)
        
        Config.sharedInstance { (config) -> Void in
            self.config = config
        }
    }
    
    func loadInterest(interest: String) {
        switch(interest) {
            case "male": self.interestedLabel.text = "Men"
            case "female": self.interestedLabel.text = "Women"
            default: self.interestedLabel.text = "Men & Women"
        }
    }
    
    func changeInterest(interest: String) {
        self.user.changeInterest(interest) { () -> Void in
            self.loadInterest(self.user.interested)
            Globals.voterController.flushSets()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch("\(indexPath.section):\(indexPath.row)") {
        case "0:0":
            let url = NSURL(string: "itms-apps://itunes.apple.com/app/id\(self.config.itunesId)")
            UIApplication.sharedApplication().openURL(url!)
        
        case "0:1":
            let share = ShareGenerator(sender: self.view, controller: Globals.pageController)
            share.delegate = self
            share.share(self.config.shareMessage, image: nil)
        
        case "1:0":
            let controller = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            let male = UIAlertAction(title: "Men", style: .Default, handler: { (action: UIAlertAction) -> Void in
                self.changeInterest("male")
            })
            let female = UIAlertAction(title: "Women", style: .Default, handler: { (action: UIAlertAction) -> Void in
                self.changeInterest("female")
            })
            let both = UIAlertAction(title: "Men & Women", style: .Default, handler: { (action: UIAlertAction) -> Void in
                self.changeInterest("both")
            })
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            controller.addAction(male)
            controller.addAction(female)
            controller.addAction(both)
            controller.addAction(cancel)
            
            Globals.pageController.presentViewController(controller, animated: true, completion: nil)
        
        case "1:1":
            let controller = UIAlertController(title: Strings.logoutAlertTitle,
                message: Strings.logoutAlertMessage, preferredStyle: .Alert)
            let no = UIAlertAction(title: Strings.logoutAlertCancel, style: .Cancel, handler: nil)
            let yes = UIAlertAction(title: Strings.logoutAlertConfirm, style: .Destructive, handler: { (action: UIAlertAction) -> Void in
                User.logout()
                Globals.showOnboarding()
            })
            
            controller.addAction(no)
            controller.addAction(yes)
            
            Globals.pageController.presentViewController(controller, animated: true, completion: nil)
            
        case "2:0":
            let url = NSURL(string: self.config.termsURL)
            UIApplication.sharedApplication().openURL(url!)
            
        case "2:1":
            let url = NSURL(string: self.config.privacyURL)
            UIApplication.sharedApplication().openURL(url!)
            
        default: return
        }
    }
    
    func generatorShared() {
        self.user.changeShared(true)
    }

}
