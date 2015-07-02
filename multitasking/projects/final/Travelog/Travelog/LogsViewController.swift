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
import TravelogKit

class LogsViewController: UITableViewController, LogStoreObserver, UIAlertViewDelegate {
  
  @IBOutlet private var photoLibraryButton: UIBarButtonItem!
  @IBOutlet private var cameraButton: UIBarButtonItem!
  @IBOutlet private var addNoteButton: UIBarButtonItem!
  
  private var logs = [BaseLog]()
  private var selectedLog: BaseLog?
  
  // MARK: View Life Cycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    splitViewController?.preferredDisplayMode = .AllVisible
    splitViewController?.delegate = self
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.cellLayoutMarginsFollowReadableWidth = true
    LogStore.sharedStore.registerObserver(self)
    LogsSeed.preload()
  }
  
  // MARK: LogStoreObserver Protocol
  
  func logStore(store: LogStore, didUpdateLogCollection collection: LogCollection) {
    // Update our data source.
    logs = collection.sortedLogs(NSComparisonResult.OrderedAscending)
    tableView.reloadData()
  }
  
  // MARK: IBActions
  
  @IBAction func photoLibraryButtonTapped(sender: UIBarButtonItem?) {
    // Present detail view controller and forward the call.
    let vc = presentDetailViewControllerWithSelectedLog(nil)
    vc.photoLibraryButtonTapped(sender)
  }
  
  @IBAction func cameraButtonTapped(sender: UIBarButtonItem?) {
    // Present detail view controller and forward the call.
    let vc = presentDetailViewControllerWithSelectedLog(nil)
    vc.cameraButtonTapped(sender)
  }
  
  @IBAction func addNoteButtonTapped(sender: UIBarButtonItem?) {
    // Present detail view controller and forward the call.
    let vc = presentDetailViewControllerWithSelectedLog(nil)
    vc.addNoteButtonTapped(sender)
  }
  
  // MARK: Helper
  
  /// Create or reuse a Detail View Controller object.
  func detailViewController() -> DetailViewController {
    if splitViewController?.traitCollection.horizontalSizeClass == .Compact {
      let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
      return detailViewController
    }
    
    let navController = splitViewController?.viewControllers.last as! UINavigationController
    let detailViewController = navController.viewControllers.first as! DetailViewController
    return detailViewController
  }
  
  /// Present DetailViewController with a given log.
  /// For convenience, returns a pointer to the controller that's just presented.
  func presentDetailViewControllerWithSelectedLog(log: BaseLog?) -> DetailViewController {
    let vc = detailViewController()
    vc.selectedLog = log
    showDetailViewController(vc, sender: nil)
    return vc
  }
  
  // MARK: UITableView data source and delegate
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return logs.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("LogCellIdentifier", forIndexPath: indexPath) as! LogCell
    let log = logs[indexPath.row]
    cell.setLog(log)
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let newlySelectedLog = logs[indexPath.row]
    if selectedLog == newlySelectedLog {
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      selectedLog = nil
    } else {
      selectedLog = newlySelectedLog
    }
    presentDetailViewControllerWithSelectedLog(selectedLog)
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    return UITableViewCellEditingStyle.Delete
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == UITableViewCellEditingStyle.Delete {
      unowned let weakSelf = self
      let alertController = UIAlertController(title: "Confirm", message: "Are you sure you want to delegate this log?", preferredStyle: UIAlertControllerStyle.Alert)
      alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
      alertController.addAction(UIAlertAction(title: "Yes, I'm sure!", style: UIAlertActionStyle.Destructive, handler: { _ -> Void in
        
        let logToDelete = weakSelf.logs[indexPath.row]
        let store = LogStore.sharedStore
        store.logCollection.removeLog(logToDelete)
        store.save()
        
        if weakSelf.selectedLog == logToDelete && weakSelf.splitViewController?.traitCollection.horizontalSizeClass == .Regular {
          let vc = weakSelf.detailViewController()
          vc.selectedLog = nil
        }
      }))
      presentViewController(alertController, animated: true, completion: nil)
    }
  }
  
  override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    // Hide or show bar button items based on the size class.
    let isCompact = splitViewController?.traitCollection.horizontalSizeClass == .Compact
    let items: [UIBarButtonItem] = (isCompact) ? [addNoteButton, cameraButton, photoLibraryButton] : []
    navigationItem.setRightBarButtonItems(items, animated: true)
    
    // Hide or show title in the navigation bar.
    title = (isCompact) ? "" : "Travel Log"
  }
}
