
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
  
  var mapOverlayData: HistoricMapOverlayData?
  var overlayBundleResource: NSBundleResourceRequest?
  
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
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    self.overlayBundleResource?.endAccessingResources()
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
    guard let bundleTitle = self.mapOverlayData?.bundleTitle else {
      return
    }
    
    let bundleResource = NSBundleResourceRequest(tags: [bundleTitle])
    self.overlayBundleResource = bundleResource
    bundleResource.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent

    self.loadingProgressView.observedProgress = bundleResource.progress
    
    self.loadingProgressView.hidden = false
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    
    bundleResource.beginAccessingResourcesWithCompletionHandler {[weak self] (error) -> Void in
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        self?.loadingProgressView.hidden = true
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if error == nil {
          self?.displayOverlayFromBundle(bundleResource.bundle)
        }
      })
    }
  }
  
  func displayOverlayFromBundle(bundle: NSBundle) {
    guard let mapOverlayData = self.mapOverlayData else {
      return
    }
    
    let (auxillaryInfo, path) = bundle.extractMapContentBundleWithTitle(mapOverlayData.bundleTitle)
    let overlay = HistoricTileMapOverlay(titleDirectory: path, auxillaryInfo: auxillaryInfo)
    self.mapView.addOverlay(overlay)
    self.mapView.setVisibleMapRect(overlay.boundingMapRect, animated: true)
  }
  
}

