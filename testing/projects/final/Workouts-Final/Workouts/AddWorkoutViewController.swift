//
//  AddWorkoutViewController.swift
//  Workouts
//
//  Created by Pietro Rea on 7/27/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

private let infoCellIdentifier = "AddWorkoutInfoCell"
private let exerciseCellIdentifier = "AddWorkoutExerciseCell"

class AddWorkoutViewController: UIViewController {
  
  var nameTextField: UITextField!
  var restIntervalTextField: UITextField!
  var dataModel: DataModel!
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    
    
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
  {
    switch (section) {
    case 0:
      return "Workout Info"
    case 1:
      return "Add Exercises"
    default:
      return nil
    }
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if section == 0 {
      return 2
    } else {
      return dataModel.exercises.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell: UITableViewCell
    
    switch (indexPath.section) {
    case 0:
      cell = workoutInfoCellForIndexPath(indexPath)
    case 1:
      let exercise =  dataModel.exercises[indexPath.row]
      cell = tableView.dequeueReusableCellWithIdentifier(exerciseCellIdentifier)!
      let exerciseCell = cell as! AddWorkoutExerciseCell
      exerciseCell.textLabel!.text = exercise.name
    default:
      cell = tableView.dequeueReusableCellWithIdentifier(exerciseCellIdentifier)!
      print("Add assertion here")
    }
    
    return cell
  }
  
  @IBAction func saveButtonTapped(sender: AnyObject) {
    
    let workout = Workout()
    workout.userCreated = true
    workout.name = nameTextField.text
    workout.restInterval = Double(restIntervalTextField.text!)!
    
    let seletedIndexPaths = tableView.indexPathsForSelectedRows
    if let indexPaths = seletedIndexPaths {
      for indexPath in indexPaths {
        workout.addExercise(dataModel.exercises[indexPath.row])
      }
    }
    
    dataModel.addWorkout(workout)
    dataModel.save()
    navigationController?.popViewControllerAnimated(true)
  }
  
  // MARK - Helper methods
  
  func workoutInfoCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier(infoCellIdentifier) as! AddWorkoutInfoCell
    cell.selectionStyle = .None
    
    if indexPath.row == 0 {
      cell.infoLabel.text = "Name"
      cell.infoTextField.placeholder = "Workout name"
      nameTextField = cell.infoTextField
      nameTextField.accessibilityIdentifier = "Workout Name Text Field"
    } else {
      cell.infoLabel.text = "Rest Interval"
      cell.infoTextField.placeholder = "e.g. 30"
      cell.infoTextField.keyboardType = .NumberPad
      restIntervalTextField = cell.infoTextField
      restIntervalTextField.accessibilityIdentifier = "Duration Text Field"
    }
    
    return cell
  }
  
}
