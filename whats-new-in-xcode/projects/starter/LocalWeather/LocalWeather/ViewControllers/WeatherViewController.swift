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
import MapKit
import CoreLocation

// Sign up for an API Key at:
// http://home.openweathermap.org/users/sign_up

// Enter your API Key here
let openWeatherMapApiKey = "YOUR_API_KEY_HERE"

let openWeatherMapBaseUrl = "http://api.openweathermap.org/data/2.5"

class WeatherViewController: UIViewController {

  @IBOutlet weak private var cityNameLabel: UILabel!
  @IBOutlet weak private var countryNameLabel: UILabel!
  @IBOutlet weak private var temperatureLabel: UILabel!
  @IBOutlet weak private var humidityLabel: UILabel!
  @IBOutlet weak private var pressureLabel: UILabel!
  @IBOutlet weak private var latitudeLabel: UILabel!
  @IBOutlet weak private var longitudeLabel: UILabel!
  @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak private var mainStackView: UIStackView!
  @IBOutlet weak private var loadingStackView: UIStackView!
  @IBOutlet weak private var countdownLabelStackView: UIStackView!
  @IBOutlet weak private var countdownLabel: UILabel!
  @IBOutlet weak private var mapView: MKMapView!

  let httpManager = RWHTTPManager(baseURL: NSURL(string: openWeatherMapBaseUrl)!)
  private let locationManager = CLLocationManager()

  // This prevents triggering multiple HTTP requests when locations are received
  var weatherNeedsFetchUpdate = true

  /*
    This is the timer that will fetch the weather periodically, currently every 15 seconds
    */
  var networkFetchTimer: NSTimer?

  /// This is the timer that will update the countdown label every 0.1 seconds
  var countdownUpdateTimer: NSTimer?

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    assert(CLLocationManager.locationServicesEnabled())

    // Hide the main and the countdownLabel stack views when the view first loads
    mainStackView.hidden = true
    countdownLabelStackView.hidden = true

    locationManager.delegate = self

    if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse {
      locationManager.requestWhenInUseAuthorization()
    } else {
      // Step 1: Trigger a location and weather update
      requestLocationAndFetchWeather()
    }

    // Refresh the location and weather anytime the application returns from the background
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "requestLocationAndFetchWeather",
      name: UIApplicationDidBecomeActiveNotification,
      object: nil)
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  /// This method is called every 15 seconds and also upon initial load of the view controller
  func requestLocationAndFetchWeather() {
    // Show the activity indicator
    loadingStackView.hidden = false

    // Set the flag that will cause an http request to be peformed after location is updated
    weatherNeedsFetchUpdate = true

    // Step 2: Request the location
    locationManager.startUpdatingLocation()
  }

  /// Zoom the map to the specified coordinate
  func zoomMapToCoordinate(coordinate: CLLocationCoordinate2D) {
    let zoomRegion = MKCoordinateRegionMakeWithDistance(coordinate, 5_000, 5_000)
    mapView.setRegion(zoomRegion, animated: true)

    // Add annotation at that spot
    mapView.removeAnnotations(mapView.annotations)
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    mapView.addAnnotation(annotation)
  }

  /// Requests the weather for a particular location, and then calls `updateViewsWithWeatherData`
  func fetchWeatherForCoordinate(coordinate: CLLocationCoordinate2D) {
    let usesMetricSystem = NSLocale.currentLocale().objectForKey(NSLocaleUsesMetricSystem) as? Bool ?? true
    let units = usesMetricSystem ? "metric" : "imperial"

    var apiEndpointPath = "weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=\(units)"

    if openWeatherMapApiKey != "YOUR_API_KEY_HERE" {
      apiEndpointPath += "&APPID=\(openWeatherMapApiKey)"
    }

    // Step 4: Make an HTTP request to the API endpoint
    print("Fetching weather using: \(openWeatherMapBaseUrl)/\(apiEndpointPath)")
    httpManager.fetchJSONAtPath(apiEndpointPath) { json, error in
      guard let jsonDict = json as? [String : AnyObject] else {
        fatalError("Expected a JSON Dictionary")
      }

      let weatherData = WeatherData(json: jsonDict)

      // Step 5: Weather data received. Update views with the newly fetched data
      self.updateViewsWithWeatherData(weatherData, coordinate: coordinate)
    }
  }

  /// Updates the views and resets the timers
  func updateViewsWithWeatherData(weatherData: WeatherData, coordinate: CLLocationCoordinate2D) {
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
    latitudeLabel.text = FormatHelper.formatNumber(coordinate.latitude, withFractionDigitCount: 2)
    longitudeLabel.text = FormatHelper.formatNumber(coordinate.longitude, withFractionDigitCount: 2)

    mainStackView.hidden = false
    countdownLabelStackView.hidden = false

    // Fade out the loading view
    UIView.animateWithDuration(0.3,
      animations: {
        self.loadingStackView.alpha = 0
      }, completion: { _ in
        self.loadingStackView.hidden = true
        self.loadingStackView.alpha = 1
      }
    )

    // Step 6: Set a timer to fetch the weather again in 15 seconds
    networkFetchTimer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: "requestLocationAndFetchWeather", userInfo: nil, repeats: false)

    if countdownUpdateTimer == nil {
      // Step 7: Update the countdown label every 0.1 seconds using a timer
      countdownUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateCountdownLabel", userInfo: nil, repeats: true)
    }

    // Fire immediately and reset the interval to repeat from the current time. Not strictly necessary for a 0.1 delay
    countdownUpdateTimer?.fire()
  }

  /// Updates `countdownLabel` with the number of seconds until the `networkFetchTimer` will fire.
  func updateCountdownLabel() {
    if let timeRemaining = networkFetchTimer?.fireDate.timeIntervalSinceNow where networkFetchTimer?.valid == true {
      // Step 8: Update the countdown label with the time remaining
      countdownLabel.text = FormatHelper.formatNumber(timeRemaining, withFractionDigitCount: 1)
    } else {
      countdownLabel.text = "0"
    }
  }

  private func showLocationRequiredAlert() {
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

  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    switch status {
    case .NotDetermined:
      print("NotDetermined")
    case .Restricted, .Denied:
      showLocationRequiredAlert()
    case .AuthorizedAlways, .AuthorizedWhenInUse:
      // Trigger a location and weather update
      requestLocationAndFetchWeather()
    }
  }

  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.last! // force unwrap since its guaranteed to contain at least one object

    if weatherNeedsFetchUpdate {
      zoomMapToCoordinate(location.coordinate)
      // Step 3: Location received. Now fetch the weather for the received location
      fetchWeatherForCoordinate(location.coordinate)
      weatherNeedsFetchUpdate = false
    }
  }

  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    print("locationManager didFailWithError: \(error.localizedDescription)")
  }

}
