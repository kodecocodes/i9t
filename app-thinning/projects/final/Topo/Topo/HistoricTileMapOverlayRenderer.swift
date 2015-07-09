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
    
    let historicOverlay = self.overlay as! HistoricTileMapOverlay
    let tilesInRect = historicOverlay.tilesInMapRect(mapRect, scale: zoomScale)
    
    for tile in tilesInRect {
    
      let rect = self.rectForMapRect(tile.mapRect)
      let image = UIImage(contentsOfFile: tile.imagePath)!
      CGContextSaveGState(context);
      CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
      CGContextScaleCTM(context, 1/zoomScale, 1/zoomScale);
      CGContextTranslateCTM(context, 0, image.size.height);
      CGContextScaleCTM(context, 1, -1);
      let drawRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
      CGContextDrawImage(context, drawRect, image.CGImage);
      CGContextRestoreGState(context);
      
    }
    
 
  }
  
  
  override func canDrawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale) -> Bool {
    let historicOverlay = self.overlay as! HistoricTileMapOverlay
    let tilesInRect = historicOverlay.tilesInMapRect(mapRect, scale: zoomScale)
    return tilesInRect.count > 0 ? true : false
  }

  
  
  
}


