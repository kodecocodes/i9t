//
//  CheckListViewController.swift
//  Prepped
//
//  Created by Caroline Begbie on 23/06/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

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
        notesView.frame.origin.y = cellHeight + cellPadding
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
