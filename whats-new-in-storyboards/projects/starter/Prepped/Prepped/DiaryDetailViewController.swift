//
//  DiaryDetailViewController.swift
//  Prepped
//
//  Created by Caroline Begbie on 26/06/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class DiaryDetailViewController: UIViewController {
  
  @IBOutlet var diaryEntry: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.automaticallyAdjustsScrollViewInsets = false

    diaryEntry.becomeFirstResponder()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    diaryEntry.resignFirstResponder()
  }
}
