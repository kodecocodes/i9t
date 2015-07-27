//
//  WorkoutViewController.swift
//  Workouts
//
//  Created by Pietro Rea on 7/22/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import UIKit

private let addWorkoutIndex = 0
private let addNewIdentifier = "AddNewWorkoutCell"
private let workoutIdentifier = "WorkoutCell"
private let toWorkoutDetailIdentifier = "toWorkoutDetailViewController"
private let toAddWorkoutIdentifier = "toAddWorkoutViewController"

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
    
    tableView.reloadData()
    toggleEditMode(false)
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
    if indexPath.row == addWorkoutIndex {
      performSegueWithIdentifier(toAddWorkoutIdentifier, sender: nil)
    } else {
      performSegueWithIdentifier(toWorkoutDetailIdentifier, sender: indexPath)
    }
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
  {
    if indexPath.row == addWorkoutIndex {
      return false
    } else {
      return dataModel.workouts[indexPath.row - 1].canEdit
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == toAddWorkoutIdentifier {
      let destinationViewController = segue.destinationViewController as! AddWorkoutViewController
      destinationViewController.dataModel = dataModel
    } else if segue.identifier == toWorkoutDetailIdentifier {
      let indexPath = sender as! NSIndexPath
      let destinationViewController = segue.destinationViewController as! WorkoutDetailViewController
      destinationViewController.workout = dataModel.workouts[indexPath.row - 1]
    }
  }
  
  @IBAction func editButtonTapped(sender: UIBarButtonItem) {
    
    toggleEditMode(!tableView.editing)
  }
  
  private func toggleEditMode(editing: Bool)
  {
    tableView.setEditing(editing, animated: true)
    editButton.title = editing ? "Done" : "Edit"
  }
  
}
