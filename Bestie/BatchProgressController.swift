//
//  BatchProgressController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/25/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit
import PNChart

class BatchProgressController: UIViewController {

    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var votingButton: UIButton!
    
    private var setup: Bool = false
    private var user: User! = User.current()
    private var cirlceChart: PNCircleChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.votingButton.tintColor = UIColor.whiteColor()
        self.votingButton.backgroundColor = Colors.batchSubmitButton
        self.votingButton.layer.cornerRadius = Globals.batchSubmitButtonRadius
        self.votingButton.layer.masksToBounds = true
        
        self.informationLabel.textColor = Colors.batchInstructions
        
        NSTimer.scheduledTimerWithTimeInterval(30, target: self,
            selector: Selector("updateUser"), userInfo: nil, repeats: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !self.setup {
            let size: CGFloat = 250
            let frame = CGRectMake(self.view.frame.width/2 - size/2, self.view.frame.height/2 - size/2, size, size)
            
            self.cirlceChart = PNCircleChart(frame: frame, total: 100, current: 50, clockwise: true)
            self.cirlceChart.backgroundColor = UIColor.clearColor()
            self.cirlceChart.strokeColor = Colors.batchProgressBar
            self.cirlceChart.total = 100
            self.cirlceChart.lineWidth = 15
            self.cirlceChart.countingLabel.font = UIFont.boldSystemFontOfSize(30)
            self.cirlceChart.countingLabel.textColor = Colors.batchProgressBar
            
            self.view.addSubview(self.cirlceChart)
            
            self.setup = true
        }
        
    }
    
    @IBAction func votingButtonTapped(sender: AnyObject) {
        Globals.slideToVotingScreen()
    }
    
    func updateUser() {
        if self.user.batch != nil {
            self.user.batch.fetch(nil)
        }
    }
    
    func updateBatch(batch: Batch) {
        if self.cirlceChart != nil {
            self.cirlceChart.updateChartByCurrent(batch.percent() * 100)
            self.cirlceChart.strokeChart()
        }
    }
}
