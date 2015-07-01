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

class CheckListItemViewController: UITableViewController {
  
  
  @IBOutlet var notesView: UIView!
  @IBOutlet var notesTextView: UITextView!
  
  var selectedIndexPath:NSIndexPath?
  let cellHeight:CGFloat = 64
  let cellPadding: CGFloat = 10
  
  var checkListIndex:Int = 0
  var itemArray = [CheckListItem]()
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CheckListItemCell", forIndexPath: indexPath) as! CheckListTableViewCell
    cell.delegate = self
    let checkListItem = itemArray[indexPath.row]
    cell.lblListText?.text = checkListItem.description
    cell.checked = checkListItem.checked
    return cell
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if selectedIndexPath == indexPath {
      return cellHeight + cellPadding + notesView.bounds.height
    }
    else {
      return cellHeight
    }
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.beginUpdates()
    if selectedIndexPath == indexPath {
      selectedIndexPath = nil
      notesView.removeFromSuperview()
    } else {
      selectedIndexPath = indexPath
      notesTextView.text = itemArray[indexPath.row].notes
      if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        notesView.frame.origin.x = cellPadding
        notesView.frame.origin.y = cellHeight
        cell.contentView.addSubview(notesView)
      }
    }
    tableView.endUpdates()
  }
  
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      selectedIndexPath = nil
      notesView.removeFromSuperview()
      itemArray.removeAtIndex(indexPath.row)
      checkListItemData[checkListIndex].removeAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
  }
  
  @IBAction func cancelToCheckListItemViewController(segue: UIStoryboardSegue) {
    
  }
  
  @IBAction func saveToCheckListItemViewController(segue: UIStoryboardSegue) {
    if let  controller = segue.sourceViewController as? CheckListItemDetailViewController,
            text = controller.checkListDescription.text,
            notes = controller.checkListNotes.text {
        let checkListItem:CheckListItem = (text, false, notes)
        itemArray.append(checkListItem)
        checkListItemData[checkListIndex].append(checkListItem)
        let indexPath = NSIndexPath(forRow: itemArray.count-1, inSection: 0)
        self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
        self.tableView.endUpdates()
    }
  }
  
  
  @IBAction func btnEdit(button:UIBarButtonItem) {
    if self.editing {
      button.title = "Edit"
      super.setEditing(false, animated: true)
    } else {
      button.title = "Done"
      super.setEditing(true, animated: true)
    }
    
  }
}

extension CheckListItemViewController: CheckListTableViewCellDelegate {
  func cellCheckMarkTapped(cell: UITableViewCell, checked: Bool) {
    if let indexPath = tableView.indexPathForCell(cell) {
      itemArray[indexPath.row].checked = checked
      checkListItemData[checkListIndex][indexPath.row].checked = checked
    }
  }
}
