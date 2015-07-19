//
//  EmployeeExt.swift
//  Colleagues
//
//  Created by Chris Wagner on 7/18/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation
import EmployeeKit

extension Employee {
    func call() {
        let sanitizedPhoneNumber = phone.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let callUrl = NSURL(string: "tel:" + sanitizedPhoneNumber)!
        UIApplication.sharedApplication().openURL(callUrl)
    }
    
    func sendEmail() {
        let mailUrl = NSURL(string: "mailto:" + email)!
        UIApplication.sharedApplication().openURL(mailUrl)
    }
}