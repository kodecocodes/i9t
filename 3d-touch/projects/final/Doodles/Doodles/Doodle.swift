//
//  Doodle.swift
//  Doodles
//
//  Created by James Frost on 23/09/2015.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import UIKit

let shareDoodleShortcutItemType = "com.razeware.Doodles.share"
let newDoodleShortcutItemType = "com.razeware.Doodles.new"

struct Doodle {
  let name: String
  let date: NSDate
  let image: UIImage?
  
  static var allDoodles = [
    Doodle(name: "Doggy", date: NSDate(), image: UIImage(named: "doodle1")),
    Doodle(name: "Razeware", date: NSDate(), image: UIImage(named: "doodle2")),
    Doodle(name: "House", date: NSDate(), image: UIImage(named: "doodle3"))
  ]
  
  static var sortedDoodles: [Doodle] {
    return allDoodles.sort { $0.date.timeIntervalSinceNow > $1.date.timeIntervalSinceNow }
  }
  
  static func addDoodle(doodle: Doodle) {
    allDoodles.append(doodle)

    Doodle.configureDynamicShortcuts()
  }

  static func configureDynamicShortcuts() {
    let application = UIApplication.sharedApplication()
    let shortcuts = application.shortcutItems
    
    if let mostRecentDoodle = Doodle.sortedDoodles.first {
      let shortcutItem = UIApplicationShortcutItem(type: shareDoodleShortcutItemType,
        localizedTitle: "Share Latest Doodle",
        localizedSubtitle: mostRecentDoodle.name,
        icon: UIApplicationShortcutIcon(type: .Share),
        userInfo: nil)
      application.shortcutItems = [ shortcutItem ]
    }
    
    print(shortcuts)
  }
}