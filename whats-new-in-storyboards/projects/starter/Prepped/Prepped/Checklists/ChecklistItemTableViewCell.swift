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
  
  @IBOutlet var itemNameLabel: UILabel!
  @IBOutlet var stackView: UIStackView!
  @IBOutlet var checkBox: CheckBox!
  
  var checklistItem: ChecklistItem! {
    didSet {
      itemNameLabel.text = checklistItem.name
      checkBox.checked = checklistItem.checked
    }
  }
  
  override func awakeFromNib() {
    let recognizer = UITapGestureRecognizer(target: self, action: "checkMarkTapped:")
    checkBox.addGestureRecognizer(recognizer)
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    checkBox.selected = selected
  }
  
  override func setHighlighted(highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    checkBox.selected = highlighted
  }
  
  func checkMarkTapped(gesture: UITapGestureRecognizer) {
    let checked = !checkBox.checked
    
    checkBox.checked = checked
    checklistItem.checked = checked
  }
}

@IBDesignable
class CheckBox: UIView {
  
  var checked = false {
    didSet {
      updateAppearance()
    }
  }
  
  var selected = false {
    didSet {
      updateAppearance()
    }
  }
  
  var checkmarkImageView: UIImageView!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    commonInit()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    commonInit()
  }
  
  func commonInit() {
    checkmarkImageView = UIImageView(image: UIImage(named: "Checkmark"))
    checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(checkmarkImageView)
    
    checkmarkImageView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
    checkmarkImageView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
    
    layer.borderWidth = 2.0
    layer.cornerRadius = 6.0
  }
  
  override func prepareForInterfaceBuilder() {
    checked = false
  }
  
  func updateAppearance() {
    if selected {
      layer.borderColor = UIColor(red: 241/255, green: 226/255, blue: 164/255, alpha: 1.0).CGColor
      checkmarkImageView.tintColor = UIColor.primaryAmberColor()
      backgroundColor = UIColor(red: 255/255, green: 246/255, blue: 213/255, alpha: 1.0)
    } else if checked {
      layer.borderColor = UIColor(red: 142/255, green: 226/255, blue: 165/255, alpha: 1.0).CGColor
      checkmarkImageView.tintColor = UIColor.primaryGreenColor()
      backgroundColor = UIColor(red: 223/255, green: 247/255, blue: 230/255, alpha: 1.0)
    } else {
      layer.borderColor = UIColor(white: 222/255, alpha: 1.0).CGColor
      backgroundColor = UIColor(white: 247/255, alpha: 1.0)
    }
    
    checkmarkImageView.hidden = !checked
  }
  
  override func intrinsicContentSize() -> CGSize {
    return CGSize(width: 30.0, height: 30.0)
  }
}

// Allows multi-line labels in cells to wrap correctly,
// by setting their preferredMaxLayoutWidth whenever their bounds change.
class SelfSizingLabel: UILabel {
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if preferredMaxLayoutWidth != bounds.width {
      preferredMaxLayoutWidth = bounds.width - 1
      setNeedsUpdateConstraints()
    }
  }
}
