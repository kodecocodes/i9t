//
//  ExerciseViewController.swift
//  Workouts
//
//  Created by Pietro Rea on 7/22/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import UIKit

let addExerciseIndex = 0
let exerciseIdentifier = "ExerciseCell"
let addExerciseNewIdentifier = "AddNewExerciseCell"
let toDetailSegue = "toExerciseDetailViewController"

class ExerciseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
    return dataModel.exercises.count + 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell: UITableViewCell
    
    if indexPath.row == addExerciseIndex {
      cell = tableView.dequeueReusableCellWithIdentifier(addExerciseNewIdentifier)!
    } else {
      let exercise = dataModel.exercises[indexPath.row - 1]
      let exerciseCell = tableView.dequeueReusableCellWithIdentifier(exerciseIdentifier) as! ExerciseCell
      exerciseCell.exerciseImageView.image = exercise.thumbnail
      exerciseCell.exerciseName.text = exercise.name
      return exerciseCell
    }
    
    return cell

  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    performSegueWithIdentifier(toDetailSegue, sender: indexPath)
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
  {
    if indexPath.row == addWorkoutIndex {
      return false
    } else {
      return dataModel.exercises[indexPath.row - 1].canRemove
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   
    if segue.identifier == toDetailSegue {
      let indexPath = sender as! NSIndexPath
      let detailViewController = segue.destinationViewController as! ExerciseDetailViewController
      detailViewController.exercise = dataModel.exercises[indexPath.row - 1]
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
