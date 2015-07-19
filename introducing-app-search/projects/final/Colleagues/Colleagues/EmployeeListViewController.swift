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
    
    override func viewDidLoad() {
        employeeList = EmployeeService().fetchEmployees()
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
}