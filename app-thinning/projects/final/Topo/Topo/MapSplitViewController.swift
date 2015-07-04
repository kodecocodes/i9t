//
//  MapSplitViewController.swift
//  Topo
//
//  Created by Derek Selander on 6/30/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

class MapSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
  var detailVC: MapChromeViewController!
  var masterVC: MapContentTableViewController!
  
  @IBOutlet var masterNavigationController : UIViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    self.preferredDisplayMode = .AllVisible

//    for navController in self.viewControllers as! [UINavigationController] {
//      if let vc = navController.topViewController as? MapChromeViewController {
//        self.detailVC = vc
//      } else if let vc = navController.topViewController as? MapContentTableViewController {
//        self.masterVC = vc
//      }
//    }
  }
  
 
  
  func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
    return true
  }
  
}
