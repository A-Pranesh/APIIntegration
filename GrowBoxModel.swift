//
//  GrowBoxModel.swift
//  SampleGrowBox
//
//  Created by Divum on 10/12/19.
//  Copyright © 2019 Divum. All rights reserved.
//
import Foundation
class GrowBoxModel {
    var doorStatus: Bool
    var pwmValue: Int
    var interLight: Bool
    init() {
        doorStatus = false
        interLight = false
        pwmValue = 0
    }
    
    convenience init( _ json: AnyObject) {
        self.init()
        guard let jsonDict = json as? [String: AnyObject] else { return }
        if let doorStatus = jsonDict["doorStatus"] as? Bool { self.doorStatus = doorStatus }
        if let pwmValue = jsonDict["pwmValue"] as? Int { self.pwmValue = pwmValue }
        if let interLight = jsonDict["interLight"] as? Bool { self.interLight = interLight }
    }
}
