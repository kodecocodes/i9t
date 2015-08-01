//
//  AppDelegate.swift
//  LocalWeather
//
//  Created by Jawwad Ahmad on 7/27/15.
//  Copyright © 2015 Jawwad Ahmad. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    return true
  }

  func applicationDidEnterBackground(application: UIApplication) {
    print("applicationDidEnterBackground")
    let identifier = application.beginBackgroundTaskWithName("background task") {
      NSUserDefaults.standardUserDefaults().synchronize()
    }

    print("identifier: \(identifier)")
    // TODO: Demo that this must be called, otherwise background activity will continue
    // application.endBackgroundTask(identifier)
  }
}
