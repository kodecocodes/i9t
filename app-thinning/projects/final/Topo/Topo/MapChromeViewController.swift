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
  
  var mapOverlayData: HistoricMapOverlayData!
  private var bundleRequests: Set<NSBundleResourceRequest> = []
  
  
//=============================================================================/
// Mark: Lifetime
//=============================================================================/
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.mapView.showsCompass = true
    self.mapView.showsScale = true
    self.mapView.showsTraffic = true 
    self.downloadAndDisplayMapOverlay()

    
    let barButton = self.splitViewController!.displayModeButtonItem()
    self.navigationItem.leftBarButtonItem = barButton
    self.navigationItem.leftItemsSupplementBackButton = true
    
    // Uncomment this for debugging
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Debug", style: UIBarButtonItemStyle.Plain, target: self, action: "debugButtonTapped:")
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleLowDiskSpaceNotification:", name: NSBundleResourceRequestLowDiskSpaceNotification, object: nil)
  }
  
  override func didReceiveMemoryWarning() {
    if let overlay = self.mapView.overlays.first {
      self.mapView.removeOverlay(overlay)
    }
  }
  
//=============================================================================/
// Mark: IBAction Methods
//=============================================================================/
  
  @IBAction func opacitySliderChanged(sender: UISlider) {
    for overlay in self.mapView.overlays {
      let renderer = self.mapView.rendererForOverlay(overlay)
      renderer?.alpha = CGFloat(sender.value)
    }
  }
  
  func debugButtonTapped(button: UIBarButtonItem) {
    NSNotificationCenter.defaultCenter().postNotificationName(NSBundleResourceRequestLowDiskSpaceNotification, object: nil)
  }
  
  func handleLowDiskSpaceNotification(notification: NSNotification) {
    for bundleRequest in self.bundleRequests {
      bundleRequest.endAccessingResources()
    }
  }

//=============================================================================/
// Mark: MKMapViewDelegate
//=============================================================================/
  
  func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
    
    return HistoricTileMapOverlayRenderer(tileOverlay: overlay as! MKTileOverlay)
  }
  
  
  
//=============================================================================/
// Mark: Private Methods
//=============================================================================/
  
//  private func loadMapBundlesIfPresent() {
////    for data in HistoricMapOverlayData.generateDefaultData() {
////      let bundleRequest = NSBundleResourceRequest(tags: [data.assetTitle])
////      bundleRequest.conditionallyBeginAccessingResourcesWithCompletionHandler({ (resourcesAvailable: Bool) -> Void in
////        if resourcesAvailable {
////          let (dict, image) = bundleRequest.extractMapContentBundleWithTitle(data.assetTitle)
////          let overlay = HistoricMapOverlay(auxillaryInfo: dict, image: image)
////          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
////            self.mapView.addOverlay(overlay)
////          })
////        }
////      })
////    }
//  }
  
  private func downloadAndDisplayMapOverlay() {
    guard let mapData = self.mapOverlayData else {
      return
    }
    
    let bundleRequest = NSBundleResourceRequest(tags:[mapData.assetTitle])
    
    bundleRequest.conditionallyBeginAccessingResourcesWithCompletionHandler { (resourcesAvailable) -> Void in
      
      if !resourcesAvailable {
        self.loadingProgressView.observedProgress = bundleRequest.progress
        bundleRequest.beginAccessingResourcesWithCompletionHandler { (error : NSError?) -> Void in
          
          
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            self.loadingProgressView.hidden = true 
            
            if error != nil {
              // Handle error here
            } else {
              self.bundleRequests.insert(bundleRequest)
              let (_, _, path) = bundleRequest.extractMapContentBundleWithTitle(mapData.assetTitle)
              let overlay = HistoricTileMapOverlay(titleDirectory: path)
              self.mapView.addOverlay(overlay)
//              let rect = self.mapView.mapRectThatFits(overlay.boundingMapRect, edgePadding: UIEdgeInsets(top: 10, left: 1000, bottom: 10, right: 1000=))
//              self.mapView.setVisibleMapRect(rect, animated: true)
              self.mapView.setVisibleMapRect(overlay.boundingMapRect, animated: true)
              
//              self.mapView.setRegion(overlay.region, animated: true)
            }
          })
        }
      } else {
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          
          let (_, _, path) = bundleRequest.extractMapContentBundleWithTitle(mapData.assetTitle)
          let overlay = HistoricTileMapOverlay(titleDirectory: path)
          self.mapView.addOverlay(overlay) // Needed ?
          self.mapView.setVisibleMapRect(overlay.boundingMapRect, animated: true)
        })
      }
    }
  }
}

