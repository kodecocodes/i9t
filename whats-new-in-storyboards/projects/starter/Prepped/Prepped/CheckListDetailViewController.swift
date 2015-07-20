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

class CheckListDetailViewController: UITableViewController {
  
  let cellHeight = 64.0
  let cellPadding = 10.0
  
  var checkList: CheckList!
  
  // MARK: - Unwind segue methods
  
  @IBAction func cancelToCheckListDetailViewController(segue: UIStoryboardSegue) {
  }
  
  @IBAction func saveToCheckListDetailViewController(segue: UIStoryboardSegue) {
    if let controller = segue.sourceViewController as? CheckListItemDetailViewController,
      item = controller.checkListItem {
        checkList.items.append(item)

        tableView.beginUpdates()
        let indexPath = NSIndexPath(forRow: checkList.items.count - 1, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
        tableView.endUpdates()
    }
  }
}

// MARK: - UITableViewDelegate
extension CheckListDetailViewController {
}

// MARK: - UITableViewDataSource
extension CheckListDetailViewController {
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return checkList.items.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CheckListItemCell", forIndexPath: indexPath) as! CheckListItemTableViewCell
    
    let checkListItem = checkList.items[indexPath.row]
    cell.checkListItem = checkListItem
    
    return cell
  }
}
