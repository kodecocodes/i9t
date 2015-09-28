//
//  EmployeeSearch.swift
//  Colleagues
//
//  Created by Chris Wagner on 9/27/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation
import CoreSpotlight
import MobileCoreServices

extension Employee {
  public static let domainIdentifier = "com.raywenderlich.colleagues.employee"
  
  public var userActivityUserInfo: [NSObject: AnyObject] {
    return ["id": objectId]
  }

  public var userActivity: NSUserActivity {
    let activity = NSUserActivity(activityType: Employee.domainIdentifier)
    activity.title = name
    activity.userInfo = userActivityUserInfo
    activity.keywords = [email, department]
    activity.contentAttributeSet = attributeSet
    return activity
  }

  public var attributeSet: CSSearchableItemAttributeSet {
    let attributeSet = CSSearchableItemAttributeSet(
      itemContentType: kUTTypeContact as String)
    attributeSet.title = name
    attributeSet.contentDescription = "\(department), \(title)\n\(phone)"
    attributeSet.thumbnailData = UIImageJPEGRepresentation(
      loadPicture(), 0.9)
    attributeSet.supportsPhoneCall = true
    
    attributeSet.phoneNumbers = [phone]
    attributeSet.emailAddresses = [email]
    attributeSet.keywords = skills
    
    return attributeSet
  }

}
