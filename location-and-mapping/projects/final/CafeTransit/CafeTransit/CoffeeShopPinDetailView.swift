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
	@IBOutlet var ratingsLabel: UILabel!
	@IBOutlet var hoursLabel: UILabel!
	@IBOutlet var priceGuide: UILabel!
	@IBOutlet var descriptionLabel: UILabel!
	
	@IBOutlet var departureLabel: UILabel!
	@IBOutlet var arrivalLabel: UILabel!
	@IBOutlet var travelTimeLabel: UILabel!
	
	@IBOutlet var timeStackView: UIStackView!
	var coffeeShop: CoffeeShop?
	
	var view: UIView!
	var nibName: String = "CoffeeShopPinDetailView"
	
	private static var dateFormatter = NSDateFormatter()
	
	override func awakeFromNib() {
		timeStackView.hidden = true
	}
	
	//MARK: Update UI
	func updateDetailView(coffeeShop: CoffeeShop) {
		self.coffeeShop = coffeeShop
		ratingsLabel.text = coffeeShop.rating.description
		descriptionLabel.text = coffeeShop.details
		priceGuide.text = coffeeShop.priceGuide.description
		
		CoffeeShopPinDetailView.dateFormatter.dateFormat = "h:mm a"
		let startTime = CoffeeShopPinDetailView.dateFormatter.stringFromDate(coffeeShop.startTime!)
		let endTime = CoffeeShopPinDetailView.dateFormatter.stringFromDate(coffeeShop.endTime!)
		hoursLabel.text = "Time: \(startTime) - \(endTime)"
	}
	
	func updateEstimatedTimeLabels(response: MKETAResponse?) {
		if let response = response {
			CoffeeShopPinDetailView.dateFormatter.dateFormat = "EEE MMM dd h:mm a"
			
			let arrivalTimeString = CoffeeShopPinDetailView.dateFormatter.stringFromDate(response.expectedArrivalDate)
			let departureTimeString = CoffeeShopPinDetailView.dateFormatter.stringFromDate(response.expectedDepartureDate)
			
			let departureTime = String(format: "Depart at: %@", departureTimeString)
			let arrivalTime = String(format: "Arrive at: %@", arrivalTimeString)
			let travelTime = String(format: "%d min away by public transport.", Int(response.expectedTravelTime / 60))
			
			self.departureLabel.text = departureTime
			self.arrivalLabel.text = arrivalTime
			self.travelTimeLabel.text = travelTime
		}
	}
	
	//MARK: Tapping Icons
	@IBAction func phoneTapped(sender: AnyObject) {
		if let phone = self.coffeeShop?.phone {
			let phoneString = "tel://" + phone
			if let url = NSURL(string: phoneString) {
				UIApplication.sharedApplication().openURL(url)
			}
		}
	}
	
	@IBAction func transitTapped(sender: AnyObject) {
		if let location = self.coffeeShop?.location {
			openInMapTransit(location)
		}
	}
	
	@IBAction func internetTapped(sender: AnyObject) {
		if let website = self.coffeeShop?.yelpWebsite {
			UIApplication.sharedApplication().openURL(NSURL(string: website)!)
		}
	}
	
	private func animateView(view: UIView, toHidden hidden: Bool) {
		UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10.0, options: UIViewAnimationOptions(), animations: { () -> Void in
			view.hidden = hidden
			}, completion: nil)
	}
	
	@IBAction func timeTapped(sender: AnyObject) {
		if timeStackView.hidden {
			animateView(timeStackView, toHidden: false)
		} else {
			animateView(timeStackView, toHidden: true)
		}
	}
	
	private func animateView(view: UIView,hidden: Bool) {
		UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10.0, options: UIViewAnimationOptions(), animations: { () -> Void in
			view.hidden = hidden
			}, completion: nil)
	}
	
	//MARK: Transit Helpers
	func openInMapTransit(coord:CLLocationCoordinate2D) {
		let placemark = MKPlacemark(coordinate: coord, addressDictionary: nil)
		let mapItem = MKMapItem(placemark: placemark)
		let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit]
		mapItem.openInMapsWithLaunchOptions(launchOptions)
	}
	
	func setTransitEstimatedTimes(currentLocation: CLLocationCoordinate2D) {
		let request = MKDirectionsRequest()
		
		let source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation, addressDictionary: nil))
		let destination = MKMapItem(placemark: MKPlacemark(coordinate: (self.coffeeShop?.location)!, addressDictionary: nil))
		request.source = source
		request.destination = destination
		//Set Transport Type to be Transit
		request.transportType = MKDirectionsTransportType.Transit
		
		let directions = MKDirections(request: request)
		directions.calculateETAWithCompletionHandler { response, error in
			if let error = error {
				print(error.localizedDescription)
			} else {
				self.updateEstimatedTimeLabels(response)
			}
		}
	}
}

extension UIView {
	class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
		return UINib(
			nibName: nibNamed,
			bundle: bundle
			).instantiateWithOwner(nil, options: nil)[0] as? UIView
	}
}
