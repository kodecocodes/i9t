//
//  Protocols.swift
//  Colleagues
//
//  Created by Chris Wagner on 7/18/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation

public enum JSONDecodingError: ErrorType {
    case MissingAttribute(String)
}

public protocol JSONDecodable {
    init(json: [NSObject: AnyObject]) throws
}