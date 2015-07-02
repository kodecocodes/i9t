//
//  MapContentTableViewController.swift
//  Topo
//
//  Created by Derek Selander on 7/1/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

class MapContentTableViewController: UITableViewController {
  
  let dataSource: [TopoMapOverlayData] = TopoMapOverlayData.generateDefaultData()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }
  
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.dataSource.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MapOverlayCell", forIndexPath: indexPath)
    
    let mapData = self.dataSource[indexPath.row]
    let title = mapData.title
    cell.textLabel?.text = title
    cell.imageView?.image = UIImage(named: mapData.thumbnailImageTitle)
    cell.detailTextLabel?.text = "\(mapData.year)"
    
    return cell
  }
  
//  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    
//    guard let indexPath = tableView.indexPathForSelectedRow else {
//      return
//    }
//    
//  }
  
  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return false if you do not want the specified item to be editable.
  return true
  }
  */
  
  /*
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  if editingStyle == .Delete {
  // Delete the row from the data source
  tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
  } else if editingStyle == .Insert {
  // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
  }
  }
  */
  
  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
  
  }
  */
  
  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return NO if you do not want the item to be re-orderable.
  return true
  }
  */
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let nav = segue.destinationViewController as? UINavigationController,
      let indexPath = self.tableView.indexPathForSelectedRow
    {
    
        let mapData = self.dataSource[indexPath.row]
        nav.topViewController?.title = mapData.title
    }
  }
  
}
