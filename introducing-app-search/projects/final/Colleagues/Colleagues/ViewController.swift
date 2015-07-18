//
//  ViewController.swift
//  Colleagues
//
//  Created by Chris Wagner on 7/14/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import UIKit
import CoreSpotlight
import EmployeeKit

class ViewController: UIViewController {
    
    let activity = NSUserActivity(activityType: "com.razeware.colleagues.person")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let employeeService = EmployeeService()
        var employees = employeeService.fetchEmployees()
        print(employees)
        let image = employees[0].loadPicture()
        
        activity.title = "Jerry Garcia"
        activity.keywords = ["jerry", "garcia", "colleague"]
        activity.eligibleForSearch = true
        activity.userInfo = ["id": "person.2"]
        activity.webpageURL = NSURL(string: "https://devbox.infusionsoft.com/")!
        activity.becomeCurrent()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        activity.resignCurrent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

