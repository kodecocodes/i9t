```metadata
author: "By Vincent Ngo"
number: "14"
title: "Chapter 14: Location and Mapping"
```

# Chapter 14: Location and Mapping

Despite a slightly shaky start to its mapping effort in iOS 6, Apple has continued to enhance its mapping and location frameworks every year. iOS 9 is no exception, with a number of great updates to both MapKit and Core Location.

One of the most useful improvements is the addition of transit directions to Apple Maps, with assistance for navigating subways, trains, buses and more. Transit will launch in a small number of cities to start, but will likely roll out on a wider scale as time passes.

This chapter will show you how to take advantage of the following new features:

* New methods to customize the appearance of Maps in your app
* Transit directions in Apple Maps
* Estimated travel times for transit directions
* Single location updates using Core Location

The sample app for this chapter, Café Transit, is for all the coffee aficionados out there. It can help you in your eternal search for good coffee. Currently, it only shows a handful of nearby coffee shops (well, nearby if you're in San Francisco!) and marks them on the map using standard map pins.

By the time you've finished this chapter, your app will show lots of useful information for each coffee shop, including a rating, pricing information and opening hours. Your app will also provide transit directions to a particular coffee shop, and even let you know what time you'll need to leave and when you're likely to arrive.

> **Note**: This chapter will be easier to follow if you have some basic MapKit knowledge. If you need to brush up, take a look at our Getting Started With MapKit tutorial [bit.ly/1PrurqE](http://bit.ly/1PrurqE).

## Getting started

Open the starter project for this chapter. Run it up and you'll see it's built with a standard MapKit `MKMapView`; tap on a pin to reveal the coffee shop's name and a brief description:

![iPhone](images/01-starter.png)

Open **ViewController.swift**; `setupMap()` and `addMapData()` center the map on San Francisco and add an annotation to each coffee shop. The model code for coffee shops is in **CoffeeShop.swift**, which also takes care of loading all of the sample coffee shop data from **sanfrancisco_coffeeshops.plist**.

Finally, take a quick look at **CoffeeShopPinDetailView.swift** and **CoffeeShopPinDetailView.xib**; these define the custom annotations you'll add later to spice up the map view. These annotations will show a rating, price information, and opening hours — everything you need to make your app shine!

## Customizing maps

Prior to iOS 9, the only items you could programatically toggle on and off in an `MKMapView` were buildings and places of interest. MapKit in iOS 9 introduces three new boolean properties that let you toggle the map's **compass**, **scale bar** (the small ruler that shows distances on the map) and **traffic** display. You can choose to remove these to clean up your map display, or leave them on the screen to give your users extra information as they navigate:

![width=40%](images/02-compasstrafficscale.png)

Café Transit would benefit from showing the map's scale — giving the users an idea how far they have to go to get their caffeine fix.

Open **ViewController.swift** and add the following code at the very beginning of `setupMap()`:

```swift
mapView.showsScale = true
```

Build and run your app; you should see the scale appear in the top left of the map:

![width=60%](images/03-cafetransit-scale.png)

As you pan and zoom around the map, the scale updates itself to match the map's current zoom level.

### Customizing map pins

Since iOS 3, MapKit pins have had a `pinColor` property that let you select any color you wanted...as long as it was red, green or purple. But what if you wanted a yellow pin? Or an orange pin? Or a _chartreuse_ pin? You were out of luck.

iOS 9 deprecates the `pincolor` property on `MKPinAnnotationView` in favor of the shiny new `pinTintColor`. And get this — you can set it to _any color you like_!

![width=35%](images/04-rainbow.png)

Café Transit currently uses plain old red map pins, which don't really fit in with the coffee aesthetic. They'd look better with the same brown shade used throughout the app. And you could even use a different color to highlight cafés with a 5-star rating.

Add the following code to  `mapView(_:viewForAnnotation:)` in **ViewController.swift**, just before the `return` statement at the end:

```swift
if annotation.coffeeshop.rating.value == 5 {
  annotationView!.pinTintColor =
    UIColor(red:1, green:0.79, blue:0, alpha:1)
} else {
  annotationView!.pinTintColor =
    UIColor(red:0.419, green:0.266, blue:0.215, alpha:1)
}
```

This chooses a `pinTintColor` that depends on the star rating of the coffee shop; gold for a 5-star rating and brown otherwise.

Build and run your app, and check out your fancy new pins:

![iPhone](images/05-customizedMapPins.png)

## Customizing annotation callouts

Each map pin (or annotation view) can show a **callout** when you tap it. This is simply a popover that appears above your annotation view on the map, and can provide extra information about a particular location, like so:

![width=60%](images/06-defaultCallout.png)

Until now, you've been limited in your customization of annotation callouts; you could set a title, subtitle and left and right accessory views. For any other kind of customization, you had to try to add a custom view to the annotation view, which wasn't an easy task.

iOS 9 makes the whole process much simpler, with the new `detailCalloutAccessoryView` property on `MKAnnotationView`, You can set this to any view you like, which gives you almost unlimited customization options for your callouts. You could even use the new `UIStackView`, or some kind of crazy collection view if you so choose!

### Managing callout size

Callouts will use the _intrinsic content size_ of your custom view to size themselves appropriately. Your custom callouts can take advantage of this in two ways:

1. Use Auto Layout to lay out your custom view, and let intrinsic content size do its thing.
2. You can override `intrinsicContentSize` within your custom view size and return a size of your choice.

> **Note**: For more information on intrinsic content size and Auto Layout, take a look at Apple's "Implementing a Custom View to Work with Auto Layout" documentation: [apple.co/1PHbKA5](http://apple.co/1PHbKA5).

The XIB for `CoffeeShopPinDetailView` uses `UIStackView` and Auto Layout, so you don't have to manually specify `intrinsicContentSize`. Feel free to explore how the XIB makes use of `UIStackView` and constraints.

Custom callouts can't fill the entire area of the callout popover, since iOS adds the annotation title and a certain amount of padding. The screenshot below shows the area filled by `detailCalloutAccessoryView` in green:

![width=50%](images/07-customCalloutArea.png)

Keep this in mind when designing your custom callout views, as there's currently no way to modify the padding or title area.

### Adding a custom callout accessory view

With that theory out of the way, it's time to add a custom callout of your own. **CoffeeShopPinDetailView.xib** defines the UI for the callout accessory view as shown below:

![width=45%](images/08-customview.png)

The callout shows the opening hours, star and cost rating and a description of the coffee shop, along with a set of action buttons for such things as phoning the coffee shop or viewing their Yelp page.

Open **ViewController.swift** and add the following code to `mapView(_:viewForAnnotation:)`, just before the `return` statement:

```swift
let detailView = UIView.loadFromNibNamed(identifier) as!
  CoffeeShopPinDetailView
detailView.coffeeShop = annotation.coffeeshop
annotationView!.detailCalloutAccessoryView = detailView
```

First, you load the `CoffeeShopPinDetailView` from its XIB file. Then you assign a coffee shop to the detail view in order to populate the view's labels and subviews. Finally, you assign the view to the annotation view's `detailCalloutAccessoryView` property.

That's all the code it takes! Build and run your app, tap on one of the pins and you should see your custom annotation at work:

![iPhone](images/09-addingDetailView.png)

>**Note**: Tapping the phone button in the callout will only work on an actual device.

Tap the Yelp button to open up Safari and load the coffee shop's Yelp review page. Tapping the clock button won't show you any useful information; you'll implement actions for the transit and clock functions later in this chapter.

## Supporting time zones

The custom callout view you added in the previous section contains a small image to indicate whether a particular coffee shop is currently open for business:

![bordered width=50%](images/10-openclosed.png)

Open up **CoffeeShop.swift** and find `isOpenNow`; this is a computed property that determines the opened or closed state of the shop:

![bordered width=90%](images/11-timezonecode.png)

This property uses `NSDate()` to get the current time and then converts it to the time zone of the coffee shop; the shop's opening hours are stored in its local time zone so you have to convert the result of `NSDate()` to the time zone of the shop. You then use this to calculate whether the current local time falls within the range of opening hours.

Easy enough, but take a look at the time zone definition above `isOpenNow`:

    static var timeZone = NSTimeZone(abbreviation: "PST")!

The timezone is hardcoded to PST! Although Café Transit currently only contains some sample coffee shops in San Francisco, it would be nice if the time zone could be inferred from the location of the coffee shop in case you add more in the future.

iOS 9 adds a handy `timeZone` property to both `MKMapItem` and `CLPlacemark`; you can use this to ensure you use the correct time zone no matter where the shop is.

Still in **CoffeeShop.swift**, find `allCoffeeShops`, and replace the `return` statement with the following code:

```swift
// 1
let shops = array.flatMap { CoffeeShop(dictionary: $0) }
  .sort { $0.name < $1.name }

// 2
let first = shops.first!
let location = CLLocation(latitude: first.location.latitude,
  longitude: first.location.longitude)

// 3
let geocoder = CLGeocoder()
geocoder.reverseGeocodeLocation(location) { (placemarks, _) in
  if let placemark = placemarks?.first, timeZone =
    placemark.timeZone {
  
    self.timeZone = timeZone
  }
}

return shops
```

This code performs a couple of functions:

1. This is simply the value of the previous `return` statement, but stored in a variable instead.
2. You then create a `CLLocation` that represents the first coffee shop in the list for use with `CLGeocoder`.
3. Finally, you _reverse geocode_ the coffee shop's location using an instance of `CLGeocoder`. This takes the latitude and longitude of the coffee shop and produces a `CLPlacemark` with extra information about the location. This extra information includes the new `timeZone` property, which you then assign to the `timeZone` property of the `CoffeeShop` struct.

Build and run your app now; check that the opening hours labels are still showing the correct value. Remember, they're based on the current time in San Francisco, not the current time of _your_ location!

> **Note**: For the purposes of this chapter, you've simply fetched the time zone for a single coffee shop. In a real project, you'd have to check the time zone for each coffee shop, as they may be spread across different time zones.

## Simulating your location

All of Café Transit's sample coffee shops are based in San Francisco. Statistically, it's quite likely that _you_ aren't based in San Francisco. :] The rest of this chapter will make use of the user's location, so it would be pretty useful to at least _pretend_ to be there. Xcode lets you simulate your location, which will make testing Café Transit much easier!

With the starter project open, click on the **CafeTransit** scheme and choose **Edit Scheme...**:

![bordered width=60%](images/12-editScheme.png)

Select **Run** in the left pane, and **Options** from the tab bar at the top of the right pane. Enable **Core Location > Allow Location Simulation**, and set your **Default Location** to **San Francisco, CA, USA** as shown below:

![bordered width=90%](images/13-simulateLocation.png)

Click **Close** to save your location settings; your app now thinks you're in San Francisco. You'll use the simulated location in the next section as you plot the user's location on the map. You'll also request the user's location in order to provide transit directions from the user's current location to a selected coffee shop.

## Making a single location request

Before iOS 9, accessing the user's current location was a byzantine process. You had to create a `CLLocationManager`, implement some delegate methods, and then call `startUpdatingLocation()`. This would call the location manager delegate methods repeatedly with updates to the user's location. Once the location reached an acceptable level of accuracy, you then called `stopUpdatingLocation()` to stop the location manager. If you didn't stop it, you could quickly drain the user's battery!

Core Location in iOS 9 collapses this process into a single method call: `requestLocation()`. This still makes use of the existing delegate callback methods, but there's no longer a need to manually start and stop the location manager. You just specify the accuracy you desire, and Core Location will provide the location to you once it's narrowed down the user's position. It only calls your delegate once, and only returns a single location.

Enough theory — you know how your users get when they're deprived of their daily cuppa! Time to add some locating logic.

### Adding a location manager

First, open **ViewController.swift** and add the following line just below the class declaration:

```swift
lazy var locationManager = CLLocationManager()
var currentUserLocation: CLLocationCoordinate2D?
```
The code lazily creates a `CLLocationManager` object the first time it's called. You also create a `CLLocationCoordinate2D` property to store the user's current location.

Next, add the following lines to the end of `viewDidLoad()`:

```swift
locationManager.delegate = self
locationManager.desiredAccuracy =
  kCLLocationAccuracyHundredMeters
```
Here you set the delegate for location manager, and you determine how accurate you want the coordinates to be. Setting **desiredAccuracy** tells the system to only provide you with the user's location once it's accurate enough for your purposes. In some cases, the system might not reach the level of accuracy you want, and will therefore provide you with a location of a lower accuracy than you requested.

Next, add the following extension to the bottom of **ViewController.swift** to add conformance to the `CLLocationManagerDelegate` protocol:

```swift
// MARK:- CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {

  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if (status == CLAuthorizationStatus.AuthorizedAlways ||
        status == CLAuthorizationStatus.AuthorizedWhenInUse) {
      locationManager.requestLocation()
    }
  }

  func locationManager(manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]) {
    
    currentUserLocation = locations.first?.coordinate
  }

  func locationManager(manager: CLLocationManager,
    didFailWithError error: NSError) {
    
    print("Error finding location: " +
      \(error.localizedDescription)")
  }
}
```

This extension implements three methods of `CLLocationManagerDelegate`: in `locationManager(_:didFailWithError:)`, you simply log errors if they occur; in `locationManager(_:didUpdateLocations:)`, you store the coordinates of the first location returned in `currentUserLocation`; in `locationManager(_:didChangeAuthorizationStatus)`, you check to see if the user has enable you to use their location and if so you request for their location. When you use your new `requestLocation()`, you'll receive the location one time only.

Now you need to _call_ `requestLocation()` from somewhere else.

Still in **ViewController.swift**, add the following method to `ViewController`, below `centerMap(_:atPosition:)`:

```swift
private func requestUserLocation() {
  mapView.showsUserLocation = true    // 1
  if CLLocationManager.authorizationStatus() ==
    .AuthorizedWhenInUse { // 2
    
    locationManager.requestLocation()   // 3
  } else {
    locationManager.requestWhenInUseAuthorization()   // 4
  }
}
```

Taking each numbered comment in turn:
1. Show the user's location on the map.
2. Before you can request the user's location, you must first ask for permission to do so. This line checks whether you already have permission.
3. Next, call **requestLocation()** to request the user's current position. When done, this invokes a call to `locationManager(_:didUpdateLocations:)`, which you just implemented.
4. If you don't have permission to use the user's location, prompt for it.

> **Note**: When calling `requestWhenInUseAuthorization()`, you must have your Info.plist file configured with a value for the key `NSLocationWhenInUseUsageDescription` stating _why_ you would like access to the user's location. This message will be displayed to the user in the usual permission alert that pops up. To save you time, this setting has already been added to Café Transit's Info.plist as shown below:

![bordered width=80%](images/15-plist.png)

Next, add the following implementation underneath **viewDidLoad()**:

```swift
override func viewDidAppear(animated: Bool) {
  super.viewDidAppear(animated)

  requestUserLocation()
}
```

This calls the `requestUserLocation()` method you just wrote at first launch when the map view appears.

Finally, find the `MKMapViewDelegate` extension near the bottom of **ViewController.swift** and add the following method to it:

```swift
func mapView(mapView: MKMapView,
  didSelectAnnotationView view: MKAnnotationView) {
  if let detailView = view.detailCalloutAccessoryView
    as? CoffeeShopPinDetailView {
    
    detailView.currentUserLocation = currentUserLocation
  }
}
```

This passes the user's current location into an annotation whenever the annotation appears. You'll need access to this location in the next section to request transit directions.

That was quite a bit of code to get through — you've done well! Build and run your app; you should see a blue dot appear on the map showing your simulated location:

![iPhone](images/16-forcefield.png)

Sure, that doesn't seem like a lot when you consider all the code you wrote, but you're building up to some really cool features in the next section.

## Requesting transit directions

Now that you have the user's current location, you're nearly ready to provide transit directions to coffee shops!

Open **CoffeeShopPinDetailView.swift** and add the following method below `//MARK:- Transit Helpers` near the bottom of the file:

```swift
func openTransitDirectionsForCoordinates(
  coord:CLLocationCoordinate2D) {

  let placemark = MKPlacemark(coordinate: coord,
    addressDictionary: coffeeShop.addressDictionary) // 1
  let mapItem = MKMapItem(placemark: placemark)  // 2
  let launchOptions = [MKLaunchOptionsDirectionsModeKey:
    MKLaunchOptionsDirectionsModeTransit]  // 3
  mapItem.openInMapsWithLaunchOptions(launchOptions)  // 4
}
```

This is a helper method that gives you transit directions to the coordinates you pass in. Here's what the code does:

1. Creates an `MKPlacemark` to store your coordinates. Placemarks usually have an associated address, and the coffee shop model provides a basic one which simply includes the coffee shop's name.
2. Initializes an `MKMapItem` with the placemark.
3. Specifies that you want to launch Maps in **transit** mode.
4. Launches Maps to show transit directions to the requested location.

All you need to do now is replace the `TODO` in `transitTapped()` with a call to your method above and pass in the coffee shop's location:

```swift
openTransitDirectionsForCoordinates(coffeeShop.location)
```

Build and run your app; tap a coffee shop and click the train icon in the callout. You'll be launched straight into transit directions to the coffee shop:

![iPhone](images/17-transitDirections.png)

## Querying transit times

The final new feature of MapKit to add to Café Transit is querying public transit journey information. The `MKETAResponse` class includes the following useful properties:

```swift
public var expectedTravelTime: NSTimeInterval { get }
@available(iOS 9.0, *)
public var distance: CLLocationDistance { get }
@available(iOS 9.0, *)
public var expectedArrivalDate: NSDate { get }
@available(iOS 9.0, *)
public var expectedDepartureDate: NSDate { get }
@available(iOS 9.0, *)
public var transportType: MKDirectionsTransportType { get }
```

These properties tell you the distance of a trip, the expected duration of travel and the arrival and departure times. This lets you provide some high-level trip information, without pushing the user out to a separate app.

Tap a coffee shop in Café Transit and then tap on the clock icon; the view animates upwards to show you estimated departure and arrival times, but there aren't any yet. That's where you and MapKit will join forces to save your user's coffee crisis! :]

Open **CoffeeShopPinDetailView.swift** and add the following method just after `openTransitDirectionsForCoordinates(_:)`:

```swift
func requestTransitTimes() {
  guard let currentUserLocation = currentUserLocation else {
    return
  }

  // 1
  let request = MKDirectionsRequest()

  // 2
  let source = MKMapItem(placemark:
    MKPlacemark(coordinate: currentUserLocation,
    addressDictionary: nil))
  let destination = MKMapItem(placemark:
    MKPlacemark(coordinate: coffeeShop.location,
    addressDictionary: nil))

  // 3
  request.source = source
  request.destination = destination
  request.transportType = MKDirectionsTransportType.Transit

  // 4
  let directions = MKDirections(request: request)
  directions.calculateETAWithCompletionHandler {
    response, error in
    if let error = error {
      print(error.localizedDescription)
    } else {
      // 5
      self.updateEstimatedTimeLabels(response)
    }
  }
}
```

Here's how you request the transit times:

1. Once you ensure a user location's been set, initialize an instance of `MKDirectionsRequest`.
2. Create two instances of `MKMapItem` to represent the user's current location and the coffee shop's location. There's no address dictionary populated here because you only need the latitude and longitude.
3. Configure the `MKDirectionsRequest` object with the source, destination, and type of transport.
4. Create an `MKDirections` object, initialize it with the `MKDirectionsRequest` and instruct it to perform the ETA calculation.
5. If you receive a successful response, update the departure and arrival labels accordingly.

Finally, still in **CoffeeShopPinDetailView.swift**, replace `timeTapped()` with the following:

```swift
@IBAction func timeTapped() {
  if timeStackView.hidden {
    animateView(timeStackView, toHidden: false)
    requestTransitTimes()
  } else {
    animateView(timeStackView, toHidden: true)
  }
}
```

When you tap the clock icon, the time view animates upwards and you send off a request to Apple's servers for the journey's ETA and duration. The time labels on the callout update automagically.

Build and run your app; tap one of the coffee shop pins then tap the clock icon and you'll see an update on when you'll depart and what time you'll arrive! Can't you just smell the beans roasting already? :]

![iPhone](images/18-completedApp.png)

## Where to go to from here?

In this chapter you've customized a map view, added a custom callout, requested the user's location, and made use of transit directions and estimated journey times. Awesome stuff!

There are a couple of other MapKit and Core Location updates this chapter didn't cover, including 3D flyovers and a couple of changes to background location updates. For more information about these, check out these related WWDC talks:

* What's New In MapKit: [apple.co/1h4r4e7](http://apple.co/1h4r4e7)
* What's New in Core Location: [apple.co/1EcdPD7](http://apple.co/1EcdPD7)
