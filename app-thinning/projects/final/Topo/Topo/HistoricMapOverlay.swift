//
//  HistoricMapOverlay.swift
//  Topo
//
//  Created by Derek Selander on 6/28/15.
//  Copyright © 2015 RayWenderlich. All rights reserved.
//

import UIKit
import MapKit

class HistoricMapOverlay: NSObject, MKOverlay {
  
  
  var boundingMapRect: MKMapRect {          get{ return self.getMapRect() }}
  var coordinate: CLLocationCoordinate2D {  get{ return self.getCoordinate() }}
  var region: MKCoordinateRegion {          get{ return self.getRegion() }}
  
  let image : UIImage
  let auxillaryInfo : [String : AnyObject]
  
  init(auxillaryInfo : [String : AnyObject], image : UIImage) {
    self.auxillaryInfo = auxillaryInfo
    self.image = image
    super.init()
  }
  
  private func getCoordinate()->CLLocationCoordinate2D {
    let centerDict = self.auxillaryInfo["Center"] as! [String : Double]
    return CLLocationCoordinate2D(latitude: centerDict["lattitude"]!, longitude: centerDict["longitude"]!)
  }
  
  private func getMapRect()-> MKMapRect {
    
    let topLeftDict = self.auxillaryInfo["TopLeft"] as! [String : Double]
    let topLeftCoordinate = CLLocationCoordinate2D(latitude: topLeftDict["lattitude"]!, longitude: topLeftDict["longitude"]!)
    
    let topRightDict = self.auxillaryInfo["TopRight"] as! [String : Double]
    let topRightCoordinate = CLLocationCoordinate2D(latitude: topRightDict["lattitude"]!, longitude: topRightDict["longitude"]!)
    
    
    let bottomLeftDict = self.auxillaryInfo["BottomLeft"] as! [String : Double]
    let bottomLeftCoordinate = CLLocationCoordinate2D(latitude: bottomLeftDict["lattitude"]!, longitude: bottomLeftDict["longitude"]!)
    
    let topLeftPoint = MKMapPointForCoordinate(topLeftCoordinate)
    let topRightPoint = MKMapPointForCoordinate(topRightCoordinate)
    let bottomLeftPoint = MKMapPointForCoordinate(bottomLeftCoordinate)
    
    return MKMapRectMake(topLeftPoint.x, topLeftPoint.y, fabs(topLeftPoint.x - topRightPoint.x), fabs(topLeftPoint.y - bottomLeftPoint.y))
  }
  
  private func getRegion()->MKCoordinateRegion {
    let coordinateDict = self.auxillaryInfo["MapRegion"] as! [String: Double]
    let lat = coordinateDict["lat"]
    let lon = coordinateDict["lon"]
    let sLat = coordinateDict["spanLat"]
    let sLon = coordinateDict["spanLon"]
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat!, longitude: lon!), span: MKCoordinateSpan(latitudeDelta: sLat!, longitudeDelta: sLon!))
    print("\(region)")
//    return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat!, longitude: lon!), span: MKCoordinateSpan(latitudeDelta: sLat!, longitudeDelta: sLon!))
    return region
  }
}
