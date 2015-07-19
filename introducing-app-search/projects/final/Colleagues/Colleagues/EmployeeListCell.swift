//
//  EmployeeListCell.swift
//  Colleagues
//
//  Created by Chris Wagner on 7/18/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import UIKit
import EmployeeKit

class EmployeeListCell: UITableViewCell {
    
    var employee: Employee! {
        didSet {
            pictureImageView.image = employee.loadPicture()
            nameLabel.text = employee.name
            titleLabel.text = employee.title
        }
    }
    
    @IBOutlet private weak var pictureImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!

}
