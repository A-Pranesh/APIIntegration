//
//  JSONParser.swift
//  PracticeEco
//
//  Created by Divum Corporate Services on 7/15/17.
//  Copyright © 2017 Divum Corporate Services. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: AnyObject]
typealias JSONArray = [[String: AnyObject]]

class JSONParser {
    static func parseDictionary(withData data: Data?) -> [String: AnyObject]? {
        do {
            if let data = data,
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                return json
            }
        } catch {
            print("Unable to parse object: \(error)")
        }

        return nil
    }

    static func stringDecimalToDouble(_ decimalString: String?) -> Double? {
        guard let stringValue = decimalString else {
            return nil
        }

        return Double(stringValue)
    }
}
