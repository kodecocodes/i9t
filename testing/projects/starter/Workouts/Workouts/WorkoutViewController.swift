//
//  WorkoutViewController.swift
//  Workouts
//
//  Created by Pietro Rea on 7/22/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import UIKit

let addWorkoutIndex = 0
let addNewIdentifier = "AddNewWorkoutCell"
let workoutIdentifier = "WorkoutCell"
let toWorkoutDetailIdentifier = "toWorkoutDetailViewController"

class WorkoutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var editButton: UIBarButtonItem!
  @IBOutlet weak var tableView: UITableView!
  let dataModel = DataModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataModel.workouts.count + 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell: UITableViewCell
    
    if indexPath.row == addWorkoutIndex {
      cell = tableView.dequeueReusableCellWithIdentifier(addNewIdentifier)!
    } else {
      let workout = dataModel.workouts[indexPath.row - 1]
      cell = tableView.dequeueReusableCellWithIdentifier(workoutIdentifier)!
      cell.textLabel!.text = workout.name
      cell.detailTextLabel!.text = "\(workout.exercises.count) exercises"
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    performSegueWithIdentifier(toWorkoutDetailIdentifier, sender: indexPath)
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
  {
    if indexPath.row == addWorkoutIndex {
      return false
    } else {
      return dataModel.workouts[indexPath.row - 1].userCreated
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == toWorkoutDetailIdentifier {
      let indexPath = sender as! NSIndexPath
      let destinationViewController = segue.destinationViewController as! WorkoutDetailViewController
      destinationViewController.workout = dataModel.workouts[indexPath.row - 1]
    }
  }
  
  @IBAction func editButtonTapped(sender: UIBarButtonItem) {
    
    if tableView.editing {
      tableView .setEditing(false, animated: true)
      editButton.title = "Done"
    } else {
      tableView .setEditing(true, animated: true)
      editButton.title = "Edit"
    }
  }
  
}
