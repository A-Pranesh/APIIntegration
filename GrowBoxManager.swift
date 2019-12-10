//
//  GrowBoxManager.swift
//  SampleGrowBox
//
//  Created by Divum on 10/12/19.
//  Copyright © 2019 Divum. All rights reserved.
//
import Foundation
import Alamofire

class GrowBoxManager {
    static let sharedInstance = GrowBoxManager()
    static func getGrowBoxStatus(success: @escaping ((_ growBoxModel: GrowBoxModel) -> Void), failure: @escaping ((_ error:NSError?, _ responseStatusCode: Int?) -> Void)) {
        GrowBoxManager.sharedInstance.getGrowBoxStatus { (response) in
            if response.success, let result = response.responseObject?.growBoxModel {
                success(result)
            } else {
                failure(response.error, response.responseStatusCode)
            }
        }
    }
}

extension GrowBoxManager {
    private func getGrowBoxStatus(callback: @escaping GrowBoxParser.GrowBoxResponseHandler) {
        let apiUrl = "http://34.244.162.30:8081/status"
        Alamofire.request(apiUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (alamofireResponse) in
            let response = networkResponseForResponse(alamofireResponse) { (json) -> GrowBoxParser in
                let growBoxParser = GrowBoxParser.parse(json)
                return growBoxParser
            }
            callback(response)
        }
    }
}
