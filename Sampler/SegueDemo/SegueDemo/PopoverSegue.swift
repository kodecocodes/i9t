//
//  PopoverSegue.swift
//  SegueDemo
//
//  Created by Caroline Begbie on 20/07/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class PopoverSegue: UIStoryboardSegue {

  override func perform() {
    destinationViewController.popoverPresentationController?.delegate = self
    super.perform()
  }
}

extension PopoverSegue : UIPopoverPresentationControllerDelegate {
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    return .None
  }
}