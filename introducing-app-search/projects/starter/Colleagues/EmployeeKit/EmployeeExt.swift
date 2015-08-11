/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

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
    attributeSet.relatedUniqueIdentifier = objectId
    
    return attributeSet
  }
  
  var searchableItem: CSSearchableItem {
    let item = CSSearchableItem(uniqueIdentifier: objectId,
      domainIdentifier: Employee.domainIdentifier,
      attributeSet: attributeSet)
    return item
  }

}


