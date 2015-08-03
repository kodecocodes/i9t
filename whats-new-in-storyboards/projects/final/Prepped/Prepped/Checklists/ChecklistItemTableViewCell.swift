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

let CheckMark = "✔️"

class ChecklistItemTableViewCell: UITableViewCell {
  
  @IBOutlet var checkMarkLabel: UILabel!
  @IBOutlet var itemNameLabel: UILabel!
  @IBOutlet weak var stackView: UIStackView!
  
  var checklistItem: ChecklistItem! {
    didSet {
      itemNameLabel.text = checklistItem.name
      checked = checklistItem.checked
    }
  }
  
  var checked = false {
    didSet {
      checkMarkLabel.text = checked ? CheckMark : " "
    }
  }
  
  override func awakeFromNib() {
    let recognizer = UITapGestureRecognizer(target: self, action: "checkMarkTapped:")
    checkMarkLabel.addGestureRecognizer(recognizer)
  }
  
  func checkMarkTapped(gesture: UITapGestureRecognizer) {
    checked = !checked
    checklistItem.checked = checked
  }
}

@IBDesignable
class BorderedView: UIView {
  
  @IBInspectable var borderColor = UIColor.darkGrayColor()
  @IBInspectable var lineWidth: CGFloat = 2.0
  @IBInspectable var cornerRadius: CGFloat = 5.0
  
  override func drawRect(rect: CGRect) {
    borderColor.setStroke()
    
    let path = UIBezierPath(roundedRect: CGRectInset(rect, lineWidth/2, lineWidth/2), cornerRadius: cornerRadius)
    path.lineWidth = lineWidth
    path.stroke()
  }
  
}
