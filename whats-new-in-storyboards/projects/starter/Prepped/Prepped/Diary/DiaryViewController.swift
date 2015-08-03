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

class DiaryViewController: UITableViewController {
  
  let CellPadding: CGFloat = 30.0

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 44.0
  }
  
  // MARK: - UITableViewDataSource

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return diaryEntries.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("DiaryCell", forIndexPath: indexPath) as! DiaryEntryTableViewCell
    
    cell.diaryEntry = diaryEntries[indexPath.row]

    return cell
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      diaryEntries.removeAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
  }
  
  //MARK: - Unwind Segue Methods
  
  @IBAction func cancelToDiaryViewController(segue: UIStoryboardSegue) {
  }
  
  @IBAction func saveToDiaryViewController(segue: UIStoryboardSegue) {
    if let controller = segue.sourceViewController as? AddDiaryEntryViewController,
      diaryEntry = controller.diaryEntry {
      
      diaryEntries.append(diaryEntry)
        
      let indexPath = NSIndexPath(forRow: diaryEntries.count - 1, inSection: 0)

      tableView.beginUpdates()
      tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
      tableView.endUpdates()
    }
  }
}

class DiaryEntryTableViewCell: UITableViewCell {
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var entryLabel: UILabel!
  
  var diaryEntry: DiaryEntry! {
    didSet {
      dateLabel.text = diaryEntry.date
      entryLabel.text = diaryEntry.text
    }
  }
}