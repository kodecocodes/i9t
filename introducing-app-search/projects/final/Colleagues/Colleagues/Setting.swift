//
//  Settings.swift
//  Colleagues
//
//  Created by Chris Wagner on 7/23/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation

enum SearchIndexingPreference: Int {
  case Disabled, ViewedRecords, AllRecords
}

struct Setting {
  static var searchIndexingPreference: SearchIndexingPreference {
    let preferenceRawValue = NSUserDefaults.standardUserDefaults().integerForKey("SearchIndexingPreference")
    if let preference = SearchIndexingPreference(rawValue: preferenceRawValue) {
      return preference
    } else {
      return .Disabled
    }
  }
}