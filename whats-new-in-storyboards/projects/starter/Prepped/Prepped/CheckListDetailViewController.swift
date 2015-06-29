//
//  CheckListDetailViewController.swift
//  Prepped
//
//  Created by Caroline Begbie on 26/06/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class CheckListDetailViewController: UIViewController {
  
  @IBOutlet var checkList: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    checkList.becomeFirstResponder()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    checkList.resignFirstResponder()
  }
}
