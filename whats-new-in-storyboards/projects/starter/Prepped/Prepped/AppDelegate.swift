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
    let barColor = UIColor(red: 0/255, green: 184/255, blue: 48/255, alpha: 1.0)
    let shadowColor = UIColor(red: 0/255, green: 114/255, blue: 30/255, alpha: 1.0)
    
    let navBarFont = UIFont.systemFontOfSize(17.0)
    
    // Navigation Bar
    UINavigationBar.appearance().translucent = true
    UINavigationBar.appearance().titleTextAttributes =
                [NSForegroundColorAttributeName : UIColor.whiteColor(),
                 NSFontAttributeName: navBarFont]
    
    let imageSize = CGSize(width: 1, height: 1)
    let backgroundImage = UIImage.imageWithColor(barColor, size: imageSize)
    UINavigationBar.appearance().setBackgroundImage(backgroundImage, forBarMetrics: .Default)
    let shadowImage = UIImage.imageWithColor(shadowColor, size: imageSize)
    UINavigationBar.appearance().shadowImage = shadowImage
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    
    // Tab Bar
    UITabBar.appearance().tintColor = barColor
    UITabBarItem.appearance().setTitleTextAttributes([ NSForegroundColorAttributeName: barColor ], forState: UIControlState.Normal)
    UITabBarItem.appearance().setTitleTextAttributes([ NSForegroundColorAttributeName: barColor ], forState: UIControlState.Selected)

    // Table View separator
    let separatorColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
    UITableView.appearance().separatorColor = separatorColor
  }
}

extension UIImage {
  
  // create image of solid color
  class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
    let rect = CGRect(origin: .zeroPoint, size: size)
    let path = UIBezierPath(rect: rect)
    color.setFill()
    path.fill()
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }

}
