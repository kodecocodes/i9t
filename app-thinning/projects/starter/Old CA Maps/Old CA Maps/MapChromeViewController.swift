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
  
//=============================================================================/
// Mark: Lifetime
//=============================================================================/
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.showsCompass = true
    mapView.showsScale = true
    mapView.showsTraffic = true
    
    loadingProgressView.progress = 0
    loadingProgressView.hidden = true
    
    downloadAndDisplayMapOverlay()
    
    let barButton = splitViewController!.displayModeButtonItem()
    navigationItem.leftBarButtonItem = barButton
    navigationItem.leftItemsSupplementBackButton = true
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    parentViewController?.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
    parentViewController?.navigationController?.navigationBar.translucent = true
    parentViewController?.navigationController?.navigationBar.alpha = 0.8
    
    guard let mapOverlayData = mapOverlayData else {
      return
    }
    let color: UIColor
    switch mapOverlayData.title {
    case "Santa Cruz":
      color = UIColor.SantaCruzColor()
    case "Sunnyvale":
      color = UIColor.SunnyvaleColor()
    case "San Francisco":
      color = UIColor.SanFranciscoColor()
    case "San Diego":
      color = UIColor.SanDiegoColor()
    case "Los Angeles":
      color = UIColor.LosAngelesColor()
    default:
      color = UIColor.whiteColor()
    }
    
    if let parentNavigationController = parentViewController?.navigationController {
      parentNavigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : color]
    } else {
      navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : color]
    }
    UISlider.appearance().tintColor = color
  }
  
//=============================================================================/
// Mark: IBAction Methods
//=============================================================================/
  
  @IBAction func opacitySliderChanged(sender: UISlider) {
    for overlay in mapView.overlays {
      let renderer = mapView.rendererForOverlay(overlay)
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
    displayOverlayFromBundle(NSBundle.mainBundle())
  }
  
  func displayOverlayFromBundle(bundle: NSBundle) {
    guard let mapOverlayData = mapOverlayData else {
      return
    }
    
    let (auxillaryInfo, path) = bundle.extractMapContentBundleWithTitle(mapOverlayData.bundleTitle)
    let overlay = HistoricTileMapOverlay(titleDirectory: path, auxillaryInfo: auxillaryInfo)
    mapView.addOverlay(overlay)
    mapView.setVisibleMapRect(overlay.boundingMapRect, animated: true)
  }
  
}

