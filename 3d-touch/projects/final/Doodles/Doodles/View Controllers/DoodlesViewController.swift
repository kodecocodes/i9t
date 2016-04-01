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

class DoodlesViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if traitCollection.forceTouchCapability == .Available {
      registerForPreviewingWithDelegate(self, sourceView: view)
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    tableView.reloadData()
  }
  
  @IBAction func unwindToDoodlesViewController(segue: UIStoryboardSegue) {}
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destinationViewController = segue.destinationViewController as? DoodleDetailViewController,
      let indexPath = tableView.indexPathForSelectedRow
      where segue.identifier == "ViewDoodleSegue" {
        let doodle = Doodle.allDoodles[indexPath.row]
        destinationViewController.doodle = doodle
    }
  }
}

//MARK: UITableViewDataSource
extension DoodlesViewController {
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Doodle.allDoodles.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("DoodleCell", forIndexPath: indexPath) as! DoodleCell
    
    cell.doodle = Doodle.allDoodles[indexPath.row]
    
    return cell
  }
}

extension DoodlesViewController: UIViewControllerPreviewingDelegate {
  func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
    // 1
    guard let indexPath = tableView.indexPathForRowAtPoint(location),
      cell = tableView.cellForRowAtIndexPath(indexPath) as? DoodleCell
      else { return nil }
    
    // 2
    let identifier = "DoodleDetailViewController"
    guard let detailVC = storyboard?.instantiateViewControllerWithIdentifier(identifier) as? DoodleDetailViewController
      else { return nil }
    
    detailVC.doodle = cell.doodle
    detailVC.doodlesViewController = self
    
    // 3
    previewingContext.sourceRect = cell.frame
    
    // 4
    return detailVC
  }
  func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
    //pop!
    showViewController(viewControllerToCommit, sender: self)
  }
  
}
