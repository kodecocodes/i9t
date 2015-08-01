//
//  MainViewController.swift
//  LocalWeather
//
//  Created by Jawwad Ahmad on 7/27/15.
//  Copyright © 2015 Jawwad Ahmad. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainViewController: UIViewController {

  @IBOutlet weak var cityNameLabel: UILabel!
  @IBOutlet weak var countryNameLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var pressureLabel: UILabel!

  @IBOutlet weak var latitudeLabel: UILabel!
  @IBOutlet weak var longitudeLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!

  var weatherData: WeatherData?
  var locationNeedsUpdate = true

  let locationManager = CLLocationManager()

  override func awakeFromNib() {
    super.awakeFromNib()

    // SAM: Was thinking maybe have a misguaded attempt to re-fetch the weather every 15 seconds or so
    // NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: "updateMyWeather", userInfo: nil, repeats: true)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    mapView.showsScale = true
    mapView.showsCompass = true

    let locationServicesEnabled = CLLocationManager.locationServicesEnabled()

    if !locationServicesEnabled {
      print("locationServices are not enabled!")
    }

    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()

    // TASK: Decrease desired accuracy to conserve power since
    // locationManager.desiredAccuracy = kCLLocationAccuracyKilometer

    // Reset while updating
    resetViews()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    if let weatherData = weatherData {
      updateViewWithWeatherData(weatherData)
    } else {
      resetViews()
    }
  }

  func resetViews() {
    temperatureLabel.text = "-- °-"
    cityNameLabel.text = "- - - - - - - - - -"
    countryNameLabel.text = "- - - - - - - - - -"
    humidityLabel.text = "- -"
    pressureLabel.text = "- -"
  }

  func fetchWeatherForCoordinate(coordinate: CLLocationCoordinate2D) {

    let urlString = "http://api.openweathermap.org/data/2.5/weather"
      + "?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=metric"
    
    RWNetworkHelper.fetchJSONAtURLString(urlString) { json, error in
      guard let jsonDict = json as? [String : AnyObject] else {
        fatalError("Expected a JSON Dictionary")
      }

      let weatherData = WeatherData(json: jsonDict)
      self.updateViewWithWeatherData(weatherData)
      self.weatherData = weatherData
    }
  }

  func updateViewWithWeatherData(weatherData: WeatherData) {
    let temperatureUnit = SettingsHelper.temperatureUnitString()
    let unitAbbreviation = temperatureUnit.substringToIndex(advance(temperatureUnit.startIndex, 1))

    if let countryName = NSLocale.systemLocale().displayNameForKey(NSLocaleCountryCode, value: weatherData.countryCode) {
      countryNameLabel.text = countryName
    } else if weatherData.countryCode == "none" {
      countryNameLabel.text = ""
    } else {
      countryNameLabel.text = weatherData.countryCode
    }
    
    cityNameLabel.text = weatherData.name
    temperatureLabel.text = "\(weatherData.temperatureForUnit(temperatureUnit))°\(unitAbbreviation)"
    humidityLabel.text = "\(weatherData.humidity) %"
    pressureLabel.text = "\(weatherData.pressure) hPa"
  }


  // TODO: Perhaps Put this in helper
  func randomNumber(min min: Int, max: Int) -> Int {
    let range = max - min
    let numberInRange = Int(arc4random_uniform(UInt32(range + 1)))
    return min + numberInRange
  }

  func randomLocationCoordinate() -> CLLocationCoordinate2D {
    let randomLatitude = CLLocationDegrees(randomNumber(min: -90, max: 90))
    let randomLongitude = CLLocationDegrees(randomNumber(min: -180, max: 180))
    return CLLocationCoordinate2D(latitude: randomLatitude, longitude: randomLongitude)
  }


  func zoomToCoordinate(coordinate: CLLocationCoordinate2D) {
    mapView.setCenterCoordinate(coordinate, animated: true)
    // TODO: Zooming crashes sometimes with certain values of coordinate. Maybe random isn't that good.
    //    let zoomRegion = MKCoordinateRegionMakeWithDistance(myCoordinate, 15_000, 15_000)
    //    let zoomRegion = MKCoordinateRegionMakeWithDistance(coordinate, 15_000_000, 15_000_000)
    //    mapView.setRegion(zoomRegion, animated: true)

    // Add annotation at that spot
    mapView.removeAnnotations(mapView.annotations)
    let annotation = MKPointAnnotation(coordinate: coordinate)
    mapView.addAnnotation(annotation)
  }


  // MARK: - Actions

  @IBAction func updateMyWeather() {
    locationNeedsUpdate = true
    locationManager.requestLocation()
  }

  @IBAction func randomLocationWeather() {
    let randomCoordinate = randomLocationCoordinate()
    fetchWeatherAndZoomToCoordinate(randomCoordinate)
  }

  func fetchWeatherAndZoomToCoordinate(coordinate: CLLocationCoordinate2D) {
    fetchWeatherForCoordinate(coordinate)
    zoomToCoordinate(coordinate)
    latitudeLabel.text = "\(coordinate.latitude)"
    longitudeLabel.text = "\(coordinate.longitude.description)"
  }

  // In case location services are disabled
  func showOpenAppSettingsAlertWithTitle(title: String?, message: String?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
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

extension MainViewController: CLLocationManagerDelegate {

  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("didUpdateLocations: \(locations)")
    let location = locations.last! // force unwrap since its guaranteed to contain at least one object

    if locationNeedsUpdate { // SAM: I seem to get this callback 2 or 3 times even with request.location
      fetchWeatherAndZoomToCoordinate(location.coordinate)
      locationNeedsUpdate = false
    }

    locationManager.stopUpdatingLocation() // TASK: Add this line
  }

  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    print("locationManager didFailWithError: \(error)")
  }

  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    print("didChangeAuthorizationStatus: ", appendNewline: false)

    switch status {
    case .NotDetermined:
      print("NotDetermined")
    case .Restricted:
      print("Restricted") // Parental Controls
    case .Denied:
      print("Denied")
      // showOpenAppSettingsAlertWithTitle("Location Access Required", message: "This app requires location access.")
    case .AuthorizedAlways:
      print("AuthorizedAlways")
    case .AuthorizedWhenInUse:
      print("AuthorizedWhenInUse")
      // Update the location
      locationManager.startUpdatingLocation() // TASK: replace with .requsetLocation() so that .stopUpdatingLocation() doesn't have to be called
      // locationManager.requestLocation()
    }
  }
}

extension MKPointAnnotation {
  convenience init(coordinate: CLLocationCoordinate2D) {
    self.init()
    self.coordinate = coordinate
  }
}
