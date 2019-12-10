//
//  GrowBoxViewModel+IGrowBoxViewModel.swift
//  SampleGrowBox
//
//  Created by Divum on 10/12/19.
//  Copyright © 2019 Divum. All rights reserved.
//
import Foundation
extension GrowBoxViewModel: IGrowBoxViewModel{
    func getGrowBoxStatus() {
        GrowBoxManager.getGrowBoxStatus(success: { (result) in
            self.growBoxModel = result
            self.delegate?.getGrowBoxSuccessResponse()
        }, failure: { (error, responseStatusCode) in
            self.delegate?.getGrowBoxFailureResponse()
        })
    }
}
