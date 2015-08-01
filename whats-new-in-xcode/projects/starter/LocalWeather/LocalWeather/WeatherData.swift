//
//  WeatherData.swift
//  LocalWeather
//
//  Created by Jawwad Ahmad on 7/27/15.
//  Copyright © 2015 Jawwad Ahmad. All rights reserved.
//

import Foundation

// API Docs
// http://openweathermap.org/current#parameter

// SampleCall
// http://api.openweathermap.org/data/2.5/weather?lat=33.92&lon=-84.38&units=metric

class WeatherData {

  var temperatureInCelsius: Int
  var humidity: Int
  var pressure: Int
  var name: String
  var countryCode: String

  var temperatureInFahrenheit: Int {
    return Int(round((Double(temperatureInCelsius) * 1.8) + 32))
  }

  func temperatureForUnit(unitString: String) -> Int {
    switch unitString {
    case "Celsius":
      return temperatureInCelsius
    case "Fahrenheit":
      return temperatureInFahrenheit
    default:
      fatalError("Invalid Unit: \(unitString)")
    }
  }

  // sunrise
  // sunset
  // wind.speed
  // wind.direction
  // dt
  // main
  // description

  init(json: [String: AnyObject]) {
    guard let main = json["main"] as? [String: AnyObject], temperature = main["temp"] as? Double else {
        fatalError("Must have at least a main key")
    }

    self.temperatureInCelsius = Int(round(temperature))
    self.humidity = main["humidity"] as? Int ?? 0
    self.pressure = main["pressure"] as? Int ?? 0

    guard let sys = json["sys"] as? [String: AnyObject], countryCode = sys["country"] as? String else {
      fatalError("Country code not present")
    }

    self.countryCode = countryCode
    self.name = json["name"] as? String ?? "Unknown"
  }
}

//base = "cmc stations";
//clouds =     {
//  all = 40;
//};
//cod = 200;
//coord =     {
//  lat = "33.92";
//  lon = "-84.38";
//};
//dt = 1438043304;
//id = 4221333;
//sys =     {
//  country = US;
//  id = 767;
//  message = "0.005";
//  sunrise = 1438080368;
//  sunset = 1438130490;
//  type = 1;
//};
//weather =     (
//  {
//    description = "scattered clouds";
//    icon = 03n;
//    id = 802;
//    main = Clouds;
//  }
//);
//wind =     {
//  deg = 280;
//  speed = "1.5";
//};