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

private let toExerciseImageIdentifier = "toExerciseImageViewController"

class ExerciseDetailViewController: UITableViewController {
  
  var exercise: Exercise!
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var exerciseImageView: UIImageView!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var instructionsLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = exercise.name
    
    nameLabel.text = exercise.name
    exerciseImageView.image = exercise.thumbnail
    durationLabel.text = "\(Int(exercise.duration)) seconds"
    instructionsLabel.text = exercise.instructions
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    if indexPath.section == 0 && indexPath.row == 2 {
      performSegueWithIdentifier(toExerciseImageIdentifier, sender: nil)
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == toExerciseImageIdentifier {
      let photoVC = segue.destinationViewController as! ExerciseImageViewController
      photoVC.exercise = exercise
    }
  }
}
