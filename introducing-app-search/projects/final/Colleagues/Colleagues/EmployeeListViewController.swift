//
//  EmployeeListViewController.swift
//  Colleagues
//
//  Created by Chris Wagner on 7/18/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import UIKit
import EmployeeKit

class EmployeeListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var employeeList = [Employee]()
    
    private var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        employeeList = EmployeeService().fetchEmployees()
        employeeList.sortInPlace { $0.name < $1.name }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let selectedIndexPath = selectedIndexPath {
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewEmployee",
            let cell = sender as? EmployeeListCell,
            let employeeViewController = segue.destinationViewController as? EmployeeViewController {
            employeeViewController.employee = cell.employee
        }
    }
    
    func runFilter(filter: (Employee -> Bool)) {
        employeeList = employeeList.filter(filter)
    }
}


extension EmployeeListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Employee", forIndexPath: indexPath) as! EmployeeListCell
        
        cell.employee = employeeList[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
    }
}