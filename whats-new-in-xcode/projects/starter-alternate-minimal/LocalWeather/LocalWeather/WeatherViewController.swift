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
import CoreLocation

class WeatherViewController: UIViewController {

  @IBOutlet weak var cityNameLabel: UILabel!
  @IBOutlet weak var countryNameLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var pressureLabel: UILabel!
  @IBOutlet weak var latitudeLabel: UILabel!
  @IBOutlet weak var longitudeLabel: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var loadingStackView: UIStackView!
  @IBOutlet weak var dataLabelsStackView: UIStackView!
  @IBOutlet weak var nextRefreshTimeLabel: UILabel!

  var locationNeedsUpdate = true
  let locationManager = CLLocationManager()

  var refreshTimer: NSTimer?
  var updateLabelTimer: NSTimer?

  override func viewDidLoad() {
    super.viewDidLoad()

    let locationServicesEnabled = CLLocationManager.locationServicesEnabled()

    if !locationServicesEnabled {
      print("locationServices are not enabled on this device!")
    }

    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()

    // TASK 5: (BONUS TASK) Decrease desired accuracy to conserve power since
    // locationManager.desiredAccuracy = kCLLocationAccuracyKilometer

    // Reset while updating
    clearLabels()
  }

  func updateRefreshLabel() {
    if let timeRemaining = refreshTimer?.fireDate.timeIntervalSinceNow where refreshTimer?.valid == true {
      nextRefreshTimeLabel.text = "\(Int(round(timeRemaining)))"
    }
  }

  func clearLabels() {
    for label in [temperatureLabel, cityNameLabel, countryNameLabel, humidityLabel, pressureLabel, latitudeLabel, longitudeLabel] {
      label.text = ""
    }

    dataLabelsStackView.hidden = true
  }

  func fetchWeatherForCoordinate(coordinate: CLLocationCoordinate2D) {
    let usesMetricSystem = NSLocale.currentLocale().objectForKey(NSLocaleUsesMetricSystem) as? Bool ?? true
    let units = usesMetricSystem ? "metric" : "imperial"

    let urlString = "http://api.openweathermap.org/data/2.5/weather"
      + "?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=\(units)"
    
    RWNetworkHelper.fetchJSONAtURLString(urlString) { json, error in
      guard let jsonDict = json as? [String : AnyObject] else {
        fatalError("Expected a JSON Dictionary")
      }

      let weatherData = WeatherData(json: jsonDict)
      self.updateViewWithWeatherData(weatherData, coordinate: coordinate)
    }
  }

  func updateViewWithWeatherData(weatherData: WeatherData, coordinate: CLLocationCoordinate2D) {
    let usesMetricSystem = NSLocale.currentLocale().objectForKey(NSLocaleUsesMetricSystem) as? Bool ?? true
    let unitAbbreviation = usesMetricSystem ? "C" : "F"

    if let countryName = NSLocale.systemLocale().displayNameForKey(NSLocaleCountryCode, value: weatherData.countryCode) {
      countryNameLabel.text = countryName
    } else if weatherData.countryCode == "none" {
      countryNameLabel.text = ""
    } else {
      countryNameLabel.text = weatherData.countryCode
    }
    
    cityNameLabel.text = weatherData.name
    temperatureLabel.text = "\(weatherData.temperature)°\(unitAbbreviation)"
    humidityLabel.text = "\(weatherData.humidity) %"
    pressureLabel.text = "\(weatherData.pressure) hPa"
    latitudeLabel.text = "\(round(coordinate.latitude * 100)/100)"
    longitudeLabel.text = "\(round(coordinate.longitude * 100)/100)"

    loadingStackView.hidden = true
    dataLabelsStackView.hidden = false

    // TASK 3: Explain that network activity is expensive since the radios stay on for about 10 seconds after each request. Better to batch or not do it.
    refreshTimer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: "updateMyWeather", userInfo: nil, repeats: false)

    // TASK 2: Don't do work if you don't have to. Refreshing the label constantly keeps the CPU awake which is inefficient.
    updateLabelTimer?.invalidate()
    updateLabelTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateRefreshLabel", userInfo: nil, repeats: true)
    updateRefreshLabel()
  }

  // MARK: - Actions

  @IBAction func updateMyWeather() {
    loadingStackView.hidden = false
    locationNeedsUpdate = true
    locationManager.requestLocation()
  }

  func showLocationRequiredAlert() {
    let alertController = UIAlertController(title: "Location Access Required",
      message: "Location access is required to fetch the weather for your current location.", preferredStyle: .Alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    alertController.addAction(cancelAction)

    let appSettingsAction = UIAlertAction(title: "App Settings", style: .Default) { action in
      UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    alertController.addAction(appSettingsAction)
    presentViewController(alertController, animated: true, completion: nil)
  }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {

  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.last! // force unwrap since its guaranteed to contain at least one object

    if locationNeedsUpdate {
      fetchWeatherForCoordinate(location.coordinate)
      locationNeedsUpdate = false
    }

    // TASK 1: Add this line or alternatively replace locationManager.startUpdatingLocation() with locationManager.requestLocation()
     locationManager.stopUpdatingLocation()
  }

  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    print("locationManager didFailWithError: \(error)")
  }

  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    switch status {
    case .NotDetermined:
      print("NotDetermined")
    case .Restricted, .Denied:
      showLocationRequiredAlert()
    case .AuthorizedAlways, .AuthorizedWhenInUse:
      locationManager.startUpdatingLocation()
    }
  }
}
