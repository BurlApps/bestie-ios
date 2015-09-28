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
    private var cirlceChart: PNCircleChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.votingButton.tintColor = UIColor.whiteColor()
        self.votingButton.backgroundColor = Colors.batchSubmitButton
        self.votingButton.layer.cornerRadius = Globals.batchSubmitButtonRadius
        self.votingButton.layer.masksToBounds = true
        
        self.informationLabel.textColor = Colors.batchInstructions
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
            
            let backgroundView = UIView(frame: self.view.frame)
            let image = UIImage(named: "HeaderBackground")
            
            backgroundView.backgroundColor = UIColor(patternImage: image!)
            backgroundView.alpha = 0.05
            self.view.insertSubview(backgroundView, atIndex: 0)
            
            self.setup = true
        }
        
    }
    
    @IBAction func votingButtonTapped(sender: AnyObject) {
        Globals.slideToVotingScreen()
    }
    
    func updateBatch(batch: Batch) {
        self.cirlceChart.updateChartByCurrent(batch.percent() * 100)
        self.cirlceChart.strokeChart()
    }
}
