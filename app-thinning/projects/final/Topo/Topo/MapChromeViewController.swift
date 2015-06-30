//
//  ViewController.swift
//  Topo
//
//  Created by Derek Selander on 6/28/15.
//  Copyright © 2015 RayWenderlich. All rights reserved.
//

import UIKit
import MapKit 

class MapChromeViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var loadingProgressView: UIProgressView!
    @IBOutlet weak var mapView: MKMapView!
    
    private var bundleRequests: Set<NSBundleResourceRequest> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleLowDiskSpaceNotification:", name: NSBundleResourceRequestLowDiskSpaceNotification, object: nil)
        
        
        self.setupMapViewport()
        
        let bundleRequest = NSBundleResourceRequest(tags:["SF_Map"])
        bundleRequest.beginAccessingResourcesWithCompletionHandler { (error : NSError?) -> Void in
            
            if error != nil {
                assert(false)
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.bundleRequests.insert(bundleRequest)
                let (dict, image) = bundleRequest.extractMapContentBundleWithTitle("SF_Map")
                let overlay = TopographicMapOverlay(auxillaryInfo: dict, image: image)
                self.mapView.addOverlay(overlay)
            })
        }
    }
    
    @IBAction func opacitySliderChanged(sender: UISlider) {
        for overlay in self.mapView.overlays {
            let renderer = self.mapView.rendererForOverlay(overlay)
            renderer?.alpha = CGFloat(sender.value)
        }
    }

    private func setupMapViewport() {
        self.mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.185167, longitude: -120.0), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    }

    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        return TopographicMapOverlayView(overlay: overlay)
    }
    
    private func handleLowDiskSpaceNotification(notification : NSNotification) {
        self.mapView.removeOverlays(self.mapView.overlays)
        for bundleRequest in self.bundleRequests {
            bundleRequest.endAccessingResources()
        }
        
    }

}

