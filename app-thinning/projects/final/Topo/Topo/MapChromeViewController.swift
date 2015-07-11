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
    
    self.loadingProgressView.progress = 0
    self.loadingProgressView.hidden = true
    
    self.downloadAndDisplayMapOverlay()
    
    
    let barButton = self.splitViewController!.displayModeButtonItem()
    self.navigationItem.leftBarButtonItem = barButton
    self.navigationItem.leftItemsSupplementBackButton = true
    
    // Uncomment this for debugging
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Debug", style: UIBarButtonItemStyle.Plain, target: self, action: "debugButtonTapped:")
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleLowDiskSpaceNotification:", name: NSBundleResourceRequestLowDiskSpaceNotification, object: nil)
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
  
  private func downloadAndDisplayMapOverlay() {
    guard let mapData = self.mapOverlayData else {
      return
    }
    
    let bundleRequest = NSBundleResourceRequest(tags:[mapData.bundleTitle])
    
    bundleRequest.conditionallyBeginAccessingResourcesWithCompletionHandler { (resourcesAvailable) -> Void in
      
      if resourcesAvailable == false {
        self.loadingProgressView.observedProgress = bundleRequest.progress
        self.loadingProgressView.hidden = false 
        bundleRequest.beginAccessingResourcesWithCompletionHandler { (error : NSError?) -> Void in
          
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            self.loadingProgressView.hidden = true
            
            if error != nil {
              // Handle error here
            } else {
              self.bundleRequests.insert(bundleRequest)
              let (auxillaryInfo, path) = bundleRequest.bundle.extractMapContentBundleWithTitle(mapData.bundleTitle)
              let overlay = HistoricTileMapOverlay(titleDirectory: path, auxillaryInfo: auxillaryInfo)
              self.mapView.addOverlay(overlay)
              self.mapView.setVisibleMapRect(overlay.boundingMapRect, animated: true)
            }
            
          })
        }
      } else {
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          let (auxillaryInfo, path) = bundleRequest.bundle.extractMapContentBundleWithTitle(mapData.bundleTitle)
          let overlay = HistoricTileMapOverlay(titleDirectory: path, auxillaryInfo: auxillaryInfo)
          self.mapView.setVisibleMapRect(overlay.boundingMapRect, animated: true)
        })
      }
    }
  }
  
}

