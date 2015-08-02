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
    configureAppearance()
    
    return true
  }
  
  func configureAppearance() {
    let barColor = UIColor(red: 11/255, green: 86/255, blue: 14/255, alpha: 1.0)
    let unselectedBarItemColor = UIColor(red: 9/255, green: 34/255, blue: 2/255, alpha: 1.0)
    
    UINavigationBar.appearance().translucent = true
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    UINavigationBar.appearance().barTintColor = barColor
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    
    UITabBar.appearance().translucent = true
    UITabBar.appearance().barTintColor = barColor
    UITabBar.appearance().tintColor = UIColor.whiteColor()
    
    UITabBarItem.appearance().setTitleTextAttributes([ NSForegroundColorAttributeName: unselectedBarItemColor ], forState: UIControlState.Normal)
    UITabBarItem.appearance().setTitleTextAttributes([ NSForegroundColorAttributeName: UIColor.whiteColor() ], forState: UIControlState.Selected)
  }
}
