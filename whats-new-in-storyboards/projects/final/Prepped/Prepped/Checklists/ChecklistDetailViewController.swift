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

class ChecklistDetailViewController: UITableViewController {
  
  let notesViewHeight: CGFloat = 128.0
  
  var checklist = checklists.first!
  
  @IBOutlet var notesView: UIView!
  @IBOutlet weak var notesTextView: UITextView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = checklist.title
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 64.0
    
    navigationItem.rightBarButtonItems![1] = editButtonItem()
  }
  
  // MARK: - Unwind segue methods
  
  @IBAction func cancelToChecklistDetailViewController(segue: UIStoryboardSegue) {
  }
  
  @IBAction func saveToChecklistDetailViewController(segue: UIStoryboardSegue) {
    if let controller = segue.sourceViewController as? AddChecklistItemViewController,
      item = controller.checklistItem {
        checklist.items.append(item)
        
        tableView.beginUpdates()
        let indexPath = NSIndexPath(forRow: checklist.items.count - 1, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
        tableView.endUpdates()
    }
  }
  
  func addNotesViewToCell(cell: ChecklistItemTableViewCell) {
    notesView.heightAnchor
      .constraintEqualToConstant(notesViewHeight)
      .active = true
    notesView.clipsToBounds = true
    
    cell.stackView.addArrangedSubview(notesView)
  }
  
  func removeNotesView() {
    if let stackView = notesView.superview as? UIStackView {
      stackView.removeArrangedSubview(notesView)
      notesView.removeFromSuperview()
    }
  }
}

// MARK: - UITableViewDelegate
extension ChecklistDetailViewController {
  override func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
    if let selected = tableView.indexPathForSelectedRow where selected == indexPath {
      self.tableView(tableView, didSelectRowAtIndexPath: indexPath)
    }
  }
  
  override func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      // 1
      guard let cell = tableView.cellForRowAtIndexPath(indexPath) as?
        ChecklistItemTableViewCell else {
          return
      }
      
      // 2
      tableView.beginUpdates()
      // 3
      if cell.stackView.arrangedSubviews.contains(notesView) {
        removeNotesView()
      } else {
        addNotesViewToCell(cell)
        
        // 4
        notesTextView.text = checklist.items[indexPath.row].notes
      }
      
      // 5
      tableView.endUpdates()
  }
}

// MARK: - UITableViewDataSource
extension ChecklistDetailViewController {
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return checklist.items.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItemCell", forIndexPath: indexPath) as! ChecklistItemTableViewCell
    
    let checklistItem = checklist.items[indexPath.row]
    cell.checklistItem = checklistItem
    
    return cell
  }
  
  override func tableView(tableView: UITableView,
    commitEditingStyle editingStyle: UITableViewCellEditingStyle,
    forRowAtIndexPath indexPath: NSIndexPath) {
      if editingStyle == .Delete {
        removeNotesView()
        
        checklist.items.removeAtIndex(indexPath.row)
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      }
  }
}
