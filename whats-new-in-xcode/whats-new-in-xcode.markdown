# Chapter 14: What's New in Xcode

As an iOS developer, the single most important tool that you use is Xcode, and each new release adds a variety of features and improvements. In prior chapters, you've already learned about many of Xcode's new features such as storyboard references, support for app thinning, improvements to testing, code coverage, and many more.

This chapter will introduce you to some of the other new features in Xcode such as the new energy gauge, and improvements to playgrounds. Along the way, you'll also learn about some of the other miscellaneous features and improvements that will make you a more productive developer.

## Getting Started

In this chapter, you'll work with an app called **Local Weather** which uses your GPS location to show you the weather.

You won't make too many changes to the app, but rather, you'll use it to explore the various new features of Xcode, especially the new energy gauge. You'll need to run the app on an actual device since the energy gauge in Xcode isn't displayed when running the app on the simulator.

Open **LocalWeather-Starter** and select your device from the destination menu:
![bordered width=50%](images/01-select-your-device_391x105.png)

> **Note:** If you're not able to run the app on your device, it may not be provisioned. See the next section on **Free Provisioning** to get setup.

After selecting your device, build and run. Then tap on **Allow** on the location access request. The location and weather should update fairly quickly:
![bordered width=31%](images/02-app-screenshot_750x1334.png)

While the energy gauge won't show up unless you run the app on a device, you can still run it on the simulator. If you do, make sure to select a location using the Simulate location button in the Debug area. You can also use this feature to simulate a different location while running on your device. Perhaps you'd like to find out how cold it is in Moscow. No problem, just simulate it from the menu.
![bordered width=31%](images/03-simulate-location_199x113.png)

### Free Provisioning

One of the major changes this year is Free Provisioning so that anyone with an Apple ID can build and run their iOS app on a physical device, without having to join the $99/yr Apple Developer Program. Now you only need to join the paid program if you want to distribute apps on the App Store.

If your device isn't already provisioned see the following link to set things up:

[Launch Your App on Devices Using Free Provisioning (http://apple.co/1KJ12tJ)](https://developer.apple.com/library/prerelease/ios/documentation/IDEs/Conceptual/AppDistributionGuide/LaunchingYourApponDevices/LaunchingYourApponDevices.html#//apple_ref/doc/uid/TP40012582-CH27-SW3)

### API Key (Optional)

**Local Weather** uses the _Current weather data_ API from [openweathermap.org](http://openweathermap.org/). While the API works without the use of an API key, OpenWeatherMap notes that they reserve the right to not process requests made without an API key.

You can sign up for an API key at [openweathermap.org/register](http://openweathermap.org/register).
![bordered width=50%](images/04-open-weather-map-signup_773x544.png)

If you do sign up, open WeatherViewController.swift and towards the top of the file replace `"YOUR_API_KEY_HERE"` with your new API key.

```swift
let openWeatherMapApiKey = "YOUR_API_KEY_HERE"
```

## New Energy Impact Gauge

Exploring the new energy gauge will be a major part of this chapter. With the app running on a device, switch to the **Debug navigator** and click on **Energy Impact**:
![bordered width=30%](images/05-choose-debug-navigator_260x204.png)

You'll see the new iOS energy gauge and it looks like the app a bit power hungry!
![bordered width=98%](images/06-first-show-of-gauge_1281x480.png)

The _Utilization_ section on the top left shows you the instantaneous energy impact. The top right shows the _Average_ energy impact as well as the _Overhead_.

At the bottom, you see four rows of blocks corresponding to CPU, Network, Location, and Background. If there is any kind of activity during a single second, it will be represented by a gray block.

Note that the CPU and Location graphs show continuous activity. The Network graph shows an interesting pattern of 10 or 11 seconds of activity, then 3, 4, or 5 seconds of inactivity. The Background graph is completely clear since the app hasn't been put into the background -- yet.

Press the home button to background the app. You'll eventually end up with the following graph in which the Location and Network activity will cease but you'll have continuous activity for Background and CPU:
![bordered width=98%](images/07-background-activity_1203x480.png)

Take a look at the console. The log indicates that all of the background tasks were completed in 10.79 seconds, but the background energy graph didn't stop.
![bordered width=60%](images/08-background-activity-completes-in-10-seconds_503x184.png)

You'll be fixing these energy issues but not just yet. First you'll take a quick detour to learn about some of the new features of Xcode that will speed up the way in which you browse and learn about new code.

## Code browsing features

There are many new features in Xcode that will not only help with development but will also allow you to get up to speed with a new code base even faster. You'll use these new features to get a basic understanding of the architecture of the app after which you'll fix each of the energy issues you just saw.

### Interface of Swift classes

Remember the good old Objective-C headers that would show you the public interface for a class? You probably don't miss maintaining those headers, but you must certainly miss having them, since if you wanted to get a quick summary of a class and its capabilities, you'd open up the header file to see what it could do.

Wouldn't it be dreamy if you could have a header file for Swift classes but didn't have to maintain it? Crazy talk you say?

Open **WeatherViewController.swift** and then open the **Assistant editor**. Click on the Assistant editor menu and choose **Counterparts (1) ► WeatherViewController.swift (Interface)**:
![bordered width=75%](images/09-assistant-editor-counterparts_498x79.png)

And like magic, in the Assistant editor you'll see the public interface of your class:
![bordered width=75%](images/10-public-interface-of-swift-file_699x343.png)

Any variable or method declared private won't show up in the interface. Take a look at the following part of WeatherViewController.swift:
![bordered width=75%](images/11-part-of-class-to-demo-interface_699x209.png)

Now look at the interface again and note that `locationManager` isn't visible since it's declared `private` nor are any of the outlets visible since they are all `private`.

> **Note**: Since the class is self-contained, every variable and method could have been `private`. But then there wouldn't have been an interface to demo!

In **WeatherViewController.swift**, delete `private` from the following:

```swift
private let locationManager = CLLocationManager()
```

Now press **Command-B** to build the project. You'll now see `locationManager` show up in the interface as well:
![bordered width=75%](images/12-location-manager-shows-up_699x69.png)

Did you notice that the comment for `countdownUpdateTimer` shows up in the interface but the comments for `weatherNeedsFetchUpdate` and `networkFetchTimer` do not? A documentation comment is required to start with either **///** or **/\*\***. Add an extra **/** to the comment for `weatherNeedsFetchUpdate` and an extra **\*** to the comment for `networkFetchTimer`. Then press **Command-B** and you'll see both comments show up:
![bordered width=75%](images/13-now-both-show-up-after-adding-extra-chars_699x130.png)

Now wouldn't it also be cool if you could take an _Objective-C_ header file and see what it would look like in Swift? No problem, coming right up!

### Generated Swift interface for Objective-C headers

In the **Project navigator** expand the **Helpers** group and you'll see RWHTTPManager.h and RWHTTPManager.m. RWHTTPManager is a convenience wrapper around `NSURLSession` written in Objective-C.

Click on **RWNetworkHelper.h** to open it in the primary editor:
![bordered width=75%](images/14-objc-file-in-primary-editor_714x147.png)

Now take a look at the Assistant editor:
![bordered width=75%](images/15-swift-interface-of-an-objective-c-file_731x123.png)

Isn't that just magical? There is an issue though, and it's a bit harder to catch in the RWHTTPManager.h file. Take a look at the Swift interface and note that in `init(baseURL:)` the type of `baseURL` is `NSURL` i.e. not optional, but the actual `baseURL` variable on the line above it, is of type `NSURL?` i.e. an optional. The init method is correct, but `baseURL` should be of type `NSURL` instead of `NSURL?`.

Go ahead and delete the **?** from `var baseURL: NSURL?`. Can you? I'll wait. :]

Ok, so that was a bit of a trick question (or was it a trick task?). You can't delete the `?` from the interface file since it's not a real file!

Look at **RWHTTPManager.h** and note that `NSURL` is annotated with `_Nullable`:

```objc
@property (nonatomic, strong) NSURL * _Nullable baseURL;
```

Change `_Nullable` to `_Nonnull`:

```objc
@property (nonatomic, strong) NSURL * _Nonnull baseURL;
```

Press **Command-B**. You may see a blank screen for the interface. If so click on **Counterparts**, switch to anything other than **Counterparts** and then switch back to **Counterparts ► RWHTTPManager.h (Interface)**. Note that `baseURL` is no longer an optional:

```swift
var baseURL: NSURL
```

> **Note**: You can also select **Generated Interface** instead of **Counterparts ► RWHTTPManager.h (Interface)** to view the same result.

There is actually another issue. Note that the `relativePath:` parameter takes a `String?` whereas the comment says `relativePath` is required. Can you fix this yourself? Go ahead and try it.

Ok I'll give you the answer, but I'm going to have to make it upside down so that it really feels like a puzzle:
![bordered width=50%](images/16-upside-down-answer_385x15.png)

Next you'll read some documentation!

### New documentation features

Open **WeatherViewController.swift** and look at **updateCountdownLabel()**. Note the call to `FormatHelper.formatNumber(_:withFractionDigitCount)` right under the **Step 8** comment. **Option-click** on `formatNumber` and you'll see the documentation appear in rich formatting.
![bordered width=70%](images/17-option-click-on-format-number_522x315.png)

Now **Command-click** on `formatNumber` to jump to the implementation of the method. It's just using basic markdown syntax!
![bordered width=75%](images/18-rich-documentation_717x188.png)

Think of all the beautiful documentation you'll now be able to produce!

### Find Call Hierarchy

Seeing documentation is great, but you also want to see all the places this method is used. **Right-click** on `formatNumber` and then click on **Find Call Hierarchy**.
![bordered width=50%](images/19-find-call-hierarchy_500x147.png)

Boom! You'll see all the places that `formatNumber` is called from. How cool is that?
![bordered width=50%](images/20-find-call-hierarchy-results_425x159.png)

And you can also drill down to view the complete call hierarchy:
![bordered width=50%](images/21-find-call-hierarchy-expanded_425x279.png)

So from here you can see the different places that `formatNumber` is used and quickly jump to any level in the call hierarchy just by clicking on it.

## Decreasing energy impact

It's time to get back to fixing those pesky energy issues! Before you dive in, here is a brief summary of the app flow:

First the current location is requested. Once the location is received, an HTTP request is made to fetch the weather for that location. Once weather data is received, views are updated and another request is scheduled for 15 seconds later. Every 0.1 seconds, `countdownLabel` will be refreshed to show the time remaining until the next network request.

That was a quick high-level overview. To review the app flow in a bit more detail you can press **Command-Shift-F** and search for **// Step**:
![bordered width=60%](images/22-find-the-steps_469x281.png)

Do you recall the interesting behavior in which you saw 10 - 11 seconds of Network activity and then 3 - 5 seconds of non-activity? This is because any time a network request is made, the network radios stay on for about 10 seconds even after the network request completes.

This makes the amount of overhead for a single network request very high. While you may have thought that you were just using the network radio for about 1 second every 15 seconds (about 7%), you were actually using it for 11 seconds out of 15 seconds (about 73%).

This is the first thing you'll fix.

### Reducing Network energy impact

A weather app doesn't really need to update every 15 seconds. It's ok if it only updates whenever the user launches the app. Comment out the following line below **Step 6** that initializes the `networkFetchTimer`:

```swift
// Step 6: Set a timer to fetch the weather again in 15 seconds
// networkFetchTimer = NSTimer.scheduledTimerWithTimeInterval(15, ...
```

Build and run, switch to the **Debug navigator** and click on the **Energy Impact** row to see the updated energy gauge:
![bordered width=80%](images/23-network-energy-reduced_970x326.png)

That looks much better! Now the app will only make a single network request when it starts which is probably good enough for a weather app.

### Reducing CPU energy impact

In the previous graph, notice that the CPU is still being used even though the app really isn't performing any work.

The cause of the CPU activity is the `countdownUpdateTimer` that updates the `countdownLabel`. It continually sets the remaining time to 0 since there is no longer an active `networkFetchTimer`:

Comment out the line below **Step 7** that initializes `countdownUpdateTimer`:

```swift
// Step 7: Update the countdown label every 0.1 seconds using a timer
// countdownUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1 ...
```

For good measure, comment out the line that unhides the `countdownLabelStackView` a few lines above, since you no longer need to see the countdown label.

```swift
// countdownLabelStackView.hidden = false
```

Build and run, and go back to the energy gauge. This looks much better!
![bordered width=80%](images/24-cpu-usage-reduced_970x328.png)

### Reducing Location energy impact

The next thing to do is to reduce the Location energy impact by turning off GPS. Once the initial location is received, you no longer need location updates so you should add a call to `locationManager.stopUpdatingLocation()`.

However, in iOS 9 if you only need a single location update, you can just call `requestLocation()` instead of `startUpdatingLocation()` and then you won't need to call `stopUpdatingLocation()` yourself.

In **requestLocationAndFetchWeather()** replace `.startUpdatingLocations()` with `.requestLocation()`:

```swift
// Step 2: Request the location
locationManager.requestLocation()
```

Build and run. You'll see that after the initial activity all other activity is eliminated.
![bordered width=80%](images/25-no-location-activity_970x328.png)

### Reducing Background energy impact

Recall that when you pressed the home button, the Background graph started registering activity but didn't stop, even though the console log indicated that all background work was complete in about 11 seconds.

Open **AppDelegate.swift** and take a look at **performBackgroundWork()**. Technically the method isn't doing any real background work, it's just simulating 10 seconds of activity, but pretend that it is. The one rule of calling `beginBackgroundTaskWithExpirationHandler(_:)` is that once you're done with any work, you should call `endBackgroundTask(_:)` to let the system know that you no longer need further background execution time.

Add a call to `endBackgroundTask(_:)` at the end of `performBackgroundWork()` right after the print call:

```swift
print("Background work completed in: \(formattedElapsedTime) sec")
UIApplication.sharedApplication().endBackgroundTask(
  backgroundTaskIdentifier)
```

Build and run, go to the energy gauge, and press the home button to place the app in the background. You'll see that background activity now stops after 10 seconds:
![bordered width=80%](images/26-background-activity-stops_970x327.png)

You've fixed all of the energy impact issues using the new energy gauge but you'll take it a step further with the new Core Location instrument in Xcode.

### New Core Location Instrument

There is a new Core Location instrument you can use if you want to dig deeper into how location is being accessed. To open it, build and run, go to the energy gauge and click on the **Location** button below the gauge:
![bordered width=80%](images/28-click-on-location-to-open-location-instrument_974x161.png)

Click on **Restart** on the _Transfer current debug session_ prompt that appears:
![bordered width=40%](images/29-transfer-current-session-prompt_438x162.png)

Note the line: `CLLocationManager` changed accuracy to kCLLocationAccuracyBest. The Energy Impact column shows _High_ and the duration shows _892.03 ms_.
![bordered width=99%](images/30-location-instrument-accuracy-best_1050x278.png)

For weather, you really don't need `kCLLocationAccuracyBest`, which is the default.

Open **WeatherViewController.swift** and in **viewDidLoad()** add the following line before the locationManager's delegate is set:

```swift
locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
locationManager.delegate = self // Existing Line
```
Build and run, click on the **Location** button again, and then click on **Restart** on the prompt to get back to the Core Location instrument:
![bordered width=99%](images/31-location-instrument-accuracy-kilometer_1058x278.png)

It now says `CLLocationManager` changed accuracy to `kCLLocationAccuracyKilometer`, the Energy Impact is _Low_ and the fix was much faster as well at _5.74 ms_!

You now have the tools you need to be a good battery citizen on iOS and avoid ending up in the iOS battery _hall-of-shame_. In iOS 8, Battery Usage was buried 3 levels deep. You had to get to it via Settings > General > Usage > Battery Usage, but in iOS 9, it's now on the main Settings screen right above privacy!
![bordered width=32%](images/27-battery-settings_750x546.png)

It's now easier than ever for a user to keep an eye on the relative battery usage of their apps. And with the new energy gauge and Core Location Instrument, Apple has made it easier than ever for us to diagnose and fix energy issues as well.

## Playground Improvements

There have been many new features added to playgrounds since their debut in Xcode 6 last year. Support for rich authoring, auxiliary source files, and inline results were introduced in Xcode 6.3, released just 2 months before WWDC 2015. These features are significant, and even though they were initially released in Xcode 6.3, Apple has also chosen to make a note of them in their [New Features in Xcode 7 (http://apple.co/1JSDRMa)](https://developer.apple.com/library/prerelease/ios/documentation/DeveloperTools/Conceptual/WhatsNewXcode/Articles/xcode_7_0.html#//apple_ref/doc/uid/TP40015242-SW4) document.

Xcode 7 improves upon these features and adds others such as support for multiple pages, and the ability to pause code execution. Playgrounds were already an amazing education tool, and now support for multiple pages and the new authoring features now take them to the next level.

### Rich Playground authoring

Create a new playground, name it **Xcode7.playground**, and add the following to it:

```swift
//: # Level 1 Heading
```

```swift
//: ## Level 2 Heading
```

```swift
//: ### Level 3 Heading
```
Reveal the Utilities area by pressing **⌥⌘0** or by clicking on the Utilities button:
![bordered width=25%](images/32-utilities-button_227x67.png)

Under **Playground Settings** place a checkmark in **Render Documentation**:
![bordered width=99%](images/33-render-documentation-setting_961x81.png)

You'll now see the rendered markup:
![bordered width=99%](images/34-rendered-headings_960x269.png)

Unlike Xcode's documentation syntax which uses an extra comment character, for example **///** or **/\*\***, for playgrounds you instead use a colon. So for single line comments the syntax is **//:** and for multiline comments the syntax is **/\*:** and **\*/**.

Consecutive lines using **//:** are rendered in the same block. Uncheck **Render Documentation** and add the following:

```swift
// This is a regular comment and will be shown but not rendered
//: 1. The first item
//: 1. The second item
//: 1. And the third
```

Check **Render Documentation** again to see the output:
![bordered width=80%](images/35-first-block-syntax-example_506x115.png)

For multiple lines, you can also use the block delimiter **/\*:** and **\*/** and it will render as a block even if you have a blank line between any of the lines. Furthermore, anything that you add directly after **/\*:** won't be rendered at all.

Uncheck **Render Documentation** and add the following:

```swift
// An example using block comment syntax
/*: This is a comment and will not be shown at all
1. The first item
1. The second item

1. And the third
*/
```

Check **Render Documentation** once more:
![bordered width=80%](images/36-second-block-syntax-example_506x108.png)

Note that the text after **/:** is not shown at all.

This was just a brief introduction to get you started. For a full reference on syntax see: [Playground Markup Format (http://apple.co/1IG2eZ9)](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Reference/Playground_Ref/Chapters/MarkupReference.html)

### Playground Pages

You'll now add a second page to the playground. Reveal the Project navigator by pressing **Command-0**, and click on the **+** button on the bottom left, then click on **New Page**:
![bordered width=15%](images/37-add-new-page_125x102.png)

Name the newly added page, **Page Two** and rename the original page from **Untitled Page** to **Home**.
![bordered width=30%](images/38-home-and-page-two_260x109.png)

Go to **Page Two** and you'll see it already has **Previous** and **Next** links. Uncheck **Render Documentation** to see the plain text format of the links:

```swift
//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)
```

**@next** and **@previous** are special tokens to get you to the next and previous pages. To add a link to a specific page, you would just use the page name. If the name has a space, replace it with **%20**.

Add the following link anywhere in **Page Two**:

```swift
//: [Jump to Home](Home)
```

And the following anywhere to **Home**:

```swift
//: [Jump to Page Two](Page%20Two)
```

Now checkmark **Render Documentation** and try clicking on the links. You should be able to jump between both pages.

### Inline Results

Inline results let you see a result directly in the playground itself.

Add the following code to **Page Two**:

```swift
import UIKit
let viewFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
let view = UIView(frame: viewFrame)
view.backgroundColor = UIColor.redColor()
view.layer.borderColor = UIColor.blueColor().CGColor
view.layer.borderWidth = 10
view
```

Now click on the **Show Result** button in the sidebar:
![bordered width=28%](images/39-show-result-button_242x94.png)


You'll see the view appear inline right under the `view` variable:
![bordered width=40%](images/40-show-inline-result_408x195.png)

### Sources and Resources

You can now add auxiliary source files and resources to the Sources and Resources folder in playgrounds. Moving supporting code to the Sources folder allows you to keep the focus on relevant content in the playground page and also speeds up things since the auxiliary files do not need to be recompiled if they do not change.
![bordered width=28%](images/41-sources-and-resources_261x137.png)

Also, note that each playground page has its own Sources and Resources folder. If there is an image of the same name in a page's Resources folder and also in the top level Resources folder, the image in the page's Resources folder will take precedence.

### Manually Run playgrounds

You can now choose to manually run code in a playground instead of it running automatically. To set a playground to run manually, press and hold down the play button until a menu appears from which you can select **Manually Run**.
![bordered width=28%](images/42-manually-run-playground_262x84.png)


### Address Sanitizer

Xcode includes a new tool that will help catch memory corruption errors that are more likely when using Objective-C. When enabled, Xcode will build your app with additional instrumentation so that memory errors are caught right as they occur.

You can enable Address Sanitizer by going to **Product \ Scheme \ Edit Scheme** and placing a checkmark next to **Enable Address Sanitizer** under Diagnostics:
![bordered width=75%](images/43-address-sanatizer_896x218.png)

### Right to Left Support

iOS 9 contains significant updates for the support of right-to-left languages such as Arabic and Hebrew. For right-to-left languages, the complete view hierarchy will be flipped, and even navigation will occur in the opposite direction.

There is a new option that you can use to test your view hierarchy in that flipped state without having to change your primary language. Go to your scheme and in the **Options** view, under Application Language, there is a new **Right to Left Pseudolanguage** option that you can select:
![bordered width=75%](images/44-right-to-left-pseudolanguage_896x506.png)

### Other improvements

There are lots of other minor features and improvements that have been made and as you work with Xcode you'll come across these. Some things you'll notice right away, like how after Control-dragging from one view to another to add a constraint, if you press Option you'll now also see the _constants_ for the constraints that will be added. Or you'll learn that you can now set the layout margins of a view, or the identifier of a constraint in the storyboard.

There are others you may or may not notice, like how constraints in the document outline in the storyboard appear in a much more readable way. Or how in Xcode 7, if you've already implemented a delegate method it will no longer suggest it to you in the autocomplete menu.

And there are others that you may never notice. Remember the prompt asking you if you wanted to take automatic snapshots? Did you always choose disable because you had everything in git anyway? Well, you'll never get that prompt again because the Snapshots feature is gone.

## Where to go from here?

You've learned a lot about Xcode in this chapter. From its new documentation and code browsing features to the new energy gauge and Core Location Instrument that will help make your apps more energy efficient.

You also learned about the various improvements to playgrounds as well as a few other miscellaneous things along the way.

Congratulations on finishing the chapter as well as the book! I hope you enjoyed the journey and we'll see you again in iOS 10 by Tutorials!

Here are a few links to relevant resources:
- [Playground Markup Format for Comments (http://apple.co/1IG2eZ9)](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Reference/Playground_Ref/Chapters/MarkupReference.html)
- [Energy Efficiency Guide for iOS Apps (http://apple.co/1OEIHMf)](https://developer.apple.com/library/prerelease/ios/documentation/Performance/Conceptual/EnergyGuide-iOS/)

And here are a few related WWDC 2015 videos to keep you busy:
- [What's New in Xcode (http://apple.co/1M0Fx8e)](https://developer.apple.com/videos/wwdc/2015/?id=104)
- [Authoring Rich Playgrounds (http://apple.co/1TieQQE)](https://developer.apple.com/videos/wwdc/2015/?id=405)
- [Debugging Energy Issues (http://apple.co/1gYPZAo)](https://developer.apple.com/videos/wwdc/2015/?id=708)
- [Achieving All-day Battery Life (http://apple.co/1P2jXxC)](https://developer.apple.com/videos/wwdc/2015/?id=707)
