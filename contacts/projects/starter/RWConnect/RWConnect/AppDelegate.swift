//
//  AppDelegate.swift
//  RWConnect
//
//  Created by Evan Dekhayser on 6/27/15.
//  Copyright © 2015 Razeware, LLC. All rights reserved.
//

import UIKit

let rwGreen = UIColor(red: 0, green: 125.0 / 255.0, blue: 0, alpha: 1)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		window?.backgroundColor = UIColor.whiteColor()
		return true
	}
	
}

