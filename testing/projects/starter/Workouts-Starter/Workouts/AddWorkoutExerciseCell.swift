//
//  AddWorkoutExerciseCell.swift
//  Workouts
//
//  Created by Pietro Rea on 7/27/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

class AddWorkoutExerciseCell: UITableViewCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if selected {
      accessoryType = .Checkmark
    } else {
      accessoryType = .None
    }
  }
  
}
