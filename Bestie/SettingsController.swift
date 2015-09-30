//
//  SettingsController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/29/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    
    private var user = User.current()
    private var config: Config!
    @IBOutlet weak var interestedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.settingsBackground
        self.tableView.backgroundColor = Colors.settingsBackground
        
        self.interestedLabel.text = self.user.interested.capitalizedString
        
        Config.sharedInstance { (config) -> Void in
            self.config = config
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
                
            share.share("Bestie is pretty cool, it finds your best profile pictures for you! \(self.config.downloadUrl)", image: nil)
        
        case "1:0":
            let controller = UIAlertController(title: "Show Me", message: nil, preferredStyle: .ActionSheet)
            let male = UIAlertAction(title: "Males", style: .Default, handler: { (action: UIAlertAction) -> Void in
                self.user.changeInterest("male")
                self.interestedLabel.text = "Male"
                Globals.voterController.flushSets()
            })
            let female = UIAlertAction(title: "Females", style: .Default, handler: { (action: UIAlertAction) -> Void in
                self.user.changeInterest("female")
                self.interestedLabel.text = "Female"
                Globals.voterController.flushSets()
            })
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            controller.addAction(male)
            controller.addAction(female)
            controller.addAction(cancel)
            
            Globals.pageController.presentViewController(controller, animated: true, completion: nil)
        
        case "1:1":
            let controller = UIAlertController(title: "Logout", message: "Are you sure you want to logout and erase all your data.", preferredStyle: .Alert)
            let no = UIAlertAction(title: "No", style: .Cancel, handler: nil)
            let yes = UIAlertAction(title: "Yes", style: .Destructive, handler: { (action: UIAlertAction) -> Void in
                User.logout()
                Globals.showOnboarding()
            })
            
            controller.addAction(no)
            controller.addAction(yes)
            
            Globals.pageController.presentViewController(controller, animated: true, completion: nil)
            
        default: return
        }
    }

}
