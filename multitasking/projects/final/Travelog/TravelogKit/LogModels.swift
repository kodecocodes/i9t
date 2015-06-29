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

import UIKit

class BaseLog: NSObject, NSCoding {
  
  let date: NSDate
  
  init(date: NSDate) {
    self.date = date
    super.init()
  }
  
  // MARK: NSCoding
  
  required init?(coder aDecoder: NSCoder) {
    self.date = aDecoder.decodeObjectForKey("date") as! NSDate
    super.init()
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.date, forKey: "date")
  }
  
}

class TextLog: BaseLog {
  
  let text: String
  
  required init(text: String, date: NSDate) {
    self.text = text
    super.init(date: date)
  }
  
  // MARK: NSCoding
  
  required init?(coder aDecoder: NSCoder) {
    self.text = aDecoder.decodeObjectForKey("text") as! String
    super.init(coder: aDecoder)
  }
  
  override func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.text, forKey: "text")
    super.encodeWithCoder(aCoder)
  }
  
}

class ImageLog: BaseLog {
  
  let image: UIImage
  
  required init(image: UIImage, date: NSDate) {
    self.image = image
    super.init(date: date)
  }
  
  // MARK: NSCoding
  
  required init?(coder aDecoder: NSCoder) {
    self.image = aDecoder.decodeObjectForKey("image") as! UIImage
    super.init(coder: aDecoder)
  }
  
  override func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.image, forKey: "image")
    super.encodeWithCoder(aCoder)
  }
  
}