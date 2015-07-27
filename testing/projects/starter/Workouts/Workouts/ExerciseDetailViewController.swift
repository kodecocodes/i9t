//
//  ExerciseDetailViewController.swift
//  Workouts
//
//  Created by Pietro Rea on 7/22/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import UIKit

private let toExerciseImageIdentifier = "toExerciseImageViewController"

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
    exerciseImageView.image = exercise.thumbnail
    durationLabel.text = "\(Int(exercise.duration)) seconds"
    instructionsLabel.text = exercise.instructions
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    if indexPath.section == 0 && indexPath.row == 2 {
      performSegueWithIdentifier(toExerciseImageIdentifier, sender: nil)
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == toExerciseImageIdentifier {
      let photoVC = segue.destinationViewController as! ExerciseImageViewController
      photoVC.exercise = exercise
    }
  }
}
