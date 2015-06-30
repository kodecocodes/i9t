//
//  TopographicMapOverlayView.swift
//  Topo
//
//  Created by Derek Selander on 6/28/15.
//  Copyright © 2015 RayWenderlich. All rights reserved.
//

import UIKit
import MapKit 

class TopographicMapOverlayView: MKOverlayRenderer {
    private var overlayImage : UIImage!
    
    override init(overlay: MKOverlay) {
        let image = (overlay as! TopographicMapOverlay).image
        self.overlayImage = image
        super.init(overlay: overlay)
    }
    
    override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext) {
        
        let overlayRect = self.overlay.boundingMapRect;
        let imageRef = self.overlayImage.CGImage
        let rect = self.rectForMapRect(overlayRect)
        
        CGContextScaleCTM(context, 1.0, -1.0)
        
        // Debugging
        CGContextSetFillColorWithColor(context, UIColor.purpleColor().CGColor)
        CGContextTranslateCTM(context, 0.0, -rect.size.height)

        CGContextFillRect(context, rect)
        CGContextDrawImage(context, rect, imageRef)
    }

}


