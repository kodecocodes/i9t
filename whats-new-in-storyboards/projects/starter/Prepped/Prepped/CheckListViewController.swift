//
//  CheckListViewController.swift
//  Prepped
//
//  Created by Caroline Begbie on 25/06/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController {
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return checkListData.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CheckListCell", forIndexPath: indexPath)
    cell.textLabel?.text = checkListData[indexPath.row]
    return cell
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "CheckListItem" {
      if let  cell = sender as? UITableViewCell,
              controller = segue.destinationViewController as? CheckListItemViewController,
              indexPath = self.tableView.indexPathForCell(cell) {
        controller.checkListIndex = indexPath.row
        controller.itemArray = checkListItemData[indexPath.row]
      }
    }
  }
  
  @IBAction func cancelToCheckListViewController(segue: UIStoryboardSegue) {
    
  }
  
  @IBAction func saveToCheckListViewController(segue: UIStoryboardSegue) {
    if let  controller = segue.sourceViewController as? CheckListDetailViewController,
            text = controller.checkList.text {
      checkListData.append(text)
      checkListItemData.append([])
      let indexPath = NSIndexPath(forRow: checkListData.count-1, inSection: 0)
      self.tableView.beginUpdates()
      self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
      self.tableView.endUpdates()
    }
  }
  
}
