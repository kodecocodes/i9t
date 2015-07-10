//
//  ImageTile.swift
//  Topo
//
//  Created by Derek Selander on 7/8/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit
import MapKit
class ImageTile: NSObject {
  
  let imagePath: String
  let mapRect: MKMapRect
  
  init(imagePath: String, mapRect: MKMapRect) {
    self.imagePath = imagePath
    self.mapRect = mapRect
  }
}
