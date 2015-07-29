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
private let exerciseIdentifier = "ExerciseCell"
private let addExerciseNewIdentifier = "AddNewExerciseCell"
private let toDetailSegue = "toExerciseDetailViewController"

class ExerciseViewController: UIViewController {
  
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
  }

  func createUserExercise() {
    let alert = UIAlertController(title: "Add New Exercise",
      message: "Add a new exercise below",
      preferredStyle: UIAlertControllerStyle.Alert)
    
    let cancelAction = UIAlertAction(title: "Cancel",
      style: .Default,
      handler: { (action: UIAlertAction!) in
    })
    
    let saveAction = UIAlertAction(title: "Save",
      style: .Default,
      handler: { (action: UIAlertAction!) in
        
        let nameTextField = alert.textFields![0] as UITextField
        let durationTextField = alert.textFields![1] as UITextField
        let instructionsTextField = alert.textFields![2] as UITextField
        
        let exercise = Exercise()
        exercise.userCreated = true
        exercise.name = nameTextField.text
        exercise.duration = Double(durationTextField.text!)
        exercise.instructions = instructionsTextField.text
        
        //create default
        exercise.photoFileName = "squat"
        
        self.dataModel.addExercise(exercise)
        self.dataModel.save()
        self.updateEditButtonVisibility()
        
        self.tableView.reloadData()
    })
    
    alert.addTextFieldWithConfigurationHandler {
      (textField: UITextField!) in
      textField.placeholder = "Name"
    }
    
    alert.addTextFieldWithConfigurationHandler {
      (textField: UITextField!) in
      textField.keyboardType = .NumberPad
      textField.placeholder = "e.g. 30"
    }
    
    alert.addTextFieldWithConfigurationHandler {
      (textField: UITextField!) in
      textField.placeholder = "Instructions (Optional)"
    }
    
    alert.addAction(cancelAction)
    alert.addAction(saveAction)
    
    self.presentViewController(alert,
      animated: true,
      completion: nil)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == toDetailSegue {
      let indexPath = sender as! NSIndexPath
      let detailViewController = segue.destinationViewController as! ExerciseDetailViewController
      detailViewController.exercise = dataModel.exercises[indexPath.row - 1]
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
    editButton.enabled = dataModel.containsUserCreatedExercise()
  }
}

extension ExerciseViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataModel.exercises.count + 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell: UITableViewCell
    
    if indexPath.row == addWorkoutIndex {
      cell = tableView.dequeueReusableCellWithIdentifier(addExerciseNewIdentifier)!
    } else {
      let exercise = dataModel.exercises[indexPath.row - 1]
      let exerciseCell = tableView.dequeueReusableCellWithIdentifier(exerciseIdentifier) as! ExerciseCell
      exerciseCell.populate(exercise)
      return exerciseCell
    }
    
    return cell
  }

  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    if indexPath.row == addWorkoutIndex {
      return false
    } else {
      return dataModel.exercises[indexPath.row - 1].canRemove
    }
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      dataModel.exercises.removeAtIndex(indexPath.row - 1)
      dataModel.save()
      
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      updateEditButtonVisibility()
    }
  }
}

extension ExerciseViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.row == addWorkoutIndex {
      createUserExercise()
    } else {
      performSegueWithIdentifier(toDetailSegue, sender: indexPath)
    }
  }
}