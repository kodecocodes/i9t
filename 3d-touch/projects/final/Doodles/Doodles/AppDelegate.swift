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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    configureAppAppearance()
    
    Doodle.configureDynamicShortcuts()
    
    return true
  }
  
  func application(application: UIApplication,
    performActionForShortcutItem shortcutItem: UIApplicationShortcutItem,
    completionHandler: (Bool) -> Void) {
      handleShortcutItem(shortcutItem)
      completionHandler(true)
  }
  
  func handleShortcutItem(shortcutItem: UIApplicationShortcutItem) {
    switch shortcutItem.type {
    case "com.razeware.Doodles.new":
      presentNewDoodleViewController()
    case "com.razeware.Doodles.share":
      shareMostRecentDoodle()
    default: break
    }
  }
  
  func presentNewDoodleViewController() {
    let identifier = "NewDoodleNavigationController"
    let doodleViewController = UIStoryboard.mainStoryboard
      .instantiateViewControllerWithIdentifier(identifier)
    
    window?.rootViewController?
      .presentViewController(doodleViewController, animated: true,
        completion: nil)
  }
  
  func shareMostRecentDoodle() {
    if let mostRecentDoodle = Doodle.sortedDoodles.first,
      navigationController = window?
        .rootViewController as? UINavigationController {
          let identifier = "DoodleDetailViewController"
          let doodleViewController = UIStoryboard.mainStoryboard
            .instantiateViewControllerWithIdentifier(identifier) as!
          DoodleDetailViewController
          
          doodleViewController.doodle = mostRecentDoodle
          doodleViewController.shareDoodle = true
          
          navigationController.pushViewController(doodleViewController,
            animated: true)
    }
  }

}
