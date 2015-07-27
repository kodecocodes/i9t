//
//  WorkoutDetailViewController.swift
//  Workouts
//
//  Created by Pietro Rea on 7/26/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

private let workoutInfoIdentifier = "WorkoutInfoCell"
private let workoutExerciseIdentifier = "WorkoutExerciseCell"
private let workoutSelectIdentifier = "WorkoutSelectCell"

let exerciseDetailIdentifier = "ExerciseDetailViewController"

class WorkoutDetailViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var workout: Workout!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = workout.name
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
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
      exerciseCell.exerciseImageView.image = exercise.thumbnail
    case 2:
      cell = workoutSelectButtonCell()
    default:
      cell = tableView.dequeueReusableCellWithIdentifier(workoutSelectIdentifier)!
      print("Add assertion here")
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    if indexPath.section == 1 {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewControllerWithIdentifier(exerciseDetailIdentifier) as! ExerciseDetailViewController
      vc.exercise = workout.exercises[indexPath.row]
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  // MARK - Helper methods
  
  func workoutInfoCellForRowAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier(workoutInfoIdentifier)!
    cell.selectionStyle = .None
    
    switch (indexPath.row) {
    case 0:
      cell.textLabel!.text = "Name"
      cell.detailTextLabel!.text = workout.name
    case 1:
      cell.textLabel!.text = "# Exercises"
      cell.detailTextLabel!.text = "\(workout.exercises.count) workouts"
    case 2:
      cell.textLabel!.text = "Duration"
      cell.detailTextLabel!.text = "\(Int(workout.duration)) seconds"
    case 3:
      cell.textLabel!.text = "Rest Interval"
      cell.detailTextLabel!.text = "\(Int(workout.restInterval)) seconds"
    default:
      print("Default, do sometehing")
    }
    
    return cell
  }
  
  func workoutSelectButtonCell() -> WorkoutButtonCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier(workoutSelectIdentifier) as! WorkoutButtonCell
    cell.selectButton .addTarget(self, action: "selectButtonTapped:", forControlEvents: .TouchUpInside)
    return cell
  }
  
  func selectButtonTapped(sender: AnyObject)
  {
    let timesPlural = workout.workoutCount == 1 ? "time" : "times"
    
    let message = workout.workoutCount == 0 ?
      "This is your first time doing this workout." :
    "You've done this workout \(workout.workoutCount) \(timesPlural)."
    
    let alert = UIAlertController(title: "Woo Hoo! You worked out!",
      message: message,
      preferredStyle: UIAlertControllerStyle.Alert)
    
    let cancelAction = UIAlertAction(title: "Cancel",
      style: .Default,
      handler: { (action: UIAlertAction!) in
    })
    
    let saveAction = UIAlertAction(title: "Save",
      style: .Default,
      handler: { (action: UIAlertAction!) in
        self.workout.performWorkout()
    })
    
    alert.addAction(cancelAction)
    alert.addAction(saveAction)
    
    self.presentViewController(alert,
      animated: true,
      completion: nil)
  }
  
}
