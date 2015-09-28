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
    tableView.accessibilityIdentifier = "Workout Detail Table"
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
  }
  
  // MARK - Helper methods
  
  func workoutInfoCellForRowAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
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
      assertionFailure("Unhandled index path")
    }
    
    return cell
  }
  
  func workoutSelectButtonCell() -> WorkoutButtonCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(workoutSelectIdentifier) as! WorkoutButtonCell
    cell.selectButton.addTarget(self, action: "selectButtonTapped:", forControlEvents: .TouchUpInside)
    return cell
  }
  
  func selectButtonTapped(sender: AnyObject) {
    let timesPlural = (workout.workoutCount == 1) ? "time" : "times"
    
    let message = (workout.workoutCount == 0) ?
      "This is your first time doing this workout." :
      "You've done this workout \(workout.workoutCount) \(timesPlural)."
    
    let alert = UIAlertController(title: "Woo hoo! You worked out!",
      message: message,
      preferredStyle: UIAlertControllerStyle.Alert)
    
    let cancelAction = UIAlertAction(title: "Cancel",
      style: .Default, handler: nil)
    
    let saveAction = UIAlertAction(title: "OK",
      style: .Default) { action in
        self.workout.performWorkout()
    }
    
    alert.addAction(cancelAction)
    alert.addAction(saveAction)
    
    self.presentViewController(alert,
      animated: true,
      completion: nil)
  }
}

extension WorkoutDetailViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch (section) {
    case 0:
      return "Workout Info"
    case 1:
      return "Exercises"
    default:
      return nil
    }
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch (section) {
    case 0:
      return 4
    case 1:
      return workout.exercises.count
    case 2:
      return 1
    default:
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    
    switch (indexPath.section) {
    case 0:
      cell = workoutInfoCellForRowAtIndexPath(indexPath)
    case 1:
      let exercise =  workout.exercises[indexPath.row]
      cell = tableView.dequeueReusableCellWithIdentifier(workoutExerciseIdentifier)!

      (cell as! ExerciseCell).populate(exercise)
    case 2:
      cell = workoutSelectButtonCell()
    default:
      assertionFailure("Unhandled cell index path")
      cell = tableView.dequeueReusableCellWithIdentifier(workoutSelectIdentifier)!
    }
    
    return cell
  }
}

extension WorkoutDetailViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == 1 {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewControllerWithIdentifier(exerciseDetailIdentifier) as! ExerciseDetailViewController
      vc.exercise = workout.exercises[indexPath.row]
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}
