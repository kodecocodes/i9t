//
//  FadeViewController.swift
//  CellExpand
//
//  Created by Caroline Begbie on 20/07/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class FadeViewController: UIViewController {
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    print("-- viewDidAppear")
    print(self.traitCollection.horizontalSizeClass.rawValue)
    print(self.traitCollection.verticalSizeClass.rawValue)
    // when rotated to landscape is 1 / 1 - seems correct
  }
  override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
    print("-- After rotate in presented and return")
    print("previous")
    print(previousTraitCollection?.horizontalSizeClass.rawValue)
    print(previousTraitCollection?.verticalSizeClass.rawValue)
    // after returning from rotated landscape presented 1 / 2

    print("current")
    print(self.traitCollection.horizontalSizeClass.rawValue)
    print(self.traitCollection.verticalSizeClass.rawValue)
    // 1 / 1 - seems correct
  }
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
//    print("UIWindow: \(UIWindow().frame)")
//    print("layout subviews frame: \(view.frame)")
  }
  
  @IBAction func unwindToFadeViewController(segue: UIStoryboardSegue) {
  }
}
