//
//  AdaptiveSegue.swift
//  SegueDemo
//
//  Created by Caroline Begbie on 20/07/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class AdaptiveSegue: UIStoryboardSegue {

  override func perform() {
    destinationViewController.presentationController?.delegate = self
    super.perform()
  }
}

extension AdaptiveSegue: UIAdaptivePresentationControllerDelegate {
  
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    return traitCollection.horizontalSizeClass == .Compact ? .FullScreen : UIModalPresentationStyle.Popover
  }
  
  func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
    return UIStoryboard(name: "Adaptive", bundle: nil).instantiateViewControllerWithIdentifier("AdaptiveNavigationController")
  }
}
