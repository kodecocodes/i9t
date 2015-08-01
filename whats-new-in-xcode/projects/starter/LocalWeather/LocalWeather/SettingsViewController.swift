//
//  SettingsViewController.swift
//  LocalWeather
//
//  Created by Jawwad Ahmad on 7/31/15.
//  Copyright © 2015 Jawwad Ahmad. All rights reserved.
//

import UIKit
import MapKit

class SettingsViewController: UIViewController {

  @IBOutlet weak var unitSegmentedControl: UISegmentedControl!

  @IBAction func unitSegmentedControlValueChanged(sender: UISegmentedControl) {
    let unit = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)
    NSUserDefaults.standardUserDefaults().setObject(unit, forKey: "TemperatureUnitPreference")
  }

  @IBOutlet weak var latitudeLabel: UILabel!
  @IBOutlet weak var longitudeLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!

  let locationManager = CLLocationManager()

  override func viewDidLoad() {
    super.viewDidLoad()

    locationManager.delegate = self

    let unitString = SettingsHelper.temperatureUnitString()

    for index in 0..<unitSegmentedControl.numberOfSegments {
      if unitSegmentedControl.titleForSegmentAtIndex(index) == unitString {
        unitSegmentedControl.selectedSegmentIndex = index
        break
      }
    }
  }

  @IBAction func updateLocationAutomaticallyTapped() {
    locationManager.requestLocation()
  }

  func updateViewsForCoordinate(coordinate: CLLocationCoordinate2D) {
    mapView.setCenterCoordinate(coordinate, animated: true)

    latitudeLabel.text = coordinate.latitude.description
    longitudeLabel.text = coordinate.longitude.description

    // Add annotation at that spot
    mapView.removeAnnotations(mapView.annotations)
    let annotation = MKPointAnnotation(coordinate: coordinate)
    mapView.addAnnotation(annotation)
  }

  @IBAction func enterAddressTapped(sender: UIButton) {
    let alertController = UIAlertController(title: nil, message: sender.titleLabel!.text!, preferredStyle: .Alert)

    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    alertController.addAction(cancelAction)

    let submitAction = UIAlertAction(title: "Submit", style: .Default) { _ in
      let addressTextField = alertController.textFields!.first!

      let address = addressTextField.text!

      let geocoder = CLGeocoder()
      geocoder.geocodeAddressString(address) { placemarks, error in

        if let error = error {
          print("error: \(error)")
        }

        if let coordinate = placemarks?.first?.location?.coordinate {
          self.updateViewsForCoordinate(coordinate)
        } else {
          print("Count not geocode location for address: \(address)")
        }
      }
    }

    alertController.addTextFieldWithConfigurationHandler { textField in
      textField.placeholder = "Zip Code or Address"
    }

    alertController.addAction(submitAction)

    presentViewController(alertController, animated: true, completion: nil)
  }

  @IBAction func enterLatLonTapped(sender: UIButton) {
    let alertController = UIAlertController(title: sender.titleLabel!.text!, message: nil, preferredStyle: .Alert)

    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    alertController.addAction(cancelAction)

    let submitAction = UIAlertAction(title: "Submit", style: .Default) { _ in
      let latitudeTextField = alertController.textFields!.first!
      let longitudeTextField = alertController.textFields!.last!

      if let latitude = Double(latitudeTextField.text!), longitude = Double(longitudeTextField.text!) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.updateViewsForCoordinate(coordinate)
      } else {
        print("Could not interpret \(latitudeTextField.text), \(longitudeTextField.text)")
      }
    }

    alertController.addTextFieldWithConfigurationHandler { textField in
      // textField.keyboardType = .NumberPad. 
      // Setting keyborad type to number pad would be nice but don't have number pad key
      textField.placeholder = "Latitude"
    }

    alertController.addTextFieldWithConfigurationHandler { textField in
      textField.keyboardType = .NumbersAndPunctuation
      textField.placeholder = "Longitude"
    }

    alertController.addAction(submitAction)

    presentViewController(alertController, animated: true, completion: nil)
  }

  @IBAction func clearLocationTapped() {
    latitudeLabel.text = "Not Set"
    longitudeLabel.text = "Not Set"
  }

  @IBAction func doneTapped(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}

extension SettingsViewController: CLLocationManagerDelegate {

  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("didUpdateLocations: \(locations)")
    let location = locations.last! // force unwrap since its guaranteed to contain at least one object

    self.updateViewsForCoordinate(location.coordinate)

    // locationManager.stopUpdatingLocation() // TASK: Add this line
  }

  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    print("locationManager didFailWithError: \(error)")
  }
}
