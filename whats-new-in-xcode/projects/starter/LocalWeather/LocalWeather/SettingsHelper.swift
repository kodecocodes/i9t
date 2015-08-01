//
//  SettingsHelper.swift
//  LocalWeather
//
//  Created by Jawwad Ahmad on 7/31/15.
//  Copyright © 2015 Jawwad Ahmad. All rights reserved.
//

import Foundation

class SettingsHelper {

  static let temperatureSaveKey = "TemperatureUnitPreference"

  class func temperatureUnitString() -> String {
    if let savedUnit = NSUserDefaults.standardUserDefaults().objectForKey(temperatureSaveKey) as? String {
      return savedUnit
    } else {
      let currentLocaleUsesMetricSystem = NSLocale.currentLocale().objectForKey(NSLocaleUsesMetricSystem) as? Bool ?? true
      return currentLocaleUsesMetricSystem ? "Celsius" : "Fahrenheit"
    }
  }

  class func saveTemperatureUnitString(unitString: String) {
    NSUserDefaults.standardUserDefaults().setObject(unitString, forKey: temperatureSaveKey)
  }

}