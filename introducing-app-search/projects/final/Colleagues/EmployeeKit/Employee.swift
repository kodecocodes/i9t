//
//  Employee.swift
//  Colleagues
//
//  Created by Chris Wagner on 7/18/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation

public struct Employee: JSONDecodable {
    public let objectId: String
    public let department: String
    public let email: String
    public let name: String
    public let phone: String
    public let title: String
    public let skills: [String]
    
    public init(json: [NSObject: AnyObject]) throws {
        guard let objectId = json["objectId"] as? String  else {
            throw JSONDecodingError.MissingAttribute("objectId")
        }
        guard let department = json["department"] as? String  else {
            throw JSONDecodingError.MissingAttribute("department")
        }
        guard let email = json["email"] as? String  else {
            throw JSONDecodingError.MissingAttribute("email")
        }
        guard let name = json["name"] as? String  else {
            throw JSONDecodingError.MissingAttribute("name")
        }
        guard let phone = json["phone"] as? String  else {
            throw JSONDecodingError.MissingAttribute("phone")
        }
        guard let title = json["title"] as? String  else {
            throw JSONDecodingError.MissingAttribute("title")
        }
        guard let skills = json["skills"] as? [String]  else {
            throw JSONDecodingError.MissingAttribute("skills")
        }
        
        self.objectId = objectId
        self.department = department
        self.email = email
        self.name = name
        self.phone = phone
        self.title = title
        self.skills = skills
    }
    
    public func loadPicture() -> UIImage {
        let splits = split(self.email.characters, maxSplit: 1, allowEmptySlices: false) { $0 == "@" }.map(String.init)
        if let filename = splits.first {
            return UIImage(named: filename + ".jpg", inBundle: FileHelper.bundle, compatibleWithTraitCollection: nil) ?? UIImage()
        } else {
            return UIImage()
        }
    }
}