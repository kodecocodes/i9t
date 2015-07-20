//
//  AdaptiveViewController.swift
//  SegueDemo
//
//  Created by Caroline Begbie on 20/07/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class AdaptiveViewController: UIViewController {

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    segue.destinationViewController.preferredContentSize = CGSize(width: 300, height: 200)
  }

  
  @IBAction func unwindToAdaptive(segue: UIStoryboardSegue) {
    
  }

}
