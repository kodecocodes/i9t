```metadata
author: Jawwad Ahmad
number: 14
title: What's New in Xcode?
```

# Chapter 14: What's New in Xcode?

The most important tool you use as an iOS developer is Xcode, and each new release brings a variety of features and improvements. In prior chapters, you learned about many of Xcode's new features, such as storyboard references, support for app thinning, improvements to testing and code coverage.

This chapter will introduce you more new features in Xcode, like the new energy gauge and improvements to playgrounds. Along the way, you'll also learn about other features and improvements that will make your time spent in Xcode more productive.

## Getting started

In this chapter, you'll work on **Local Weather**, an app that uses your GPS location to show the weather near you.

You won't make too many changes to the app, rather you'll use it to explore various new features of Xcode, especially the new energy gauge. Find an iPhone or iPad before you dig in; you'll need to run the app on an actual device since the energy gauge doesn't show  on the simulator.

Open the starter project for this chapter and select your device from the destination menu:
![bordered width=50%](images/01-select-your-device_391x105.png)

> **Note:** If you can't run the app on your device, it may not be provisioned. See the next section on **free provisioning** to get set up.

After selecting your device, build and run. Then tap **Allow** on the location access request. The location and weather should update fairly quickly:
![bordered width=31%](images/02-app-screenshot_750x1334.png)

Although the energy gauge won't show up unless you run the app on a device, you _can_ still run it in the simulator. If you do, make sure to select a location using the **Simulate Location** button in the **Debug Area**. You can also use this feature to simulate a different location while running on your device. Perhaps you'd like to find out how cold it is in Moscow or how balmy it is in Maui. No problem, just choose it from the menu.
![bordered width=31%](images/03-simulate-location_199x113.png)

### Free provisioning

One of the major changes this year is _free provisioning_, which means that anyone with an Apple ID can build and run iOS apps on a physical device without having to join the $99/yr Apple Developer Program. Now you only need to join the paid program if you want to distribute apps on the App Store.

This chapter won't cover the provisioning process, but if your device isn't already provisioned, you can take a look at Apple's documentation to set things up: [Launch Your App on Devices Using Free Provisioning (http://apple.co/1KJ12tJ)](http://apple.co/1KJ12tJ).

### OpenWeatherMap API key (optional)

**Local Weather** uses the _current weather data_ API from [openweathermap.org](http://openweathermap.org/). You may not need to use the API key, but OpenWeatherMap notes that it reserves the right to not process requests made without an API key. So it could get interesting without that API.

To sign up for a key, go to [openweathermap.org/register](http://openweathermap.org/register).

If you do sign up, open **WeatherViewController.swift** and near the top of the file replace `"YOUR_API_KEY_HERE"` with your new API key.

```swift
let openWeatherMapApiKey = "YOUR_API_KEY_HERE"
```

## Energy impact gauge

Exploring the new energy gauge will be a major part of this chapter. With the app running on a device, switch to the **Debug navigator** and click on **Energy Impact**:
![bordered width=30%](images/05-choose-debug-navigator_260x204.png)

> **Note:** If you can't see **Energy Impact**, try clicking on the disclosure arrow on the LocalWeather process:
![bordered width=35%](images/05a-choose-debug-disclosure.png)


You'll see the new iOS energy gauge, and it shows the app is a bit power hungry!
![bordered width=98%](images/06-first-show-of-gauge_1281x480.png)



The _Utilization_ section on the top left shows you the energy impact at the current moment in time. In the top right section, you see the _average_ energy impact, as well as the **overhead**. This includes the energy consumed by system resources to perform work like bringing up radios, as well as the energy used when the resources remain active but idle.

At the bottom, you see four rows of blocks corresponding to CPU, network, location and background. Each block represents a second. If there is any kind of activity during a single second, the box will fill in with a gray block.

Note that the **CPU** and **Location** graphs show continuous activity. The **Network** graph shows an interesting pattern of 10 or 11 seconds of activity, then three to five seconds of inactivity. The **Background** graph is completely clear since the app hasn't been put into the background...yet.

Press the **Home button** to background the app. You'll eventually end up with the following graph that shows the location and network activity have ceased, but you'll have continuous activity for Background and CPU:
![bordered width=98%](images/07-background-activity_1203x480.png)

Take a look at the console. The log indicates that all of the background tasks completed in 10.79 seconds, but the background energy graph didn't stop.
![bordered width=60%](images/08-background-activity-completes-in-10-seconds_503x184.png)

It would appear that Local Weather is a little energy vampire.

## Code browsing features

Many of Xcode's new features not only help with development, but also help you get up to speed with a new codebase even faster. In this chapter, you'll use them to get a basic understanding of the app's architecture, and then you'll fix each of the energy issues you just saw.

### Interface of Swift classes

If you came to iOS programming in the olden days then you'll remember Objective-C headers. They showed just the public properties and method signatures, and were a great way of getting a quick summary of a class and its capabilities. You'd open up the header file and instantly be able to see what it could do, without having to comb through the implementation code.

Wouldn't it be dreamy if you could have a header file for Swift classes but didn't have to maintain it? Crazy talk you say?

Open **WeatherViewController.swift** and then open the **assistant editor**. Click on the assistant editor menu and choose **Counterparts (1) ► WeatherViewController.swift (Interface)**:
![bordered width=65%](images/09-assistant-editor-counterparts_498x79.png)

> **Note**: You can also select **Generated Interface** instead of **Counterparts ► RWHTTPManager.h (Interface)** to view the same result.

Like magic, you'll see the public interface of your class in the assistant editor:
![bordered width=75%](images/10-public-interface-of-swift-file.png)

However, private variables or methods won't show up in the interface. Take a look at the following part of **WeatherViewController.swift**:
![bordered width=75%](images/11-part-of-class-to-demo-interface.png)

Look at the interface again and note that `locationManager` isn't visible since it's declared `private`, nor are any of the outlets visible since they are all `private`.

> **Note**: Since the class is self-contained, every variable and method could actually have been made `private`. But then there wouldn't have been an interface to demo!

In **WeatherViewController.swift**, delete the `private` access modifier from the following:

```swift
private let locationManager = CLLocationManager()
```

Press **Command-S** to save the file, and the interface should refresh itself. You'll now see `locationManager` join its friends in the interface:
![bordered width=50%](images/12-location-manager-shows-up.png)

Did you notice that the comment for `countdownUpdateTimer` shows up in the interface, but the comments for `weatherNeedsFetchUpdate` and `networkFetchTimer` don't? This is because the required documentation comment is nowhere in sight. You need either **///** or **/\*\***.

Add an extra **/** to the comment for `weatherNeedsFetchUpdate` and an extra **\*** to the comment for `networkFetchTimer`. **Save** the file, and you'll see both comments show up when the interface refreshes itself:
![bordered width=75%](images/13-now-both-show-up-after-adding-extra-chars.png)

Wouldn't it also be cool if you could take an _Objective-C_ header file and see what how it would look in Swift? No problem – coming right up!

### Generated Swift interface for Objective-C headers

In the **project navigator**, expand the **Helpers** group and you'll see **RWHTTPManager.h** and **RWHTTPManager.m**. The `RWHTTPManager` class is a convenience wrapper around `NSURLSession` and is written in Objective-C.

Click on **RWNetworkHelper.h** to open it in the primary editor:
![bordered width=75%](images/14-objc-file-in-primary-editor.png)

Now take a look at the assistant editor:
![bordered width=75%](images/15-swift-interface-of-an-objective-c-file.png)

Isn't that just magical? There's an issue though, and it's a bit harder to catch in the RWHTTPManager.h file. Take a look at the Swift interface. In `init(baseURL:)`, the type of `baseURL` is a non-optional `NSURL`, whereas the actual `baseURL` property on the line above it is an optional. The `init` method is correct; `baseURL` should be of type `NSURL` instead of `NSURL?`.

Look at **RWHTTPManager.h** and note that `NSURL` is annotated with `_Nullable`:

```objc
@property (nonatomic, strong) NSURL * _Nullable baseURL;
```

Change `_Nullable` to `_Nonnull`:

```objc
@property (nonatomic, strong) NSURL * _Nonnull baseURL;
```

Press **Command-S** to save the file. Once the interface refreshes, you should see that `baseURL` is no longer an optional:

    var baseURL: NSURL

There is actually another small issue. Note that the `relativePath:` parameter takes an optional, `String?`, whereas the comment says `relativePath` is a required parameter. Can you fix this yourself? Go ahead and try it.

Okay, here's the answer. It's upside down so you can't cheat quite so easily:
![bordered width=55%](images/16-upside-down-answer_385x15.png)

### New documentation features

Open **WeatherViewController.swift** and look at **updateCountdownLabel()**. Note the call to `FormatHelper.formatNumber(_:withFractionDigitCount)` right under the **Step 8** comment. **Option-click** on `formatNumber`, and you'll see the documentation appear in rich formatting.
![bordered width=70%](images/17-option-click-on-format-number_522x315.png)

Now **Command-click** on `formatNumber` to jump to the implementation of the method. It's just using basic markdown syntax!
![bordered width=75%](images/18-rich-documentation_717x188.png)

If you want to find out more, NSHipster has a great guide to Swift Documentation, which covers all of the possibilities: <http://bit.ly/1Ltcz0B>

Think of all the beautiful documentation you'll now be able to produce!

### Find call hierarchy

Seeing documentation is great, but think about how often you want to see all of the places that use a particular method. **Right-click** or **Control-click** on `formatNumber`, and then click on **Find Call Hierarchy**.
![bordered width=50%](images/19-find-call-hierarchy_500x147.png)

Boom! You'll see all the places that call `formatNumber`. How cool is that? _And_ you can also drill down to view the complete call hierarchy:
![bordered width=50%](images/21-find-call-hierarchy-expanded_425x279.png)

From here you can quickly jump to any level in the call hierarchy with a click of your trackpad.

## Decreasing energy impact

It's time to get back to fixing those draining energy issues! Before you do, here's a brief summary of the app flow:

* First, it requests the user's current location.
* Once it receives the location, it makes an HTTP request to fetch the weather for that location.
* Once weather data is received, it updates views and schedules and another request for 15 seconds later.
* Every 0.1 seconds, `countdownLabel` refreshes to show the time remaining until the next network request.

That was a quick, high-level overview. To review the app flow in a bit more detail, press **Command-Shift-F** and search for **// Step**:
![bordered width=60%](images/22-find-the-steps_469x281.png)

Do you recall the interesting behavior you saw when there was 10–11 seconds of network activity followed by three to five seconds of non-activity? It happens because any time a network request is made, the network radios stay on for about 10 seconds, even after the network request completes.

It's a recipe for very high overhead with every single network request. While you may have thought you were just using the network radio for about one second every 15 seconds — that's seven percent — you were _actually_ using it for 11 seconds out of 15 seconds, or a whopping 73 percent.

This is the first thing you'll fix.

### Reducing network energy impact

Weather changes quickly, but not 15 seconds quickly – unless you're out at sea. Hence, there's not a strong use case for a weather app that updates every 15 seconds. A better plan is to make it update whenever the user launches the app.

In the Find results for  **// Step** click on **Step 6**, which is in **WeatherViewController.swift**. Comment out the line directly below **Step 6**, which initializes the `networkFetchTimer`:

```swift
// Step 6: Set a timer to fetch the weather again in 15 seconds
// networkFetchTimer = NSTimer.scheduledTimerWithTimeInterval(15, ...
```

Build and run, switch to the **Debug navigator** and click on the **Energy Impact** row to see the updated energy gauge:
![bordered width=80%](images/23-network-energy-reduced_970x326.png)

Much better! Now the app will only make a single network request when it starts, saving the user's battery for more important things, like watching videos of pug puppies.

### Reducing CPU energy impact

In the previous graph, you see that the CPU is still working even though the app is essentially twiddling its thumbs.

`countdownUpdateTimer`, which updates the `countdownLabel`, is the culprit. It continually sets the remaining time to 0 since there is no longer an active `networkFetchTimer`.

Switch back to the **Find navigator**, and click on **Step 7** to take you to the relevant line in **WeatherViewController.swift**. Comment out the line directly below **Step 7** which initializes `countdownUpdateTimer`:

```swift
// Step 7: Update the countdown label every 0.1 seconds using a timer
// countdownUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1 ...
```

For good measure, also comment out the line that unhides the `countdownLabelStackView` just above the `UIView` animation block, since you no longer need to see the countdown label:

    // countdownLabelStackView.hidden = false

Build and run, and go back to the **energy gauge**. You may have to wait up to 30 seconds for things to settle down, but this looks much better!
![bordered width=80%](images/24-cpu-usage-reduced_970x328.png)

### Reducing location energy impact

The next thing to do is reduce the location energy impact by turning off GPS when it's not needed. Once the initial location is received, you no longer require location updates, so you should add a call to `locationManager.stopUpdatingLocation()`.

However, in iOS 9 if you only need a single location update, you can just call `requestLocation()` instead of `startUpdatingLocation()`. This new method automatically stops location updates once it's reported the user's location.

In **WeatherViewController.swift**, find **requestLocationAndFetchWeather()** and replace `.startUpdatingLocation()` with `.requestLocation()`:

```swift
// Step 2: Request the location
locationManager.requestLocation()
```

Build and run, and check the **energy gauge** again. You'll see that after the initial burst of activity, there's little to no activity at all. Nice work!
![bordered width=80%](images/25-no-location-activity_970x328.png)

### Reducing background energy impact

Recall that when you pressed the home button, the background graph started registering activity, but didn't stop even though the console log indicated that all background work was complete in about 11 seconds.

Open **AppDelegate.swift** and take a look at **performBackgroundWork()**.

> **Note**: Technically, the method isn't doing any "real" background work, it's just simulating 10 seconds of activity for the purposes of helping you learn how this all works!

The one rule of calling `beginBackgroundTaskWithExpirationHandler(_:)` is that once you're done with any work, you should call `endBackgroundTask(_:)` to let the system know that you no longer need further background execution time.

Add a call to `endBackgroundTask(_:)` at the very end of `performBackgroundWork()` right after the `print` call:

```swift
print("Background work completed in: \(formattedElapsedTime) sec")
UIApplication.sharedApplication().endBackgroundTask(
  backgroundTaskIdentifier)
```

Build and run, go to the **energy gauge** and press the **Home button** to place the app in the background. You'll see that background activity now stops after 10 seconds:
![bordered width=80%](images/26-background-activity-stops_970x327.png)

Fantastic! You've fixed all of the energy impact issues using the new energy gauge. Now to take it one step further with the new Core Location instrument in Xcode.

### Core Location instrument

If you want to dig deeper into how the user's location is being accessed, then iOS 9's new Core Location instrument is for you. To use it, build and run the app, go to the **energy gauge** and click on the **Location** button below the gauge:
![bordered width=80%](images/28-click-on-location-to-open-location-instrument_974x161.png)

Click **Restart** on the _Transfer current debug session_ prompt that appears:
![bordered width=40%](images/29-transfer-current-session-prompt_438x162.png)

Instruments will open up and run the Core Location instrument, profiling LocalWeather. The graph will show whenever the app uses Core Location, and the table, shown below, shows extra information about each usage.
![bordered width=99%](images/30-location-instrument-accuracy-best_1050x278.png)

Notice the second row that says "`CLLocationManager` changed accuracy to `kCLLocationAccuracyBest`". The Energy Impact column shows High and the duration shows 892.03 ms.

The app currently uses the default accuracy of `kCLLocationAccuracyBest`. As you can see, it has a high energy impact. A weather app doesn't need to be so precise, so dialing it back is an easy way to improve the app's energy usage.

Click the **stop** button in Instruments, and head back over to Xcode. In **WeatherViewController.swift**, find **viewDidLoad()** and add the following line just before the `locationManager`'s delegate is set:

    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer

Build and run, go to the **energy gauge** and click on the **Location** button again. Click **Restart** on the prompt to get back to the Core Location instrument:
![bordered width=99%](images/31-location-instrument-accuracy-kilometer_1058x278.png)

The table now says that `CLLocationManager` changed accuracy to `kCLLocationAccuracyKilometer`, which has a low energy impact. It's also much faster, at only _5.74 ms_!

You now have the tools you need to be a good battery citizen on iOS and avoid ending up in the battery hog hall-of-shame. In the iOS 8 settings app, _Battery Usage_ was buried 3 levels deep. You had to get to it via Settings \ General \ Usage \ Battery Usage. In iOS 9, it's now on the top-level Settings screen right above Privacy.
![bordered width=32%](images/27-battery-settings_750x546.png)

It's now easier than ever for a user to keep an eye on the relative battery usage of their apps. And with the new energy impact gauge and Core Location instrument, Apple has made it easier than ever for developers to diagnose and fix energy issues as well.

You're now finished with LocalWeather, so feel free to close the project in Xcode.

## Playground improvements

Playgrounds has seen many new features since its debut in Xcode 6 last year. Support for rich authoring, auxiliary source files and inline results were introduced in Xcode 6.3, just 2 months before WWDC 2015. These features are significant, and even though they were initially released in Xcode 6.3, Apple has also chosen to make a note of them in its [New Features in Xcode 7 (http://apple.co/1JSDRMa)](http://apple.co/1JSDRMa) document.

Xcode 7 improves upon these features and adds others, such as support for multiple pages and the ability to pause code execution. Playgrounds were already an amazing education tool, and these new features take them to the next level.

### Rich playground authoring

In Xcode, choose **File\New\Playground...**, and name it **Xcode7.playground**. Click **Next**, choose a location, and then click **Create**. In the playground, replace the existing "Hello, playground" line with the following:

```swift
//: # Level 1 Heading

//: ## Level 2 Heading

//: ### Level 3 Heading
```

Reveal the **File inspector** by pressing **Command-Option-1**, or by clicking on the **Utilities** button followed by the **File Inspector** button:
![bordered width=25%](images/32-utilities-button_227x67.png)

Under **Playground Settings**, place a checkmark in **Render Documentation**:
![bordered width=99%](images/33-render-documentation-setting_961x81.png)

You'll now see the rendered markup:
![bordered width=99%](images/34-rendered-headings_960x269.png)

Unlike Xcode's documentation syntax, which uses an extra comment character, like **///** or **/\*\***, for playgrounds you use a colon instead. So for single-line comments, the syntax is **//:**, and for multiline comments the syntax is **/\*:** and **\*/**.

Consecutive lines using **//:** are rendered in the same block. Uncheck **Render Documentation** and add the following:

```swift
// This is a regular comment and will be shown but not rendered
//: 1. The first item
//: 2. The second item
//: 3. And the third
```

Check **Render Documentation** again to see the output:
![bordered width=80%](images/35-first-block-syntax-example_506x115.png)

For multiple lines, you can also use the block delimiter **/\*:** and **\*/** and it will render as a block even, if you have a blank line between any of the lines. Furthermore, anything that you add directly after **/\*:** won't render at all.

Uncheck **Render Documentation** and add the following:

```swift
// An example using block comment syntax
/*: This is a comment and will not be shown at all
1. The first item
2. The second item

3. And the third
*/
```

Check **Render Documentation** once more:
![bordered width=80%](images/36-second-block-syntax-example_506x108.png)

Note that the text after **/\*:** does not show at all.

This was just a brief introduction to get you started. For a full reference on syntax, see: [Playground Markup Format (http://apple.co/1IG2eZ9)](http://apple.co/1IG2eZ9)

### Playground pages

You'll now add a second page to the playground. Reveal the **project navigator** by pressing **Command-1**, click the **+** button in the very bottom left, then click on **New Page**:
![bordered width=15%](images/37-add-new-page_125x102.png)

Name the newly added page **Page Two**, and then rename the original page by **clicking** it once to select it and then again to edit its title. Change its name from **Untitled Page** to **Home**.
![bordered width=30%](images/38-home-and-page-two_260x109.png)

Click on **Page Two** and you'll see it already has **Previous** and **Next** links. In the **File inspector**, uncheck **Render Documentation** to see the plain text format of the links:

```swift
//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)
```

**@next** and **@previous** are special tokens to get you to the next and previous pages. To add a link to a specific page, you can just use the page name. If the name has a space, replace it with **%20**, as you would in a URL.

Add the following line anywhere in **Page Two**:

```swift
//: [Jump to Home](Home)
```

And the following line anywhere in **Home**:

```swift
//: [Jump to Page Two](Page%20Two)
```

Now check **Render Documentation** and try clicking on the links. You should be able to jump between both pages.

### Inline results

Inline results let you see a result directly in the playground itself.

Uncheck **Render Documentation** again, and add the following code to the end of **Page Two**:

```swift
import UIKit
let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
let view = UIView(frame: frame)
view.backgroundColor = UIColor.redColor()
view.layer.borderColor = UIColor.blueColor().CGColor
view.layer.borderWidth = 10
view
```

Hover over the `UIView` entry for the last line in the playground **sidebar**, and click on the **Show Result** button that appears:
![bordered width=90%](images/39-show-result-button.png)

You'll see the view appear inline right under the `view` variable!
![bordered width=40%](images/40-show-inline-result_408x195.png)

Change the view's layer's `borderWidth` to `40` to see the view update:
![bordered width=40%](images/40b-show-inline-result.png)

### Sources and resources

You can now add auxiliary source files and resources to the **Sources** and **Resources** folders in a playground. Moving supporting code to the sources folder allows you to keep the focus on relevant content in the playground page and also speeds up things since the auxiliary files don't need to be recompiled if they don't change.
![bordered width=28%](images/41-sources-and-resources_261x137.png)

Also, note that each playground _page_ has its own sources and resources folders. If there is an image of the same name in a page's resources folder and also in the top-level resources folder, the image in the page's resources folder will take precedence.

### Manually run playgrounds

You can also now choose to _manually_ run code in a playground instead of it running automatically as you type; press and hold down the **play** button until a menu appears that lets you select **Manually Run**:
![bordered width=28%](images/42-manually-run-playground.png)

## Other improvements

There are many other features and improvements in Xcode 7 – unfortunately, too many to cover in detail in this chapter!

There are many improvements to storyboards and Interface Builder:
- After Control-dragging from one view to another to add a constraint, if you press Option you'll now also see the _constants_ for the constraints that will be added.
- You can now set the layout margins of a view, or the identifier of a constraint in a storyboard.
The constraints in the document outline in a storyboard now appear in a much more readable way.

There are also probably some changes that you might not even notice until somebody points them out to you. Like how if you've already implemented a delegate method, Xcode will no longer suggest it to you in the autocomplete menu. And how the Snapshots feature has been removed entirely.

Before this chapter comes to an end, there are two other features worth mentioning briefly...

### Address sanitizer

Xcode includes a new tool that will help catch memory corruption errors that may occur when using Objective-C or C. When enabled, Xcode will build your app with additional instrumentation to catch memory errors in the act.

You can enable address sanitizer by going to **Product \ Scheme \ Edit Scheme** and placing a checkmark next to **Enable Address Sanitizer** under **Diagnostics**:
![bordered width=75%](images/43-address-sanatizer_896x218.png)

### Right-to-left support

iOS 9 contains significant updates for the support of right-to-left languages such as Arabic and Hebrew. For these, the complete view hierarchy will be flipped, and navigation will occur in the opposite direction. If you've been using Auto Layout (and you really should be!), this should mostly "just work".

There is also a new option to test your view hierarchy in this flipped state without having to change your primary language. Edit your scheme and in the **Options** view, under **Application Language**, there is a new **Right to Left Pseudolanguage** option that you can select:
![bordered width=70%](images/44-right-to-left-pseudolanguage.png)

## Where to go from here?

Wow. You've learned a _lot_ about Xcode in this chapter — from its new documentation and code browsing features to the new energy impact gauge and Core Location instrument that will help make your apps more energy efficient.

You also learned about the various improvements to playgrounds as well as a few other miscellaneous things along the way.

Here are a few links to relevant resources that you might want to check out:

- [Playground Markup Format for Comments (http://apple.co/1IG2eZ9)](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Reference/Playground_Ref/Chapters/MarkupReference.html)
- [Energy Efficiency Guide for iOS Apps (http://apple.co/1OEIHMf)](https://developer.apple.com/library/prerelease/ios/documentation/Performance/Conceptual/EnergyGuide-iOS/)

And here are a few related WWDC 2015 videos to keep you busy:

- [What's New in Xcode (http://apple.co/1M0Fx8e)](https://developer.apple.com/videos/wwdc/2015/?id=104)
- [Authoring Rich Playgrounds (http://apple.co/1TieQQE)](https://developer.apple.com/videos/wwdc/2015/?id=405)
- [Debugging Energy Issues (http://apple.co/1gYPZAo)](https://developer.apple.com/videos/wwdc/2015/?id=708)
- [Achieving All-day Battery Life (http://apple.co/1P2jXxC)](https://developer.apple.com/videos/wwdc/2015/?id=707)
