//
//  ContactsViewController.swift
//  Prepped
//
//  Created by Caroline Begbie on 26/06/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class ContactsViewController: UITableViewController {
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contactsData.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ContactsCell", forIndexPath: indexPath)
    if let imageView = cell.contentView.viewWithTag(1) as? UIImageView {
      imageView.image = UIImage(named: contactsData[indexPath.row].imageName)
    }
    if let label = cell.contentView.viewWithTag(2) as? UILabel {
      label.text = contactsData[indexPath.row].description
    }
    return cell
  }
}
