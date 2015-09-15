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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pictureImageView.image = employee.loadPicture()
    nameLabel.text = employee.name
    departmentLabel.text = employee.department
    titleLabel.text = employee.title
    phoneLabel.text = employee.phone
    emailLabel.text = employee.email
    skillsLabel.text = employee.skills.joinWithSeparator(", ")
    otherEmployeesLabel.text = "Other employees in \(employee.department)"
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destination = segue.destinationViewController as? EmployeeListViewController
      where segue.identifier == "EmployeeListEmbedSegue" {
        destination.filterEmployees { employee -> Bool in
          employee.department == self.employee.department && employee.objectId != self.employee.objectId
      }
    }
  }
  
  @IBAction func call(sender: UITapGestureRecognizer) {
    employee.call()
  }
  
  @IBAction func email(sender: UITapGestureRecognizer) {
    employee.sendEmail()
  }
}
