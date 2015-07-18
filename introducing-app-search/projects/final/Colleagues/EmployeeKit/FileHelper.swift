//
//  FileHelper.swift
//  Colleagues
//
//  Created by Chris Wagner on 7/18/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation

class FileHelper {
    static var employeesJsonFilePath: String {
        return NSBundle(forClass: self).pathForResource("employees", ofType: "json")!
    }
    
    static func employeePictureFilePath(name: String) -> String? {
        return NSBundle(forClass: self).pathForResource(name, ofType: "jpg")!
    }
}