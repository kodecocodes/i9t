//
//  ExerciseDetailViewController.swift
//  Workouts
//
//  Created by Pietro Rea on 7/22/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import UIKit

class ExerciseDetailViewController: UITableViewController {

  var exercise: Exercise!

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var exerciseImageView: UIImageView!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var instructionsLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = exercise.name
    
    nameLabel.text = exercise.name
    exerciseImageView.image = UIImage(named: exercise.photoFileName)
    durationLabel.text = "\(exercise.duration) seconds"
    instructionsLabel.text = exercise.instructions
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    
  }
  
}
