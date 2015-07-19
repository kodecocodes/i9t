//
//  FileHelper.swift
//  Colleagues
//
//  Created by Chris Wagner on 7/18/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation

class FileHelper {
    
    static var bundle: NSBundle {
        return NSBundle(forClass: self)
    }
    
    static var bundlePath: String {
        return self.bundle.bundlePath
    }
    
    static var employeesJsonFilePath: String {
        return self.bundle.pathForResource("employees", ofType: "json")!
    }    
}