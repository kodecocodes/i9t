//
//  EmployeeViewController.swift
//  Colleagues
//
//  Created by Chris Wagner on 7/18/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import UIKit
import EmployeeKit

class EmployeeViewController: UIViewController {

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    
    @IBOutlet weak var otherEmployeesLabel: UILabel!
    
    @IBOutlet weak var sameDepartmentContainerView: UIView!
    
    var employee: Employee!
    
    override func loadView() {
        super.loadView()
        
        let sameDepartmentList = storyboard!.instantiateViewControllerWithIdentifier("EmployeeList") as! EmployeeListViewController
        addChildViewController(sameDepartmentList)
        sameDepartmentList.willMoveToParentViewController(self)
        sameDepartmentList.view.frame = sameDepartmentContainerView.bounds
        sameDepartmentContainerView.addSubview(sameDepartmentList.view)
        sameDepartmentList.didMoveToParentViewController(self)
        sameDepartmentList.runFilter { employee -> Bool in
            employee.department == self.employee.department && employee.objectId != self.employee.objectId
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pictureImageView.image = employee.loadPicture()
        nameLabel.text = employee.name
        departmentLabel.text = employee.department
        titleLabel.text = employee.title
        phoneLabel.text = employee.phone
        emailLabel.text = employee.email
        skillsLabel.text = ", ".join(employee.skills)
        otherEmployeesLabel.text = "Other employees in \(employee.department)"
    }
    
    @IBAction func call(sender: UITapGestureRecognizer) {
        employee.call()
    }
    
    @IBAction func email(sender: UITapGestureRecognizer) {
        employee.sendEmail()
    }
}
