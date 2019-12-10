//
//  GrowBoxParser.swift
//  SampleGrowBox
//
//  Created by Divum on 10/12/19.
//  Copyright © 2019 Divum. All rights reserved.
//
import Foundation
class GrowBoxParser: DecodableObject {
    typealias GrowBoxResponseHandler = ((_ result: NetworkResponse<GrowBoxParser>) -> Void)
    var growBoxModel: GrowBoxModel
    init(growBoxStatusModel: GrowBoxModel) {
        self.growBoxModel = growBoxStatusModel
    }
    
    static func parse(_ json: AnyObject) -> GrowBoxParser {
        let growBoxModel = GrowBoxModel(json)
        return GrowBoxParser(growBoxStatusModel: growBoxModel)
    }
}
