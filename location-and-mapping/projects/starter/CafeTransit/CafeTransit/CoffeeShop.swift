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
import CoreLocation

enum PriceGuide : Int {
	case Unknown = 0
	case Low = 1
	case Medium = 2
	case High = 3
}

extension PriceGuide : CustomStringConvertible {
	var description : String {
		switch self {
		case .Unknown:
			return "?"
		case .Low:
			return "💰"
		case .Medium:
			return "💰💰"
		case .High:
			return "💰💰💰"
		}
	}
}

enum CoffeeRating {
	case Unknown
	case Rating(Int)
}

extension CoffeeRating {
	init?(value: Int) {
		if value > 0 && value <= 5 {
			self = .Rating(value)
		} else {
			self = .Unknown
		}
	}
	
	var value : Int {
		switch self {
		case .Unknown:
		  return 0
		case .Rating(let value):
			return value
		}
	}
}

extension CoffeeRating : CustomStringConvertible {
	var description : String {
		switch self {
		case .Unknown:
			return ""
		case .Rating(let value):
			var rating = ""
			for var index = 0; index < value; ++index {
				rating += "★"
			}
			return rating
		}
	}
}

struct CoffeeShop {
	let name: String
	let priceGuide: PriceGuide
	let location: CLLocationCoordinate2D?
	let details: String
	let rating: CoffeeRating
	let yelpWebsite: String
	let startTime: NSDate?
	let endTime: NSDate?
	let phone: String
}

extension CoffeeShop {
	init?(dict: [String : AnyObject]) {
		guard let name = dict["name"] as? String,
			let phone = dict["phone"] as? String,
			let yelpWebsite = dict["yelpWebsite"] as? String,
			let priceGuideRaw = dict["priceGuide"] as? Int,
			let priceGuide = PriceGuide(rawValue: priceGuideRaw),
			let details = dict["details"] as? String,
			let ratingRaw = dict["rating"] as? Int,
			let rating = CoffeeRating(value: ratingRaw) else {
				return nil
		}
		
		self.name = name
		self.phone = phone
		self.yelpWebsite = yelpWebsite
		self.priceGuide = priceGuide
		self.details = details
		self.rating = rating
		
		if let latitude = dict["latitude"] as? Double,
			let longitude = dict["longitude"] as? Double {
				location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		} else {
			location = nil
		}
		
		if let openTime = dict["openTime"] as? NSDate {
			startTime = openTime
		} else {
			startTime = nil
		}
		
		if let closeTime = dict["closeTime"] as? NSDate {
			endTime = closeTime
		} else {
			endTime = nil
		}
	}
}

extension CoffeeShop {
	static func loadDefaultCoffeeShops() -> [CoffeeShop]? {
		return loadCoffeeShopsFromPlistNamed("sanfrancisco_coffeeshops")
	}
	
	static func loadCoffeeShopsFromPlistNamed(plistName: String) -> [CoffeeShop]? {
		guard let path = NSBundle.mainBundle().pathForResource(plistName, ofType: "plist"),
			let array = NSArray(contentsOfFile: path) as? [[String : AnyObject]] else {
				return nil
		}
		return array.flatMap { CoffeeShop(dict: $0) }
	}
}

extension CoffeeShop : CustomStringConvertible {
	var description : String {
		return "\(name) :: \(details)"
	}
}
