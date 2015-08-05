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

class ChecklistItemTableViewCell: UITableViewCell {
  
  @IBOutlet var checkMarkLabel: UILabel!
  @IBOutlet var itemNameLabel: UILabel!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet var checkBox: CheckBox!

  var checklistItem: ChecklistItem! {
    didSet {
      itemNameLabel.text = checklistItem.name
      checked = checklistItem.checked
    }
  }
  
  var checked = false {
    didSet {
      checkBox.checked = checked
      checkBox.setNeedsDisplay()
    }
  }
  
  override func awakeFromNib() {
    let recognizer = UITapGestureRecognizer(target: self, action: "checkMarkTapped:")
    checkBox.addGestureRecognizer(recognizer)
  }
  
  func checkMarkTapped(gesture: UITapGestureRecognizer) {
    checked = !checked
    checklistItem.checked = checked
  }
}

class CheckBox: UIView {
  let lineWidth: CGFloat = 2.0
  let cornerRadius: CGFloat = 6.0

  var checked: Bool = false
  var isNotes: Bool = false
  
  // Border Colors
  let borderUnchecked = UIColor(white: 222/255, alpha: 1.0)
  let borderChecked = UIColor(red: 142/255, green: 226/255, blue: 165/255, alpha: 1.0)
  let borderNotes = UIColor(red: 241/255, green: 226/255, blue: 164/255, alpha: 1.0)
  
  // Background Colors
  let backgroundUnchecked = UIColor(white: 247/255, alpha: 1.0)
  let backgroundChecked = UIColor(red: 223/255, green: 247/255, blue: 230/255, alpha: 1.0)
  let backgroundNotes = UIColor(red: 255/255, green: 246/255, blue: 213/255, alpha: 1.0)
  
  // Image
  let checkmarkImage = UIImage(named: "Checkmark")!
  let checkmarkImageNotes = UIImage(named: "CheckmarkNotes")
  
  var checkmarkImageView = UIImageView()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.addSubview(checkmarkImageView)
    checkmarkImageView.frame = self.bounds
    checkmarkImageView.contentMode = UIViewContentMode.Center
  }
  
  override func drawRect(rect: CGRect) {
    let path = UIBezierPath(roundedRect: CGRectInset(rect, lineWidth/2, lineWidth/2), cornerRadius: cornerRadius)
    path.lineWidth = lineWidth
    if isNotes {
      borderNotes.setStroke()
      backgroundNotes.setFill()
      checkmarkImageView.image = checked ? checkmarkImageNotes : nil
    } else if checked {
      borderChecked.setStroke()
      backgroundChecked.setFill()
      checkmarkImageView.image = checkmarkImage
    } else {
      borderUnchecked.setStroke()
      backgroundUnchecked.setFill()
      checkmarkImageView.image = nil
    }
    path.fill()
    path.stroke()
  
  }

  

}