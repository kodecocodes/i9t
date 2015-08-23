# Chapter 12: Location and Mapping

After Apple Maps' slightly shaky start in iOS 6, Apple has continued to enhance its mapping and location frameworks every year. iOS 9 is no exception, with a number of great updates to both MapKit and Core Location.

Some of the most useful improvements come from iOS 9's addition of transit directions in Apple Maps, alongside  existing walking and driving directions. Transit is initially launching in a small number of cities around the world, but will likely be rolling out to more as time goes on. It features directions for subways, trains, buses and more.

In this chapter, you'll take a look at:

* New ways of customizing of the appearance of Maps in your apps
*	Presenting transit directions in Apple Maps
*	Requesting estimated travel times for transit directions
*	Requesting a single location update with Core Location

> **Note**: This chapter will be easier to follow if you have some basic MapKit knowledge. If you need to brush up, take a look at our [Getting Started With MapKit tutorial](http://bit.ly/1PrurqE):  <http://bit.ly/1PrurqE>.

## Getting started

The sample app for this chapter is one for all the coffee aficionados out there. Café Transit is an app that can ease the eternal search for good coffee. It currently just shows a handful of nearby coffee shops (well, in San Francisco!), marking them on the map using standard map pins.

By the time you've finished this chapter, the app will show all sorts of useful information for each coffee shop including a rating, pricing information, and opening hours. It will also be able to provide you with transit directions to a given coffee shop, and even let you know when you'll need to leave and when you'll be likely to arrive.

Time to get acquainted. Open the **starter project** for this chapter and build and run.

![iPhone](images/01-starter.png)

The starter app is using a standard MapKit `MKMapView`. You can tap on a pin to reveal the coffee shop's name and a brief description, but that's about it for now.

Now, head back over to Xcode and open **ViewController.swift**. The methods `setupMap()` and `addMapData()` are responsible for centering the map on San Francisco, and adding an annotation for each coffee shop. The model code for coffee shops is in **CoffeeShop.swift**, which also takes care of loading all of the sample coffee shop data from **sanfrancisco_coffeeshops.plist**.

Finally, take a quick look at **CoffeeShopPinDetailView.swift** and **CoffeeShopPinDetailView.xib**. These define the custom annotation that you'll be adding in later to spice up the map view. It shows a rating, price information, and opening hours - it's just waiting to be used!

## Customizing maps

Previously, when configuring an `MKMapView` in code, the only visible items that you could toggle on and off were buildings and places of interest. MapKit in iOS 9 introduces to this three new boolean properties: you can now show or hide the map's **compass**, **scale** (that's the small bar that shows for example how big a mile is), and **traffic** display. These can allow you to either clean up your map by removing items, or provide extra information to your users by showing them current traffic conditions.

![width=40%](images/02-compasstrafficscale.png)

Café Transit could benefit from showing the map's scale, so that users can have a better idea how far it might be to walk to a particular coffee shop from their current location.

Open **ViewController.swift** and add the following code at the very beginning of `setupMap()`:

```swift
mapView.showsScale = true
```

Build and run the app, and you should see the scale appear in the top left of the map. As you pan and zoom around the map, it'll update itself to match the map's current scale.

![width=60%](images/03-cafetransit-scale.png)

### Customizing map pins

Since iOS 3, MapKit pins have had a `pinColor` property which allowed you to set their color to either red, green, or purple. Pretty good, but what if you wanted a yellow pin? Or an orange pin? Or... a blue pin?! Tough luck!

In iOS 9, however, `MKPinAnnotationView`'s `pinColor` is now deprecated. It's been replaced by a new property: `pinTintColor`. And get this - you can set it to _any color you like_.

![width=35%](images/04-rainbow.png)

Café Transit currently uses boring red map pins, which doesn't really fit in with the coffee aesthetic. It would be nicer if they were the same brown color used throughout the app. Any why stop there? You could use a different color to pick out any cafes with a 5 star rating, to make them easier to see at a glance.

In **ViewController.swift**'s `mapView(_:viewForAnnotation:)`, add the following code before the `return` statement at the end:

```swift
if annotation.coffeeshop.rating.value == 5 {
  annotationView!.pinTintColor =
    UIColor(red:1, green:0.79, blue:0, alpha:1)
} else {
  annotationView!.pinTintColor =
    UIColor(red:0.419, green:0.266, blue:0.215, alpha:1)
}
```

This sets a different `pinTintColor` depending on the annotation's coffee shop's star rating; if the coffee shop has a 5 star rating then it's set to a gold color, otherwise brown.

Build and run, and check out your fancy new pins. That was easy!

![iPhone](images/05-customizedMapPins.png)

## Customizing annotation callouts

Each map pin (or annotation view) can show a 'callout' when tapped. A callout is a popover that appears above your annotation view on the map. This callout can provide extra information regarding a particular location.

![width=60%](images/06-defaultCallout.png)

Until now, annotation callouts have been very limited in terms of customization. You could set a title, subtitle and left and right accessory views. If you wanted to do any other kind of customization, you'd need to manually try and add a custom view to the annotation view. It wasn't an easy thing to do.

iOS 9 makes the whole process much simpler, with a new property on `MKAnnotationView`: `detailCalloutAccessoryView`. This can be set to any view you like, meaning almost unlimited customization options for your callouts. You could even use the new `UIStackView`, or something kind of crazy collection view!

### Callout size

A callout will use the _intrinsic content size_ of your custom view to size itself appropriately. There are two ways to take advantage of this to size your custom callouts:

1. Use Auto Layout to lay out your custom view, and let intrinsic content size do its thing.
2. You can override `intrinsicContentSize` within your custom view size and return a size of your choice.

> **Note**: For more information on intrinsic content size and Auto Layout, take a look at Apple's "Implementing a Custom View to Work with Auto Layout" documentation: <http://apple.co/1PHbKA5>.

The XIB for Café Transit's `CoffeeShopPinDetailView` uses `UIStackView` and Auto Layout, so no manual specification of `intrinsicContentSize` is required. Feel free to explore how the XIB makes use of `UIStackView` and constraints.

In addition, custom callouts aren't able to fill the entire area of the callout popover. The title of the annotation and a certain amount of padding is added by iOS. In the screenshot below, the green area is the entire area filled by the `detailCalloutAccessoryView`:

![width=50%](images/07-customCalloutArea.png)

You should bear this in mind when designing your custom callout views, as there is currently no way to modify the padding or title area.

### Adding a custom callout accessory view

With that theory out of the way, it's time to add a custom callout of your own! If you haven't seen it already, **CoffeeShopPinDetailView.xib** defines the UI for the callout accessory view. It shows the opening hours, star rating, and cost rating of a coffee shop, along with a description and a set of action buttons for things like calling the coffee shop or viewing their _Yelp_ page.

![width=45%](images/08-customview.png)

Open **ViewController.swift** and add the following code in `mapView(_:viewForAnnotation:)`, just before the `return` statement:

```swift
let detailView =
  UIView.loadFromNibNamed(identifier) as! CoffeeShopPinDetailView
detailView.coffeeShop = annotation.coffeeshop
annotationView!.detailCalloutAccessoryView = detailView
```

First, this code loads the `CoffeeShopPinDetailView` from its XIB file. Then it's assigned a coffee shop, which it uses to populate its various labels and subviews. Finally, it assigns the view to the annotation view's `detailCalloutAccessoryView` property.

It's that simple! Build and run your app, tap on one of the pins and you should now see the following:

![iPhone](images/09-addingDetailView.png)

>**Note**: Tapping on the phone button in the callout will only work on an actual device. Currently you will only be able to tap the Yelp button which will open up Safari and take you to the coffee shop's Yelp review page. You can also tap the clock button, but it currently won't show any useful information. You will implement actions for transit and the clock buttons later in this chapter.

## Time zone support

The custom callout view that you just added contains a small image that indicates whether a particular coffee shop is currently open for business or not.

![bordered width=50%](images/10-openclosed.png)

Open up **CoffeeShop.swift** and find `isOpenNow`, a computed property that determines this information.

![bordered width=90%](images/11-timezonecode.png)

This property takes the current time (using `NSDate()`) and converts its components into the time zone of the coffee shop. These date components are then used to calculate whether the time falls within the opening hours of the shop. The time needs to be converted because the coffee shop's opening hours are stored in its own time zone.

But take a look at the time zone definition above `isOpenNow`:

    static var timeZone = NSTimeZone(abbreviation: "PST")!

The timezone is hardcoded to PST! Whilst Café Transit currently only contains some sample coffee shops from San Francisco, it would be nice if the time zone could be inferred from the location of the coffee shop in case more are added in different locations.

Fortunately, iOS 9 adds a `timeZone` property to both `MKMapItem` and `CLPlacemark`. You can use this to ensure that the correct time zone is used no matter where the shop is located.

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
geocoder.reverseGeocodeLocation(location) { (placemarks, _) -> Void in
  if let placemark = placemarks?.first, timeZone = placemark.timeZone {
    self.timeZone = timeZone
  }
}

return shops
```

This code performs a couple of functions:

1. This is just value of the previous `return` statement, but stored into a variable.
2. The location of the first coffee shop in the list is converted to a `CLLocation` for use with `CLGeocoder`.
3. A `CLGeocoder` instance is used to _reverse geocode_ the coffee shop's location. This takes the latitude and longitude of the coffee shop and produces a `CLPlacemark` with extra information about the location. This includes the new `timeZone` property, which you then assign to the `CoffeeShop` struct's `timeZone` property.

Build and run the app now, and check that the opening hours labels are still showing the correct value. Remember, they're based on whether the current time in San Francisco, not the current time whereever you may be!

> **Note**: For the purposes of this chapter, you've just fetched the time zone for a single coffee shop. In a real project, you'd want to check the time zone for each coffee shop, as they may be spread across different time zones.

## Simulating your location

All of Café Transit's sample coffee shops are based in San Francisco. Statistically, however, it's very likely that _you_ aren't in San Francisco. The rest of this chapter will make use of the user's location, so it would be pretty useful if you could at least _pretend_ to be there. Fortunately, Xcode provides the functionality to simulate your location which will make testing Café Transit much easier! This isn't new functionality with Xcode 7, but it's certainly useful when working with Core Location.

With the starter project open, click on the **CafeTransit** scheme and choose **Edit Scheme...**.

![bordered width=60%](images/12-editScheme.png)

Select **Run** in the left pane, and **Options** from the tab bar at the top of the right pane. Enable **Core Location > Allow Location Simulation**, and set your **Default Location** to **San Francisco, CA, USA**. Click **Close** to save.

![bordered width=90%](images/13-simulateLocation.png)

The app will now be fooled into thinking you're in San Francisco! You'll see this in action in the next section, as you plot the user's location on the map. You'll also be requesting the user's location so that you can use it to provide transit directions from the user's current location to a selected coffee shop.

## Making a single request for the user's location

In previous versions of iOS, if you wanted to just access the user's current location you would have to jump through a number of hoops. You'd need to create a `CLLocationManager`, implement some delegate methods, and then ask it to `startUpdatingLocation()`. This would repeatedly call the location manager delegate methods with updates to the user's location. Once it was at an accuracy you were happy with, you'd need to call `stopUpdatingLocation()` to stop the location manager. If you don't stop it, you could accidentally be draining the user's battery life!

Core Location in iOS 9 has now made this process possible with just one method call: `requestLocation()`. It still makes use of the existing delegate callback methods, but there's now no need to manually start and stop the location manager. You just tell it the accuracy you'd like, and it'll give you the location once it narrows down the user's location for you. It only calls your delegate once, and only returns a single location.

![width=50%](images/14-winningBaby.jpg)

[NOTE: FPE: I'm not sure this image adds much here?]

### Add a location manager

First, open **ViewController.swift** and add the following line just below the class declaration:

```swift
lazy var locationManager = CLLocationManager()
var currentUserLocation: CLLocationCoordinate2D?
```
The code lazily creates a `CLLocationManager` object whenever it's first used. You also create a `CLLocationCoordinate2D` property that will be used later to store the user's current location.

Next, at the end of `viewDidLoad()` add these two lines:
```swift
locationManager.delegate = self
locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
```
Here you set the delegate for location manager, and you determine how accurate you want the coordinates to be. By setting **desiredAccuracy**, the system will attempt to only provide you with the user's location once it's accurate enough. In some cases, it may not be possible for the system to reach the desired accuracy. In these situations, if the accuracy isn't improving, you may receive a location with a lower accuracy than you'd like.

Next, add the following extension to the bottom of **ViewController.swift**, adding conformance to the `CLLocationManagerDelegate` protocol:

```swift
// MARK:- CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {

  func locationManager(manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]) {
      currentUserLocation = locations.first?.coordinate
  }

  func locationManager(manager: CLLocationManager,
    didFailWithError error: NSError) {
      print("Error finding location: \(error.localizedDescription)")
  }
}
```

This extension implements two of `CLLocationManagerDelegate`'s methods. In `locationManager(_:didFailWithError:)`, you simply log out an error if one occurs. In `locationManager(_:didUpdateLocations:)`, you store the coordinate of the first location returned in the property you created earlier. When you use the new `requestLocation()` method, only one location will ever be returned.

Now you just need to actually _call_ `requestLocation()`! Still in **ViewController.swift**, add the following method to `ViewController`, below `centerMap(_:atPosition:)`:

```swift
private func requestUserLocation() {
  if CLLocationManager.authorizationStatus() ==
    .AuthorizedWhenInUse { // 1
      mapView.showsUserLocation = true    // 2
      locationManager.requestLocation()   // 3
  } else {
    locationManager.requestWhenInUseAuthorization()   // 4
  }
}
```

Let's go over the code line by line:

1. Before you can request the user's location, you must first ask for permission to do so. This line checks whether you already have position.
2. If you do have permission, show the user's location on the map.
3. Then call **requestLocation()** to request the user's current position. Once this is done, the delegate method `locationManager(_:didUpdateLocations:)` that you just implemented will be called.
4. If you don't have permission to use the user's location, ask for it.

> **Note**: When calling `requestWhenInUseAuthorization()`, you must have configured your Info.plist file with a value for the key `NSLocationWhenInUseUsageDescription` stating _why_ you would like access to the user's location. This message will be displayed to the user in the usual permission alert that pops up. To save you time, this setting has already been added to Café Transit's Info.plist. ![bordered width=80%](images/15-plist.png)

Next, add the following implementation for `viewDidAppear(_:)` underneath **viewDidLoad()**:

```swift
override func viewDidAppear(animated: Bool) {
  super.viewDidAppear(animated)

  requestUserLocation()
}
```

This will call the method you just wrote when the app first launches and the map view appears.

Finally, find the `MKMapViewDelegate` extension near the bottom of **ViewController.swift**, and add the following method to it:

```swift
func mapView(mapView: MKMapView,
  didSelectAnnotationView view: MKAnnotationView) {
    if let detailView =  
      view.detailCalloutAccessoryView as? CoffeeShopPinDetailView {
        detailView.currentUserLocation = currentUserLocation
    }
}
```

This will pass the user's current location onto an annotation whenever it's displayed. You'll use this in the next section to request transit directions from this location.

Wow! That was quite a bit to get through, but well done! Build and run your app. If everything's working correctly, should see a blue dot appear on the map. Sure, that doesn't seem like a lot, considering all the code you just added - but that code will enable you to easily add some cool new features very soon...

![iPhone](images/16-forcefield.png)

## Transit directions

Now that you've obtained the user's current location, you're ready to get transit directions to coffee shops! Since Apple Maps launched back with iOS 6, developers have had the ability to launch Maps with either driving or walking directions to a particular location. Maps in iOS 9 has had an upgrade and now contains fantastic public transit information for a number of cities around the world, which developers can take advantage of too!

Open **CoffeeShopPinDetailView.swift** and add the following method below `//MARK:- Transit Helpers` near the bottom of the file:

```swift
func openTransitDirectionsForCoordinates(coord:CLLocationCoordinate2D) {
  let placemark = MKPlacemark(coordinate: coord,
    addressDictionary: coffeeShop.addressDictionary) // 1
  let mapItem = MKMapItem(placemark: placemark)  // 2
  let launchOptions = [MKLaunchOptionsDirectionsModeKey:
    MKLaunchOptionsDirectionsModeTransit]  // 3
  mapItem.openInMapsWithLaunchOptions(launchOptions)  // 4
}
```

This is a helper method that will give you transit directions to the coordinates you pass in. Let's go over how this works:

1. Create an `MKPlacemark` that will store your coordinates. Placemarks usually have an associated address, and the coffee shop model provides a basic one which just includes the coffee shop's name.
2. Initialize an `MKMapItem` with the placemark.
3. Specify that you want to launch Maps in **transit** mode.
4. Launch Maps to show transit directions to the requested location.

Now all you need to do is replace the `TODO` in `transitTapped()` with a call to the method above, passing in the coffee shop's location:

```swift
openTransitDirectionsForCoordinates(coffeeShop.location)
```

Build and run the app. Tap on a coffee shop, and click the train icon in the callout. You should be launched straight into transit directions to the coffee shop!

![iPhone bordered](images/17-transitDirections.png)

## Querying Transit ETA

The final new feature of MapKit that you'll add to Café Transit is the ability to query public transit journey information. In particular, the **MKETAResponse** class includes these properties:

```swift
public var expectedTravelTime: NSTimeInterval { get }
@available(iOS 9.0, *)
public var distance: CLLocationDistance { get } // overall route distance in meters
@available(iOS 9.0, *)
public var expectedArrivalDate: NSDate { get }
@available(iOS 9.0, *)
public var expectedDepartureDate: NSDate { get }
@available(iOS 9.0, *)
public var transportType: MKDirectionsTransportType { get }
```

You are now able to obtain the distance of a journey, the expected duration of travel, arrival, and departure times. This is really useful for apps to provide some high level journey information without pushing the user out into a separate app.

If you tap a coffee shop in Café Transit and then and tap on the clock button, the view animates upwards to show you estimated departure and arrival times. But there are no times displayed yet. MapKit to the rescue!

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
  directions.calculateETAWithCompletionHandler { response, error in
    if let error = error {
      print(error.localizedDescription)
    } else {
      // 5
      self.updateEstimatedTimeLabels(response)
    }
  }
}
```

Let's go over how you request for the times:
1. After checking that there's currently a user location set, initialize an instance of `MKDirectionsRequest`.
2. Create `MKMapItem`s to represent both the user's current location, and the coffee shop's location. There's no address dictionary populated here because the latitude and longitude are all that's needed.
3. Configure the `MKDirectionsRequest` with the source, destination, and the type of transport.
4. Create an `MKDirections` object, initialized with the `MKDirectionsRequest`, and tell it to actually perform the ETA calculation.
5. If a successful response is returned, update the departure and arrival labels accordingly.

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

When the time button is tapped, it'll animate upwards, a request will be sent to Apple's servers to get the journey's ETA and ETD, and the callout's labels will be updated! Magic!

Build and run the app. Tap on one of the coffee shop pins, and then tap the clock. You should now see an update on when to leave and and when you'll arrive!

![iPhone](images/18-completedApp.png)

## Where to go to from here?

Congratulations, you've done a great job! In this chapter you've customized a map view, added a custom callout, requested the user's location, and made use of transit directions and estimated journey times. Awesome stuff.

There are a couple of other MapKit and Core Location updates that this chapter did not cover. This includes a 3D flyover view in maps, and a couple of changes to background location updates. For more information about these, check out their WWDC talks:

* What's New In MapKit: <http://apple.co/1h4r4e7>
* What's New in Core Location: <http://apple.co/1EcdPD7>
