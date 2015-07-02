//
//  MapSplitViewController.swift
//  Topo
//
//  Created by Derek Selander on 6/30/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

class MapSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
  
  @IBOutlet var masterNavigationController : UIViewController!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    self.preferredDisplayMode = .AllVisible
  }
  
  
  func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
    return true
  }
  
}
