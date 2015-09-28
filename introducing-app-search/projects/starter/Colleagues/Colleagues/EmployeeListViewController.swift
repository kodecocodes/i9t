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
import EmployeeKit

class EmployeeListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private let navigationStackLimit = 2
  private var employeeList = [Employee]()
  
  private var selectedIndexPath: NSIndexPath?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    employeeList = EmployeeService().fetchEmployees()
    employeeList.sortInPlace { $0.name < $1.name }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if let selectedIndexPath = selectedIndexPath {
      tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
    }
  }
  
  override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
    if identifier == "ViewEmployee" && navigationController?.viewControllers.count > navigationStackLimit {
      // prevent the user from navigation too many levels deep
      if let cell = sender as? UITableViewCell, indexPath = tableView.indexPathForCell(cell) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
      }
      
      return false
    }
    
    return true
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ViewEmployee",
      let cell = sender as? EmployeeListCell,
      let employeeViewController = segue.destinationViewController as? EmployeeViewController {
        employeeViewController.employee = cell.employee
    }
  }
  
  func filterEmployees(filter: (Employee -> Bool)) {
    employeeList = employeeList.filter(filter)
  }
}


extension EmployeeListViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return employeeList.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Employee", forIndexPath: indexPath) as! EmployeeListCell
    cell.employee = employeeList[indexPath.row]
    
    if navigationController?.viewControllers.count > navigationStackLimit {
      cell.accessoryType = .None
    } else {
      cell.accessoryType = .DisclosureIndicator
    }
    
    return cell
  }
}

extension EmployeeListViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    selectedIndexPath = indexPath
  }
}