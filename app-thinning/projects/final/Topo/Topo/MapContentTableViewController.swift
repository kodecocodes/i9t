//
//  MapContentTableViewController.swift
//  Topo
//
//  Created by Derek Selander on 7/1/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

class MapContentTableViewController: UITableViewController {
  
  let dataSource: [HistoricMapOverlayData] = HistoricMapOverlayData.generateDefaultData()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.clearsSelectionOnViewWillAppear = false
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
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let nav = segue.destinationViewController as? UINavigationController,
      let indexPath = self.tableView.indexPathForSelectedRow {
        let mapData = self.dataSource[indexPath.row]
        let mapViewController = nav.topViewController as! MapChromeViewController
        mapViewController.mapOverlayData = mapData
        mapViewController.title = mapData.title
    }
  }
}
