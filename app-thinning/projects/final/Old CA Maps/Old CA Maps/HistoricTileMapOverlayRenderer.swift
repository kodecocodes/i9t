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

class HistoricTileMapOverlayRenderer: MKTileOverlayRenderer {
  
  override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext) {
    
    let historicOverlay = overlay as! HistoricTileMapOverlay
    let tilesInRect = historicOverlay.tilesInMapRect(mapRect, scale: zoomScale)
    
    for tile in tilesInRect {
      let rect = rectForMapRect(tile.mapRect)
      let image = UIImage(contentsOfFile: tile.imagePath)!
      CGContextSaveGState(context)
      CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect))
      CGContextScaleCTM(context, 1/zoomScale, 1/zoomScale)
      CGContextTranslateCTM(context, 0, image.size.height)
      CGContextScaleCTM(context, 1, -1)
      let drawRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
      CGContextDrawImage(context, drawRect, image.CGImage)
      CGContextRestoreGState(context)
    }
  }
  
  override func canDrawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale) -> Bool {
    let historicOverlay = overlay as! HistoricTileMapOverlay
    let tilesInRect = historicOverlay.tilesInMapRect(mapRect, scale: zoomScale)
    return tilesInRect.count > 0 ? true : false
  }

}


