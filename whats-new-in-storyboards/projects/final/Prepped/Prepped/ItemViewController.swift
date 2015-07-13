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

class ItemViewController: UITableViewController {
  
  let cellHeight:CGFloat = 64
  let cellPadding: CGFloat = 10
  
  
  @IBOutlet var notesView: UIView!
  @IBOutlet var notesTextView: UITextView!
  
  var checkListIndex:Int = 0
  var itemArray:[CheckListItem] = checkListItemData[0]

  var selectedIndexPath:NSIndexPath?
  
  override func viewDidLoad() {
    navigationItem.rightBarButtonItem = editButtonItem()
  }
  
  // MARK: - Unwind segue methods
  
  @IBAction func cancelToItemViewController(segue: UIStoryboardSegue) {
  }
  
  @IBAction func saveToItemViewController(segue: UIStoryboardSegue) {
    if let  controller = segue.sourceViewController as? ItemDetailViewController,
      text = controller.checkListDescription.text,
      notes = controller.checkListNotes.text {
        let checkListItem:CheckListItem = (text, false, notes)
        itemArray.append(checkListItem)
        checkListItemData[checkListIndex].append(checkListItem)
        let indexPath = NSIndexPath(forRow: itemArray.count-1, inSection: 0)
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
        tableView.endUpdates()
    }
  }
}

extension ItemViewController {
  // MARK: - Table view delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.beginUpdates()
    if selectedIndexPath == indexPath {
      selectedIndexPath = nil
      // remove notes view from cell
      notesView.removeFromSuperview()
    } else {
      selectedIndexPath = indexPath
      // add notes view to cell
      notesTextView.text = itemArray[indexPath.row].notes
      if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        notesView.frame.origin.x = cellPadding
        notesView.frame.origin.y = cellHeight
        cell.contentView.addSubview(notesView)
      }
    }
    tableView.endUpdates()
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if selectedIndexPath == indexPath {
      return cellHeight + cellPadding + notesView.bounds.height
    } else {
      return cellHeight
    }
  }
}

extension ItemViewController {
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ItemTableViewCell", forIndexPath: indexPath) as! ItemTableViewCell
    cell.delegate = self
    let checkListItem = itemArray[indexPath.row]
    cell.lblListText?.text = checkListItem.description
    cell.checked = checkListItem.checked
    return cell
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      // 1
      selectedIndexPath = nil
      // 2
      notesView.removeFromSuperview()
      // 3
      itemArray.removeAtIndex(indexPath.row)
      checkListItemData[checkListIndex].removeAtIndex(indexPath.row)
      // 4
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
  }
}

extension ItemViewController: ItemTableViewCellDelegate {
  func cellCheckMarkTapped(cell: UITableViewCell, checked: Bool) {
    if let indexPath = tableView.indexPathForCell(cell) {
      itemArray[indexPath.row].checked = checked
      checkListItemData[checkListIndex][indexPath.row].checked = checked
    }
  }
}
