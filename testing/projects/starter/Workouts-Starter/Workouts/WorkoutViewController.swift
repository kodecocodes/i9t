/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

private let addWorkoutIndex = 0
private let addNewIdentifier = "AddNewWorkoutCell"
private let workoutIdentifier = "WorkoutCell"
private let toWorkoutDetailIdentifier = "toWorkoutDetailViewController"
private let toAddWorkoutIdentifier = "toAddWorkoutViewController"

class WorkoutViewController: UIViewController {
  
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
    
    updateEditButtonVisibility()
    toggleEditMode(false)
    
    tableView.reloadData()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == toAddWorkoutIdentifier {
      let destinationViewController = segue.destinationViewController as! AddWorkoutViewController
      destinationViewController.dataModel = dataModel
    } else if segue.identifier == toWorkoutDetailIdentifier {
      let indexPath = sender as! NSIndexPath
      let destinationViewController = segue.destinationViewController as! WorkoutDetailViewController
      destinationViewController.workout = dataModel.allWorkouts[indexPath.row - 1]
    }
  }
  
  @IBAction func editButtonTapped(sender: UIBarButtonItem) {
    toggleEditMode(!tableView.editing)
  }
  
  private func toggleEditMode(editing: Bool) {
    tableView.setEditing(editing, animated: true)
    editButton.title = editing ? "Done" : "Edit"
  }
  
  private func updateEditButtonVisibility() {
    editButton.enabled = dataModel.containsUserCreatedWorkout
  }
}

extension WorkoutViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataModel.allWorkouts.count + 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    
    if indexPath.row == addWorkoutIndex {
      cell = tableView.dequeueReusableCellWithIdentifier(addNewIdentifier)!
    } else {
      let workout = dataModel.allWorkouts[indexPath.row - 1]
      cell = tableView.dequeueReusableCellWithIdentifier(workoutIdentifier)!
      (cell as! WorkoutCell).populate(workout)
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    if indexPath.row == addWorkoutIndex {
      return false
    } else {
      return dataModel.allWorkouts[indexPath.row - 1].canEdit
    }
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      dataModel.removeWorkoutAtIndex(indexPath.row - 1)
      
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      updateEditButtonVisibility()
    }
  }
  
}

extension WorkoutViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.row == addWorkoutIndex {
      performSegueWithIdentifier(toAddWorkoutIdentifier, sender: nil)
    } else {
      performSegueWithIdentifier(toWorkoutDetailIdentifier, sender: indexPath)
    }
  }
}
