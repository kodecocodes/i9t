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
import UIKit

class Exercise : NSObject {
  
  var userCreated = false
  var name: String!
  var photoFileName: String!
  var instructions: String!
  var duration: NSTimeInterval! //readonly
  
  var canEdit: Bool {
    return userCreated
  }
    
  var canRemove: Bool {
    return userCreated
  }
  
  var thumbnail: UIImage? {
    return resizeImageWithSize(CGSizeMake(50, 50))
  }
  
  //MARK - Helper methods
  
  private func resizeImageWithSize(size: CGSize) ->  UIImage? {
    
    if let image = UIImage(named: photoFileName) {
      UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
      image.drawInRect(CGRectMake(0, 0, size.width, size.height))
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return newImage
    }
    
    return nil
  }
  
}