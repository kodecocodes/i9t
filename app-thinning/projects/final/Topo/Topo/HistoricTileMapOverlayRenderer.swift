//
//  HistoryMapOverlayView.swift
//  Topo
//
//  Created by Derek Selander on 6/28/15.
//  Copyright © 2015 RayWenderlich. All rights reserved.
//

import UIKit
import MapKit

class HistoricTileMapOverlayRenderer: MKTileOverlayRenderer {
  private var overlayImage : UIImage!
  
  override init(tileOverlay overlay: MKTileOverlay) {
    let image = (overlay as! HistoricTileMapOverlay).image
    self.overlayImage = image
    super.init(overlay: overlay)
  }
  
  override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext) {
    
    let overlayRect = self.overlay.boundingMapRect;
    let imageRef = self.overlayImage.CGImage
    let rect = self.rectForMapRect(overlayRect)
    
    CGContextScaleCTM(context, 1.0, -1.0)
    CGContextTranslateCTM(context, 0.0, -rect.size.height)
    CGContextDrawImage(context, rect, imageRef)
  }
  
}


