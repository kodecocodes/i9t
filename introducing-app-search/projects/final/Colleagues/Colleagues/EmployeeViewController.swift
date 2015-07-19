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
    
    var employee: Employee!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pictureImageView.image = employee.loadPicture()
        nameLabel.text = employee.name
        departmentLabel.text = employee.department
        titleLabel.text = employee.title
        phoneLabel.text = employee.phone
        emailLabel.text = employee.email
        skillsLabel.text = ", ".join(employee.skills)
    }
}
