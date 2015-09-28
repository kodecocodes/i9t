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

public struct Employee: JSONDecodable {
  public let objectId: String
  public let department: String
  public let email: String
  public let name: String
  public let phone: String
  public let title: String
  public let skills: [String]
  
  public init(json: [NSObject: AnyObject]) throws {
    guard let objectId = json["objectId"] as? String else {
      throw JSONDecodingError.MissingAttribute("objectId")
    }
    guard let department = json["department"] as? String else {
      throw JSONDecodingError.MissingAttribute("department")
    }
    guard let email = json["email"] as? String else {
      throw JSONDecodingError.MissingAttribute("email")
    }
    guard let name = json["name"] as? String else {
      throw JSONDecodingError.MissingAttribute("name")
    }
    guard let phone = json["phone"] as? String else {
      throw JSONDecodingError.MissingAttribute("phone")
    }
    guard let title = json["title"] as? String else {
      throw JSONDecodingError.MissingAttribute("title")
    }
    guard let skills = json["skills"] as? [String] else {
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
    let splits = email.componentsSeparatedByString("@")
    if let filename = splits.first {
      return UIImage(named: filename + ".jpg", inBundle: FileHelper.bundle, compatibleWithTraitCollection: nil) ?? UIImage()
    } else {
      return UIImage()
    }
  }
  
  public func loadSmallPicture() -> UIImage {
    let fullImage = loadPicture()
    let size = CGSize(width: 40, height: 40)
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    fullImage.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let smallImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return smallImage
  }
  
}