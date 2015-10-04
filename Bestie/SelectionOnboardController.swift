//
//  WelcomeOnboard2Controller.swift
//  Bestie
//
//  Created by Brian Vallelunga on 10/2/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class SelectionOnboardController: OnboardPageController {
    
    private var gender: String!
    private var interest: String!
    private var disabled: CGFloat = 0.4

    @IBOutlet weak var interestLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var genderFemale: UIImageView!
    @IBOutlet weak var genderMale: UIImageView!
    
    @IBOutlet weak var interestFemale: UIImageView!
    @IBOutlet weak var interestMale: UIImageView!
    @IBOutlet weak var interestBoth: UIImageView!
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var voteButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.interestLabel.textColor = Colors.batchNumbers
        self.genderLabel.textColor = Colors.batchNumbers
        
        self.initButton(self.uploadButton)
        self.initButton(self.voteButton)
        
        self.voteButton.backgroundColor = Colors.batchSubmitAlternateButton
        
        self.initImage(self.genderMale, type: "gender", tag: 0)
        self.initImage(self.genderFemale, type: "gender", tag: 1)
        self.initImage(self.interestMale, type: "interest", tag: 0)
        self.initImage(self.interestFemale, type: "interest", tag: 1)
        self.initImage(self.interestBoth, type: "interest", tag: 2)
    }
    
    func initButton(button: UIButton) {
        button.tintColor = UIColor.whiteColor()
        button.backgroundColor = Colors.batchSubmitButton
        button.layer.cornerRadius = Globals.batchSubmitButtonRadius
        button.layer.masksToBounds = true
        button.hidden = true
    }
    
    func resetImage(image: UIImageView) {
        image.alpha = self.disabled
    }
    
    func initImage(image: UIImageView, type: String, tag: Int) {
        image.tintColor = Colors.textGray
        image.alpha = self.disabled
        image.backgroundColor = UIColor.clearColor()
        image.userInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: Selector("\(type)\(tag):"))
        image.addGestureRecognizer(gesture)
    }
    
    func checkButton() {
        let hide = self.gender == nil || self.interest == nil
        
        self.voteButton.hidden = hide
        self.uploadButton.hidden = hide
    }
    
    func gender0(gesture: UIGestureRecognizer) {
        self.gender = "male"
        
        self.genderMale.alpha = 1
        self.genderFemale.alpha = self.disabled
        
        self.checkButton()
    }
    
    func gender1(gesture: UIGestureRecognizer) {
        self.gender = "female"
        
        self.genderMale.alpha = self.disabled
        self.genderFemale.alpha = 1
        
        self.checkButton()
    }
    
    func interest0(gesture: UIGestureRecognizer) {
        self.interest = "male"
        
        self.interestMale.alpha = 1
        self.interestFemale.alpha = self.disabled
        self.interestBoth.alpha = self.disabled
        
        self.checkButton()
    }
    
    func interest1(gesture: UIGestureRecognizer) {
        self.interest = "female"
        
        self.interestMale.alpha = self.disabled
        self.interestFemale.alpha = 1
        self.interestBoth.alpha = self.disabled
        
        self.checkButton()
    }
    
    func interest2(gesture: UIGestureRecognizer) {
        self.interest = "both"
        
        self.interestMale.alpha = self.disabled
        self.interestFemale.alpha = self.disabled
        self.interestBoth.alpha = 1
        
        self.checkButton()
    }
    
    func submit() {
        //self.onboardController.user.gender = self.gender
        //self.onboardController.user.interested = self.interest
        
        self.onboardController.user.changeGenderInterest(self.gender, interest: self.interest)
        self.onboardController.nextController()
        
        self.gender = nil
        self.interest = nil
        
        self.checkButton()
        
        self.resetImage(self.genderMale)
        self.resetImage(self.genderFemale)
        self.resetImage(self.interestMale)
        self.resetImage(self.interestFemale)
        self.resetImage(self.interestBoth)
    }
    
    @IBAction func uploadTapped(sender: AnyObject) {
        self.onboardController.nextPage = 2
        self.submit()
    }
    
    @IBAction func voteTapped(sender: AnyObject) {
        self.onboardController.nextPage = 1
        self.submit()
    }
}
