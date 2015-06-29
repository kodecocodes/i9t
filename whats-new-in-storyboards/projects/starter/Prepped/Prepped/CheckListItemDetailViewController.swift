//
//  CheckListDetailViewController.swift
//  Prepped
//
//  Created by Caroline Begbie on 25/06/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class CheckListItemDetailViewController: UITableViewController {
  
  @IBOutlet var checkListDescription: UITextField!
  @IBOutlet var checkListNotes: UITextView!
  
  override func viewDidLoad() {
    checkListDescription.becomeFirstResponder()
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == 0 {
      checkListDescription.becomeFirstResponder()
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    checkListDescription.resignFirstResponder()
  }
}
