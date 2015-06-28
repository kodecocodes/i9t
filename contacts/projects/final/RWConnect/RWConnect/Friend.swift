//
//  Friend.swift
//  RWConnect
//
//  Created by Evan Dekhayser on 6/16/15.
//  Copyright © 2015 Razeware, LLC. All rights reserved.
//

import UIKit
import Contacts

struct Friend{
  let firstName: String
  let lastName: String
  let workEmail: String
  let profilePicture: UIImage?
  
  init(firstName: String, lastName: String, workEmail: String, profilePicture: UIImage?){
    self.firstName = firstName
    self.lastName = lastName
    self.workEmail = workEmail
    self.profilePicture = profilePicture
  }
  
  static func defaultContacts() -> [Friend] {
    return [Friend(firstName: "Mic", lastName: "Pringle", workEmail: "mic@example.com", profilePicture: UIImage(named: "MicProfilePicture")), Friend(firstName: "Ray", lastName: "Wenderlich", workEmail: "ray@example.com", profilePicture: UIImage(named: "RayProfilePicture")), Friend(firstName: "Sam", lastName: "Davies", workEmail: "sam@example.com", profilePicture: UIImage(named: "SamProfilePicture")), Friend(firstName: "Greg", lastName: "Heo", workEmail: "greg@example.com", profilePicture: UIImage(named: "GregProfilePicture"))]
  }
}

extension Friend{
  init(contact: CNContact){
    firstName = contact.givenName
    lastName = contact.familyName
    workEmail = contact.emailAddresses[0].value as! String
    if let imageData = contact.imageData{
      profilePicture = UIImage(data: imageData)
    } else {
      profilePicture = nil
    }
  }
  
  var contactValue: CNMutableContact{
    let contact = CNMutableContact()
    contact.givenName = firstName
    contact.familyName = lastName
    contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: workEmail)]
    if let profilePicture = profilePicture{
      let imageData = UIImageJPEGRepresentation(profilePicture, 1)
      contact.imageData = imageData
    }
    return contact
  }
}