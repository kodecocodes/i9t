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

class ViewController: UIViewController {
  
  @IBOutlet var mapView: MKMapView!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupMap()
    addMapData()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  private func setupMap() {
    let sanFrancisco = CLLocationCoordinate2D(latitude: 37.7833, longitude: -122.4167)
    centerMap(mapView, atPosition: sanFrancisco)
  }
  
  private func addMapData() {
    for coffeeshop in CoffeeShop.allCoffeeShops() {
      let annotation = CoffeeShopPin(coffeeshop: coffeeshop)
      mapView.addAnnotation(annotation)
    }
  }
  
  private func centerMap(map: MKMapView?, atPosition position: CLLocationCoordinate2D?) {
    guard let map = map, let position = position else {
      return
    }
    
    map.setCenterCoordinate(position, animated: true)
    
    let zoomRegion = MKCoordinateRegionMakeWithDistance(position, 10000, 10000)
    map.setRegion(zoomRegion, animated: true)
  }
}

// MARK:- MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? CoffeeShopPin else {
      return nil
    }
    
    let identifier = "CoffeeShopPinDetailView"
    
    var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
    
    if annotationView == nil {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      annotationView!.canShowCallout = true
    }
    
    annotationView!.annotation = annotation
    
    return annotationView
  }
}

