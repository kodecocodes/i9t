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

import Foundation

// API Docs
// http://openweathermap.org/current#parameter

// SampleCall
// http://api.openweathermap.org/data/2.5/weather?lat=33.92&lon=-84.38&units=metric

class WeatherData {

  var temperature: Int
  var humidity: Int
  var pressure: Int
  var name: String
  var countryCode: String

  init(json: [String: AnyObject]) {
    guard let
    // name
    name = json["name"] as? String,

    // sys
    sys = json["sys"] as? [String: AnyObject],
    countryCode = sys["country"] as? String,

    // main
    main = json["main"] as? [String: AnyObject],
    temperature = main["temp"] as? Double,
    humidity = main["humidity"] as? Int,
    pressure = main["pressure"] as? Int
      else {
        fatalError("Weather data incomplete")
    }

    self.temperature = Int(round(temperature))
    self.humidity = humidity
    self.pressure = pressure
    self.countryCode = countryCode
    self.name = name
  }
}
