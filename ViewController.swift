//
//  ViewController.swift
//  SampleGrowBox
//
//  Created by Divum on 10/12/19.
//  Copyright © 2019 Divum. All rights reserved.
//
import UIKit
class ViewController: UIViewController, GrowBoxViewModelDelegate {
    @IBOutlet weak var doorStatusLabel: UILabel!
    @IBOutlet weak var pwmValueLabel: UILabel!
    @IBOutlet weak var interLightLabel: UILabel!
    var growBoxViewModel = GrowBoxViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGrowBoxViewModel()
    }
    
    private func setupGrowBoxViewModel() {
        growBoxViewModel.delegate = self
        growBoxViewModel.getGrowBoxStatus()
    }
    
    private func setupView(_ growBoxStatus: GrowBoxModel) {
        doorStatusLabel.text = growBoxStatus.doorStatus ? "Open" : "Close"
        pwmValueLabel.text = "\(growBoxStatus.pwmValue)"
        interLightLabel.text = growBoxStatus.interLight ? "On" : "Off"
    }
}

extension ViewController {
    func getGrowBoxSuccessResponse() {
        self.setupView(growBoxViewModel.growBoxModel)
    }
    func getGrowBoxFailureResponse() {
        
    }
}
