//
//  GrowBoxViewModel.swift
//  SampleGrowBox
//
//  Created by Divum on 10/12/19.
//  Copyright © 2019 Divum. All rights reserved.
//
import Foundation
protocol IGrowBoxViewModel {
    func getGrowBoxStatus()
}
protocol GrowBoxViewModelDelegate: class {
    func getGrowBoxSuccessResponse()
    func getGrowBoxFailureResponse()
}
class GrowBoxViewModel {
    var growBoxModel: GrowBoxModel!
    weak var delegate: GrowBoxViewModelDelegate?
    
}
