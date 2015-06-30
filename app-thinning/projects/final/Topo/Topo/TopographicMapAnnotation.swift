//
//  TopographicMapAnnotation.swift
//  Topo
//
//  Created by Derek Selander on 6/30/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit
import MapKit
class TopographicMapAnnotation: NSObject, MKAnnotation {
  
  // Hardcoded... for now
  var coordinate: CLLocationCoordinate2D { get {return CLLocationCoordinate2D(latitude: 37.978845, longitude: -121.35498)} }
  
  // Title and subtitle for use by selection UI.
  var ODRTag: String { get { return "SF_Map" }}
  var title: String? { get { return "SF Test" }}
  var subtitle: String? { get { return "SF Subtitle Test"}}
}
