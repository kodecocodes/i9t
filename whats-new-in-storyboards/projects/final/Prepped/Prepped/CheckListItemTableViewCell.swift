//
//  CheckListTableViewCell.swift
//  Prepped
//
//  Created by Caroline Begbie on 25/06/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

protocol CheckListTableViewCellDelegate {
  func cellCheckMarkTapped(cell:UITableViewCell, checked:Bool)
}

class CheckListTableViewCell: UITableViewCell {
  
  var delegate:CheckListTableViewCellDelegate? = nil
  var checked = false {
    didSet {
      checkMark.text = checked ? CheckMark : " "
    }
  }
  @IBOutlet var checkMark: UILabel!
  @IBOutlet var lblListText: UILabel!
  
  override func awakeFromNib() {
    let tap = UITapGestureRecognizer(target: self, action: "checkMarkTapped:")
    self.checkMark.addGestureRecognizer(tap)
  }
  
  func checkMarkTapped(gesture: UITapGestureRecognizer) {
    checked = !checked
    delegate?.cellCheckMarkTapped(self, checked: checked)
  }
}
