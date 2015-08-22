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

class CoffeeShopPinDetailView : UIView {
  
  @IBOutlet var hoursLabel: UILabel!
  @IBOutlet var descriptionLabel: UILabel!
  @IBOutlet var departureLabel: UILabel!
  @IBOutlet var arrivalLabel: UILabel!
  @IBOutlet var timeStackView: UIStackView!
  
  @IBOutlet var openCloseStatusImage: UIImageView!
  @IBOutlet var priceGuideImages: [UIImageView]!
  @IBOutlet var ratingImages: [UIImageView]!
  
  var currentUserLocation: CLLocationCoordinate2D?
  
  var coffeeShop: CoffeeShop! {
    didSet {
      descriptionLabel.text = coffeeShop.details
      
      updateRating()
      updatePriceGuide()
      updateOpeningHours()
      updateShopAvailability()
    }
  }
  
  override func awakeFromNib() {
    timeStackView.hidden = true
  }
  
  //MARK:- Updating UI
  private func updateRating() {
    var count = coffeeShop.rating.value
    for imageView in ratingImages {
      if (count > 0) {
        imageView.hidden = false
        count--
      } else {
        imageView.hidden = true
      }
    }
  }
  
  private func updatePriceGuide() {
    var count = coffeeShop.priceGuide.rawValue
    for imageView in priceGuideImages {
      if (count > 0) {
        imageView.hidden = false
        count--
      } else {
        imageView.hidden = true
      }
    }
  }
  
  private func updateOpeningHours() {
    let startTime = shortDateFormatter.stringFromDate(coffeeShop.openTime)
    let endTime = shortDateFormatter.stringFromDate(coffeeShop.closeTime)
    
    hoursLabel.text = "\(startTime) - \(endTime)"
  }
  
  private func updateShopAvailability() {
    let isOpen = coffeeShop.isOpenAtTime(NSDate())
    
    if isOpen {
      openCloseStatusImage.image = UIImage(named: "cafetransit_icon_open")
    } else {
      openCloseStatusImage.image = UIImage(named: "cafetransit_icon_closed")
    }
  }
  
  private func updateEstimatedTimeLabels(response: MKETAResponse?) {
    if let response = response {
      self.departureLabel.text = shortDateFormatter.stringFromDate(response.expectedDepartureDate)
      self.arrivalLabel.text = shortDateFormatter.stringFromDate(response.expectedArrivalDate)
    }
  }
}

extension CoffeeShopPinDetailView {
  
  //MARK:- IBActions
  @IBAction func phoneTapped() {
    let phoneString = "tel://" + coffeeShop.phone
    if let url = NSURL(string: phoneString) {
      UIApplication.sharedApplication().openURL(url)
    }
  }
  
  @IBAction func transitTapped() {
    //TODO: Open transit directions in Maps
  }
  
  @IBAction func internetTapped() {
    if let url = NSURL(string: coffeeShop.yelpWebsite) {
      UIApplication.sharedApplication().openURL(url)
    }
  }
  
  @IBAction func timeTapped() {
    if timeStackView.hidden {
      animateView(timeStackView, toHidden: false)
      //TODO: Calculate transit ETA
    } else {
      animateView(timeStackView, toHidden: true)
    }
  }
  
  private func animateView(view: UIView, toHidden hidden: Bool) {
    UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10.0, options: UIViewAnimationOptions(), animations: {
      view.hidden = hidden
      }, completion: nil)
  }
  
  //MARK:- Transit Helpers
  
}
