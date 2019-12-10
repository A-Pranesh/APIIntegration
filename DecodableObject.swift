//
//  DecodableObject.swift
//  PracticeEco
//
//  Created by Divum Corporate Services on 7/15/17.
//  Copyright © 2017 Divum Corporate Services. All rights reserved.
//

import Foundation

enum ParseError: Error {
    case castError
    case keyNotFound(for: String)
}

protocol DecodableObject {
    associatedtype ReturnType

    static func parse(_ json: AnyObject) -> ReturnType
}
