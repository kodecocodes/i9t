//
//  CheckListViewController.swift
//  Prepped
//
//  Created by Caroline Begbie on 23/06/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class CheckListItemViewController: UITableViewController {
  
  
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
  
}

extension CheckListItemViewController: CheckListTableViewCellDelegate {
  func cellCheckMarkTapped(cell: UITableViewCell, checked: Bool) {
    if let indexPath = tableView.indexPathForCell(cell) {
      itemArray[indexPath.row].checked = checked
      checkListItemData[checkListIndex][indexPath.row].checked = checked
    }
  }
}
