//
//  EmployeExt.swift
//  Colleagues
//
//  Created by Chris Wagner on 7/22/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation
import CoreSpotlight
import MobileCoreServices

public extension Employee {
  
  public static let domainIdentifier = "com.raywenderlich.colleagues.employee"
  
  public var searchableItemAttributeSet: CSSearchableItemAttributeSet {
    let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeContact as String)
    attributeSet.title = name
    attributeSet.contentDescription = "\(department), \(title)\n\(phone)"
    attributeSet.thumbnailData = UIImageJPEGRepresentation(loadPicture(), 0.9)
    attributeSet.phoneNumbers = [phone]
    attributeSet.emailAddresses = [email]
    attributeSet.relatedUniqueIdentifier = objectId
    attributeSet.keywords = skills

    return attributeSet
  }
  
  var searchableItem: CSSearchableItem {
    let item = CSSearchableItem(uniqueIdentifier: objectId, domainIdentifier: self.dynamicType.domainIdentifier, attributeSet: searchableItemAttributeSet)
    return item
  }
}