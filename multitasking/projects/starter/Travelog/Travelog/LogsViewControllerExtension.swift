/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

extension LogsViewController: UISplitViewControllerDelegate {
  
  func splitViewController(splitViewController: UISplitViewController, showDetailViewController vc: UIViewController, sender: AnyObject?) -> Bool {
    if splitViewController.traitCollection.horizontalSizeClass == .Compact {
      let navigationController = splitViewController.viewControllers.first as! UINavigationController
      navigationController.pushViewController(vc, animated: true)
    }
    return true
  }
  
  func splitViewController(splitViewController: UISplitViewController, separateSecondaryViewControllerFromPrimaryViewController primaryViewController: UIViewController) -> UIViewController? {
    clearsSelectionOnViewWillAppear = false
    let primaryNavController = primaryViewController as! UINavigationController
    primaryNavController.popToRootViewControllerAnimated(false)
    
    let detailNavigationController = storyboard!.instantiateViewControllerWithIdentifier("DetailNavigationController") as! UINavigationController
    let detailViewController = detailNavigationController.viewControllers.first as! DetailViewController
    detailViewController.selectedLog = selectedLog
    return detailNavigationController
  }
  
  func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
    clearsSelectionOnViewWillAppear = true
    if selectedIndexPath == nil {
      navigationController?.popToRootViewControllerAnimated(false)
      return true
    }
    return false
  }
  
}