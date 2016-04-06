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
    return true
  }

  var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid

  func applicationDidEnterBackground(application: UIApplication) {
    print("Method: \(#function), called at: \(NSDate())")
    // Request more background time
    backgroundTaskIdentifier = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { [unowned self] in
      // This will be called when the timer expires if application.endBackgroundTask was not called
      print("Background execution time expired at: \(NSDate())")
      self.backgroundTaskIdentifier = UIBackgroundTaskInvalid
    }

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
      self.performBackgroundWork()
    }
  }

  func performBackgroundWork() {
    let startDate = NSDate()
    print("Background work started at: \(startDate)")
    for i in 1...10 {
      // Do important stuff here
      print("Doing background work. Task: \(i). Completed at: \(NSDate())")
      sleep(1)
    }
    let endDate = NSDate()
    let elapsedTime = endDate.timeIntervalSinceDate(startDate)
    print("All background work completed at: \(endDate)")

    let formattedElapsedTime = FormatHelper.formatNumber(elapsedTime, withFractionDigitCount: 2)
    print("Background work completed in: \(formattedElapsedTime) sec")

    UIApplication.sharedApplication().endBackgroundTask(
      backgroundTaskIdentifier)
  }
}
