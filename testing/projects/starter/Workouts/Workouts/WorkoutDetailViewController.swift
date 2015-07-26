//
//  WorkoutDetailViewController.swift
//  Workouts
//
//  Created by Pietro Rea on 7/26/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

let workoutInfoIdentifier = "WorkoutInfoCell"
let workoutExerciseIdentifier = "WorkoutExerciseCell"
let workoutSelectIdentifier = "WorkoutSelectCell"

class WorkoutDetailViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var workout: Workout!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = workout.name
  }
  
  //MARK - UITableViewDataSource / UITableViewDelegate
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
  {
    switch (section) {
    case 0:
      return "Workout Info"
    case 1:
      return "Exercises"
    default:
      return nil
    }
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 3
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    var numRows: Int
    
    switch (section) {
    case 0:
      numRows = 4
    case 1:
      numRows = workout.exercises.count
    case 2:
      numRows = 1
    default:
      numRows = 0
    }
    
    return numRows
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell: UITableViewCell
    
    switch (indexPath.section) {
    case 0:
      cell = workoutInfoCellForRowAtIndexPath(indexPath)
    case 1:
      let exercise =  workout.exercises[indexPath.row]
      cell = tableView.dequeueReusableCellWithIdentifier(workoutExerciseIdentifier)!
      let exerciseCell = cell as! ExerciseCell
      exerciseCell.exerciseName.text = exercise.name
      exerciseCell.exerciseImageView.image = UIImage(named: exercise.photoFileName)
    case 2:
      cell = tableView.dequeueReusableCellWithIdentifier(workoutSelectIdentifier)!
    default:
      cell = tableView.dequeueReusableCellWithIdentifier(workoutSelectIdentifier)!
      print("Add assertion here")
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    
  }
  
  // MARK - Helper methods
  
  func workoutInfoCellForRowAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier(workoutInfoIdentifier)!
    
    switch (indexPath.row) {
    case 0:
      cell.textLabel!.text = "Name"
      cell.detailTextLabel!.text = workout.name
    case 1:
      cell.textLabel!.text = "# Exercises"
      cell.detailTextLabel!.text = "\(workout.exercises.count) workouts"
    case 2:
      cell.textLabel!.text = "Duration"
      cell.detailTextLabel!.text = "\(workout.duration) seconds"
    case 3:
      cell.textLabel!.text = "Rest Interval"
      cell.detailTextLabel!.text = "\(workout.restInterval) seconds"
    default:
      print("Default, do sometehing")
    }

    return cell
  }
  
}
