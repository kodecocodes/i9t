//
//  VetSegue.swift
//  PamperedPets
//
//  Created by Caroline Begbie on 1/08/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class VetSegue: UIStoryboardSegue {

  override func perform() {
    destinationViewController.presentationController?.delegate = self
    super.perform()
  }
}

extension VetSegue: UIAdaptivePresentationControllerDelegate {
//  func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    return storyboard.instantiateViewControllerWithIdentifier("VetNavigationController")
//  }
  
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    return .None
  }
}
