# Chapter 12: Location and Mapping

Apple continues to enhance its Map and Location's framework every year. Developers that incorporate MapKit into their apps should look forward to improved tools that yield greater user experiences.

Prior to the upgrade/Before, only directions to our desired destinations were available via walking and driving. Now, Maps also provides Transit, informing users of the various metro stops available en route to their destination.  

In addition, Apple has released their flyover API, enabling the inclusion of flyovers within applications. These enhancements further boost the customizability of MapKit.

Lastly, Core Locations complements MapKit by allowing the location framework to be much more user friendly. Apple designed this API with the users in mind, focusing on device battery life and how to improve background location fetching.

In this chapter you will be introduced to:
* The customizability of MapKit’s appearance
*	The use of Transit API
*	The estimation of travel time duration
*	How to request user’s location in a straightforward way

This chapter is an introduction to MapKit and is a great way to kick-start your learning about the changes to Maps in iOS9!

## Getting Started
Is coffee a staple in your trek to that final exam, or the key to how the rest of your day will unfold? Whether you are a student, working professional or simply just a coffee aficionado, Café Transit is an app that can ease your search for coffee. Access information about coffee shops around your area through Café Transit and receive directions to them! The app lets you know when to get going, so you will never be late again.

By the end of the tutorial, the app you will create will look like this:
![iPhone](images/Final.png)

Open **CafeTransit-Starter** and run it on the iPhone 6 Simulator.

![iPhone](images/starter.png)

The starter app is using the standard MapKit features that existed before. Other than clicking on a pin to reveal the title and mini description, there's a limit to what you can do right now.

### What's included in the starter project

Now open **ViewController.swift**; you can see that you have setup the initial properties to customize the map, and centered it around San Francisco. You also loaded the sample coffee shop data and created a pin (**CoffeeShopPin.swift**) for each shop and placed it on the map.

Lastly you may have noticed a prebuild custom view. **CoffeeShopPinDetailView.swift** and **CoffeeShopPinDetailView.xib** will be used to spice up the interaction on the map view. The outlets and helper methods to update the UI has already been created so you can focus on what's new with MapKit!

Your first task is to customize the map's appearance.

## Customizing Map View's appearance

Before, only the decision on whether to hide places of interest and buildings on the map could be controlled. The framework introduces three new boolean properties. You can now show/hide the map's `compass`, `scale`, and `traffic`, which provides less clutter for your app. This clean customization allows users to focus on the content of your app by filtering out the traffic. Now go ahead and transform the appearance of your map!

![iPhone](images/compasstrafficscale.png)

Open **ViewController.swift** and add the following code at the very beginning of `customizeMap`:
```swift
mapView.showsTraffic = false
mapView.showsCompass = false
mapView.showsScale = false
```

Depending on the contents of your apps, it may also be useful to show some of these features on the map!

## Customizing Map Pins

Before, you could only make the pin color red, green or purple by changing `pinColor`. The property `pinColor` in **MKPinAnnotationView** is now deprecated.
You can now use any color you want by setting `pinTintColor`. FINALLY!

![iPhone](images/rainbow.png)

So within `mapView:ViewForAnnotation` your task is to change the pin's color with the endless options of colors that can now be used!

## Customizing Callout

A callout is a popover that appears above your annotation view on the map. This callout provides subtle information regarding a particular location. The old callout is very limited in its customization. While allowing you to set the title, subtitle and left/right accessory views, only two lines of text can be shown via the old callout.

![iPhone](images/defaultcallout.png)

In order to further customize your callout, you can now use a new property: `detailCalloutAccessoryView`, a subclass of `UIView`. This means that almost any UI component can be added to the detail view. For example: the new UIStackView, or something as crazy as a Collection View!

### Ways to change the detail callout's size
The callout is built on auto layout, and unfortunately there is no properties that the framework has exposed to explicitly resize the height or width of your callout. There are **two** ways to change the size of the accessory view:
1. The view you set has to use auto layout and let intrinsic content size do its  thing.
2. You can override `intrinsicContentSize`, and pass in your own size.

For more information on this please refer to this documentation:
TODO: btly
https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/ImplementingView/ImplementingView.html

For this app, you are going to use technique one, and learn to use a xib to create your custom view. The project navigator contains a pre-created custom view using a xib. Its contents is organized using the new UIStackView component.

When a coffee pin is tapped on, the detail view will show various information about that coffee shop.

Feel free to explore how the xib makes use of UIStackView and constraints.

![iPhone](images/customview.png)

### Adding the detail view to the callout
Open **ViewController.swift** and add the following code in `mapView:viewForAnnotation` within the `guard` statement of `dequeuedView` just before returning the `view`:

```swift
let detail = UIView.loadFromNibNamed("CoffeeShopPinDetailView") as! CoffeeShopPinDetailView
detail.updateDetailView(annotation.coffeeshop!)
view.detailCalloutAccessoryView = detail
```
Here's a line-by-line explanation of the code above:
1. Create the detail view by initializing the nib.
2. Pass the coffee shop's information so the custom view can update its UI.
3. Set the callout's detail view with our custom view.

It's that simple! Build and run your app, click on one of the pins and you should now see the following:

![iPhone](images/addingDetailView.png)

>**Note**:
Clicking on the phone button will only work on an actual device. Currently, you should only be able to click the yelp button which will open up safari and take you to the shop's yelp review. You can also click the clock button, but has static text. You will implement actions for transit and the time buttons later in this chapter.

Try adding a custom view to a callout! This creates opportunities for developers to open source their own custom views designs for map's callouts.

## User Location Simulator Initial Setup

Now let's shift our attention from MapKit to understanding how to set up the user's current location. When running location based apps on the iOS Simulator, you need to set up a default location to test on.

![iPhone](images/defaultLocation1.png)
You do this by clicking **CafeTransit** target, and select **Edit Scheme...**

![iPhone](images/defaultLocation2.png)
Now go to **Options** and set your default location to **San Francisco, CA, USA**. Your sample data is based in San Francisco.

## Core Location Overview - Single Location

Now that the scheme's default location is set up, you are ready to get the user's location whenever they run it on a real device! Apple has made it extremely easy for us to grab their location without a hassle in iOS 9. You will learn how to get the user's location with just one call in this section.

### Set Up Location Manager

First open **ViewController.swift** and add the following code just below the class definition:

```swift
let locationManager = CLLocationManager()
var currentLocation: CLLocationCoordinate2D?
```
The code creates a **CLLocationManager** object. This is used to access any location related information such as getting permission and obtaining the user's location. Also you create a **CLLocationCoordinate2D** property that will be used later to store the user's current location.

Next within **viewDidLoad** add these two lines:
```swift
locationManager.delegate = self
locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
```
Here you set the delegate for location manager, and you determine how accurate you want the coordinates to be. By setting **desiredAccuracy**, the system will attempt to determine the best accuracy for your location within the given range.

### Requesting Permission

>**Note:**
To save you some time location manager's authorization request for `requestWhenInUseAuthorization` has been setup for you within **Info.plist**  ![iPhone](images/plist.png)

Before accessing the user's location, it is courtesy to first ask for their permission. Add the following method in **ViewController.swift**

```swift
func askUserForPermissionToUseLocation() {
  if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse { //1
    mapView.showsUserLocation = true //2
    locationManager.requestLocation() //3

  } else {
    locationManager.requestWhenInUseAuthorization() //4
  }
}
```

Let's go over the code line by line:
1. Check to see if you have permission to use the user's location.
2. If you have permission, show the user's location on the map.
3. Find out where the user is by calling **requestLocation()**.
3. If you don't have permission to use the user's location, ask for it.

Lastly add the following code under **viewDidLoad()**:
```swift
override func viewDidAppear(animated: Bool) {
  super.viewDidAppear(animated)
  askUserForPermissionToUseLocation()
}
```
When the app first launches, it will check to see if the app has permission to use the user's location.

### Request Location

Core Location has simplified the way you get their location by calling a single method **requestLocation()**.

Before, you would have to start your location's update and watch multiple locations come into your delegate callback and then, determine which location is the most accurate to use. Once you determine the location to use, you have to remember to stop location updates. If you don't stop it, you will be draining the user's battery life!

**requestLocation()** automates all of this for you!

 When you call this method, it will start to get the location, and will only call your delegate once. It will also stop location updates for you when complete. This means you get to implement more features and spend less time debugging and fixing bugs!

 ![iPhone](images/winningBaby.jpg)

### Implement Delegate Method to get Location

Let's now go ahead and add the delegate methods to receive our location!

Within **ViewController.swift** add the following code at the very end of the last curly brace:

```swift
// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {

	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { //1
		guard let location = locations.first else { //2
			return
		}
		currentLocation = location.coordinate //3
	}

	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) { //4
		print("Error finding location: \(error.localizedDescription)")
	}
}
```

Here's a line by line explanation of the code:
1. `locationManager:didUpdateLocations` lets us know when new location data is available to grab.
2. Check to see if a location is found.
3. If a location is found, store it in `currentLocation` so you can reference it later on.
4. `locationManager:didFailWithError` lets us know when location manager has failed to retrieve a location.

Lastly in **ViewController.swift** add the following code within `MKMapViewDelegate` extension:
```swift
func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
  if let detail = view.detailCalloutAccessoryView as? CoffeeShopPinDetailView {
      detail.currentLocation = currentLocation
  }
}
```

Whenever an annotation is clicked on, we pass the current location into the detail callout.

>**Fun Fact**:
Background location updates and single location updates use the same delegate callbacks!

Build and Run your App, you should see a blue dot with a force field around it!

![iPhone](images/forcefield.png)

## Launching Map's Transit directions

Now that you have obtained the user's current location, you are now ready to get transit directions to your coffee shops! Open **CoffeeShopPinDetailView.swift** and add the following function below the function **animateView**:

```swift
//MARK: Transit Helpers
func openInMapTransit(coord:CLLocationCoordinate2D) {
	let placemark = MKPlacemark(coordinate: coord, addressDictionary: nil) // 1
	let mapItem = MKMapItem(placemark: placemark) //2
	let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit] //3
	mapItem.openInMapsWithLaunchOptions(launchOptions) //4
}
```

This is a helper method that will give you transit directions to the coordinates you pass in. Let's go over how this works:

1. Create a place mark that will be used to store your coordinates. Place mark usually has an associated address, but in this case we have none.
2. Initialize an `MKMapItem` with the place mark.
3. Specify that you want to launch maps in transit mode.
4. Launch Apple Maps to show directions to the location via transit.

Lastly replace the `TODO` code in `transitTapped` with the following:
```swift
@IBAction func transitTapped(sender: AnyObject) {
  if let location = self.coffeeShop?.location {
    openInMapTransit(location)
  }
}
```
Here you simply check to see if the coffee shop has a location, and launch transit directions to that coffee shop!

Build and Run your app, tap on a coffeeshop, and click the train icon to see it launch the transit directions to that coffee shop!

## Query Estimated Time of Arrival

Apple has brought us some really cool APIs within **MKETAResponse** as shown below:
```swift
public var expectedTravelTime: NSTimeInterval { get }
@available(iOS 9.0, *)
public var distance: CLLocationDistance { get } // overall route distance in meters
@available(iOS 9.0, *)
public var expectedArrivalDate: NSDate { get }
@available(iOS 9.0, *)
public var expectedDepartureDate: NSDate { get }
@available(iOS 9.0, *)
```
You are now able to obtain the distance, the expected duration of travel, arrival, and departure time. This is especially useful for travel based applications.

Before you had to rely on Google Maps API, or query some third party server for this information, but not anymore! You can now query Apple's very own server.

### How to calculate the response
If you tap a coffee shop and tap on the clock button, it animates upwards to show you the depart and arrival times. There is currently no mechanism to retrieve that information. So let's find out how to calculate estimated times of travel!

Open **CoffeeShopPinDetailView.swift** and add the following function just after **openInMapTransit**:

```swift
func setTransitEstimatedTimes() {
	if let currentLocation = currentLocation { //1
		let request = MKDirectionsRequest() //2
		let source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation, addressDictionary: nil)) //3
		let destination = MKMapItem(placemark: MKPlacemark(coordinate: (self.coffeeShop?.location)!, addressDictionary: nil)) //4
		request.source = source //5
		request.destination = destination
		//Set Transport Type to be Transit
		request.transportType = MKDirectionsTransportType.Transit //6

		let directions = MKDirections(request: request) //7
    //8
		directions.calculateETAWithCompletionHandler { response, error in
			if let error = error {
				print(error.localizedDescription)
			} else {
				self.updateEstimatedTimeLabels(response) //9
			}
		}
	}
}
```

Let's go over how you request for the times:
1. First check to see if you have the user's current location.
2. Create a **MKDirectionsRequest** object.
3. Create an **MKMapItem** to hold the user's current location.
4. Create an **MKMapItem** to hold the location of the coffee shop.
5. Set the source and destination.
6. Set the form of transportation to be transit.
7. Create **MKDirections** object  that will provide route based directions from Apple's servers.
8. Request directions from Apple's server by calling `calculateETAWithCompletionHandler`.
9. If the response is valid, update our departure and arrival labels based on the response.

Lastly in **CoffeeShopPinDetailView.swift** replace `timeTapped` with the following:

```swift
@IBAction func timeTapped(sender: AnyObject) {
  if timeStackView.hidden {
    animateView(timeStackView, toHidden: false)
    setTransitEstimatedTimes()
  } else {
    animateView(timeStackView, toHidden: true)
  }
}
```

When the time button is tapped, it animates upwards and sends a request to Apple's server to get the time estimates and updates your callout labels!

Build and run your app; Click on one of the coffee shop pins and click the clock. You should now get an update on when to leave and get there!

## Miscellaneous
**MKMapItem** now contains a `timeZone` property. This can be useful to find out what timezone a coordinate is in.

## Where to go to from here?

Congratulations! I hope you learned a lot about what's new with MapKit in iOS 9. The framework is always improving, and it's really exciting to see it get better every year! In this chapter, you have acquired the necessary skills to customize the map view, and techniques to add a custom view into a callout. Next you saw how simple it was to request the user's location. After that, you messed with some really sweet api related to transit, getting directions, and calculating the estimated times! Wasn't that awesome?

This touches upon most of the main topics in what's new with location and mapping in iOS 9.

This chapter did not cover the flyover, and background location updates. For more information or to continue learning about these, check out the WWDC talks below:

TODO: btly
https://developer.apple.com/videos/wwdc/2015/?id=206
https://developer.apple.com/videos/wwdc/2015/?id=714

Also keep a look out for Watch OS 2 By tutorials, and specialize tutorials related to flyover and background location updates in iOS 9.  
If you have any cool ideas or questions please refer to the forum, and start a discussion!
