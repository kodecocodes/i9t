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
    UINavigationBar.appearance().titleTextAttributes =
      [NSForegroundColorAttributeName : UIColor.whiteColor()]
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    
    let imageSize = CGSize(width: 1, height: 1)
    let shadowColor = UIColor(hex: 0x571BA1, alpha: 1.0)
    let barColor = UIColor(hex: 0x9B00FF, alpha: 1.0)
    let backgroundImage = UIImage.imageWithColor(barColor, size: imageSize)
    UINavigationBar.appearance().setBackgroundImage(backgroundImage, forBarMetrics: .Default)
    let shadowImage = UIImage.imageWithColor(shadowColor, size: imageSize)
    UINavigationBar.appearance().shadowImage = shadowImage
  }
}

extension UIColor{
  // create color from hexadecimal input eg 0xFF0000 will be red
  convenience init(hex:UInt, alpha: CGFloat) {
    self.init(
      red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(hex & 0x0000FF) / 255.0,
      alpha: alpha
    )
  }
}

extension UIImage {
  // create image of solid color
  class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
    let context = UIGraphicsGetCurrentContext()
    color.setFill()
    CGContextFillRect(context, CGRect(origin: .zero, size: size))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
}

