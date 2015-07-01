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
        controller.title = checkListData[indexPath.row]
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
