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
import EmployeeKit
import CoreSpotlight
import MobileCoreServices

extension Employee {
  
  var userActivityUserInfo: [NSObject: AnyObject] {
    return ["id": objectId]
  }
  
  var userActivity: NSUserActivity {
    let activity = NSUserActivity(activityType: "com.raywenderlich.colleagues.employee")
    activity.title = name
    activity.eligibleForSearch = true
    activity.userInfo = userActivityUserInfo
    activity.keywords = [email, department]
    
    let contentAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeContact as String)
    contentAttributeSet.thumbnailData = UIImageJPEGRepresentation(loadPicture(), 0.9)
    contentAttributeSet.phoneNumbers = [phone]
    contentAttributeSet.contentDescription = "\(department), \(title)\n\(phone)"
    
    activity.contentAttributeSet = contentAttributeSet
    return activity
  }
  
  /// Dial the employee's phone number use the system dialer.
  func call() {
    let sanitizedPhoneNumber = phone.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    let callUrl = NSURL(string: "tel:" + sanitizedPhoneNumber)!
    UIApplication.sharedApplication().openURL(callUrl)
  }
  
  /// Open the system email client with the employee's email address populated in the TO field.
  func sendEmail() {
    let mailUrl = NSURL(string: "mailto:" + email)!
    UIApplication.sharedApplication().openURL(mailUrl)
  }
  
}