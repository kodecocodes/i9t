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
  
  func workoutInfoCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
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
      restIntervalTextField.accessibilityIdentifier = "Rest Interval Text Field"
    }
    
    return cell
  }
  
}

extension AddWorkoutViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch (section) {
    case 0:
      return "Workout Info"
    case 1:
      return "Add Exercises"
    default:
      return nil
    }
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
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
      assertionFailure("Unhandled cell index path")
      cell = tableView.dequeueReusableCellWithIdentifier(exerciseCellIdentifier)!
    }
    
    return cell
  }
  
}
