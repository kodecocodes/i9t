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
    self.loadMapBundlesIfPresent()
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
    return HistoricMapOverlayView(overlay: overlay)
  }
  
//=============================================================================/
// Mark: Private Methods
//=============================================================================/
  
  private func loadMapBundlesIfPresent() {
//    for data in HistoricMapOverlayData.generateDefaultData() {
//      let bundleRequest = NSBundleResourceRequest(tags: [data.assetTitle])
//      bundleRequest.conditionallyBeginAccessingResourcesWithCompletionHandler({ (resourcesAvailable: Bool) -> Void in
//        if resourcesAvailable {
//          let (dict, image) = bundleRequest.extractMapContentBundleWithTitle(data.assetTitle)
//          let overlay = HistoricMapOverlay(auxillaryInfo: dict, image: image)
//          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//            self.mapView.addOverlay(overlay)
//          })
//        }
//      })
//    }
  }
  
  private func downloadAndDisplayMapOverlay() {
    guard let mapData = self.mapOverlayData else {
      return
    }
    
    let bundleRequest = NSBundleResourceRequest(tags:[mapData.assetTitle])
    
    bundleRequest.conditionallyBeginAccessingResourcesWithCompletionHandler { (resourcesAvailable) -> Void in
      
      if !resourcesAvailable {
        bundleRequest.beginAccessingResourcesWithCompletionHandler { (error : NSError?) -> Void in
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            if error != nil {
              // Handle error here
            } else {
              self.bundleRequests.insert(bundleRequest)
              let (dict, image) = bundleRequest.extractMapContentBundleWithTitle(mapData.assetTitle)
              let overlay = HistoricMapOverlay(auxillaryInfo: dict, image: image)
              self.mapView.addOverlay(overlay)
              self.mapView.setRegion(overlay.region, animated: true)
            }
          })
        }
      } else {
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          
          let (dict, image) = bundleRequest.extractMapContentBundleWithTitle(mapData.assetTitle)
          let overlay = HistoricMapOverlay(auxillaryInfo: dict, image: image)
          self.mapView.setRegion(overlay.region, animated: true)
        })
      }
    }
  }
}

