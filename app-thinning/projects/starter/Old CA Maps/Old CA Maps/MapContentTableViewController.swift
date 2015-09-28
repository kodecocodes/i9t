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

class MapContentTableViewController: UITableViewController {
  
  let dataSource: [HistoricMapOverlayData] = HistoricMapOverlayData.generateDefaultData()
  
//=============================================================================/
// Mark: Lifetime 
//=============================================================================/
  
  override func viewDidLoad() {
    super.viewDidLoad()
    clearsSelectionOnViewWillAppear = false
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.barTintColor = UIColor(red: 150/255, green: 125/255, blue: 179/255, alpha: 1.0)
    navigationController?.navigationBar.translucent = true
    navigationController?.navigationBar.alpha = 1
    navigationController?.navigationBar.titleTextAttributes = nil 

  }
  
//=============================================================================/
// Mark: UITableViewDataSource
//=============================================================================/
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MapOverlayCell", forIndexPath: indexPath)
    
    let mapData = dataSource[indexPath.row]
    let title = mapData.title
    cell.textLabel?.text = title
    cell.imageView?.image = UIImage(named: mapData.thumbnailImageTitle)
    cell.detailTextLabel?.text = "\(mapData.year)"
    
    return cell
  }

//=============================================================================/
// Mark: Storyboard Logic
//=============================================================================/
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let nav = segue.destinationViewController as? UINavigationController,
      let indexPath = tableView.indexPathForSelectedRow {
        let mapData = dataSource[indexPath.row]
        let mapViewController = nav.topViewController as! MapChromeViewController
        mapViewController.mapOverlayData = mapData
        mapViewController.title = mapData.title
    }
  }
}
