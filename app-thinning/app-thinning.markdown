```metadata
author: Derek Selander
number: 4
title: App Thinning
```

# Chapter 4: App Thinning

Kicking yourself that you didn't drop the extra dinero to multiply your iOS device's disk storage size by a factor of two? Feeling constrained by how massively huge your brilliant app concepts would be? Well, don't! Apple now takes a more frugal approach to how apps are stored on a device.

With the introduction of iOS 8 and the demanding displays of the iPhone 6 and 6 Plus, Apple began pushing developers to adopt a more universal approach to building across devices. Adaptive Layout, Trait Collections, Universal split view controllers and (a more respectable) Auto Layout led to a seamless experience for the iOS developer to build universal applications for both iPhone & iPad.

However, it also meant that a so-called universal app requires a substantial chunk of device-specific content, and it sure has a huge impact to an app's bundle size. For an example, look at the chart below to see all the 1s and 0s that are stored locally on the device, but are never used unless the app runs on an iPhone 6+. 
	
![width=%70](./images/Device-Breakdown.png)

$[break]

Fortunately, with the introduction of iOS 9, Apple introduced several solutions to address this problem:

- **App Slicing**: When you submit your iOS 9 binary to the App Store, Apple compiles resources and executable architecture into variants that are specific to each device. In turn, devices only download the variant specific to their traits — meaning they only get content they will use. Traits include graphics capabilities, memory level, architecture, size classes, screen scaling and more. 
- **On Demand Resources**: Application resources are downloaded as needed and can be removed if the device needs room for other resources.
- **Bitcode**: An intermediate representation of your compiled app can be sent when submitting to the App Store. This allows Apple to optimize your executables by compiling with the latest optimizations for a given target, including types that didn't exist when you submitted your app. 
 
Packaged together, these techniques are known as **App Thinning**.

## Getting started

Open the **Old CA Maps** starter project. This application displays historical aerial overlays of different parts of California on a map. 

What you have here is a close-to-final project that's about to be fired off to the App Store. But don't do it just yet, because the resources for this seemingly simple app make it a storage hog. It takes up over 200 megabytes! 

Before sending it off, you'll use App Thinning techniques to hack-and-slash the end product to a more manageable size. But before you do that, take a tour around the app. It's pretty sweet.

With the Xcode project open, select the **iPad Air 2 Simulator** as the **scheme destination**, and then build and run the application.

Play around with the app for a bit. Tap on **Santa Cruz** and other overlays and see how the historical maps overlay with present-day maps. 

![bordered ipad-landscape](./images/ipad_air_2_starter_landscape.png)

>**Note**: These overlays are created from image tiles that are found in `NSBundle`(s) and passed into a `MKTileOverlayRenderer` for drawing. Curious about what's going on under the hood? Unfortunately, if this chapter explored all of it, it would be impossibly long. Think of this stuff as a black box – all you care about is how to make this app as small as possible for the end user. :] 

### The anatomy of an app 

When compiling your code into any iOS application, it's good to understand what Xcode does behind the scenes. So before you start thinning it out, take a few minutes to understand what happens.
	
This project contains a run script that launches a finder window with the location of the build directory where you'll see an app file — otherwise known as the application bundle. Build and run, and in Finder, right-click **Old CA Maps** and select **Show Package Contents** to view the compiled bundle.

![bordered width=%40](./images/show_app_contents.png)

Understanding the content that goes in to your completed application will be useful when working with App-Thinning. Below is a side-by-side comparison of the Old CA Maps Xcode project's directory (on the left) and a release build of Old CA Map's application bundle's contents (on the right). Your output might vary slightly depending on your device type, build configuration and Xcode version.

![bordered width=%70](./images/Directory_IPA_Comparison.png)

There are a few important items to note:

- The assets catalog in Xcode named **Assets.xcassets** will become a binary version named **Assets.car** in the application bundle. This file's job is to hold resources specific to different scales, size classes and devices. 
- Check out the sizes of each of the bundles. Notice the **SD_Map.bundle** is nearly 120 MB! 
- The item called **Old CA Maps** with the terminal icon is the executable for your application. This is the actual program that runs on an iOS device. 
- Notice there are three **Santa Cruz PNGs** in the project – but not in a bundle or asset catalog – that did not copy into the **Assets.car** file. Instead, they copied to a top-level directory that won't get sliced! Guess what? You're going to fix that soon...

### Measuring your work

It's always helpful to quantitatively measure your progress when making changes, and working with App Thinning is no exception. Specifically, you'll want to know how big the application bundle is before and after. 

Fortunately, there's already a build script in the app package that produces the size of the bundle in kilobytes. 

To view the size of a build using this script, first build the project, then:
1. Navigate to the **Report Navigator**.
2. Select the **Build** you wish to inspect. 
3. Make sure the **All** and **All Messages** are selected
4. Find the **Run custom shell script** output.

![bordered width=80%](./images/app_size_viewing.png)

You'll occasionally come back to this output to see your progress as you whittle the app down to size. 

Although it won't show the exact size of the IPA you'll submit to the App Store, it'll give you a good idea of your success.

## Slicing up app slicing

App slicing can be broken out into two parts: executable slicing and resource slicing. 

**Executable slicing** simply means Apple delivers a single executable of the appropriate architecture for a given device. You don't need to do much to help the App Store make this happen. 

By default, release builds include all architectures configured in your build settings. When you submit such a build to the App Store, it automatically creates the variants needed on your behalf. All _you_ have to do is compile for iOS 9. 

![bordered width=35%](./images/apple_heavy_lifting.png)

## Being smart with resources

**Resource slicing** takes a tiny bit more work than doing absolutely nothing...but not by much. :]

All you have to do is make sure your resources are compiled into **Asset Catalogs** and organized according to traits. You probably already organize your image assets according to scale factors. With Xcode 7, you can also tag assets by **Memory** and **Graphics** requirements in the Attributes Inspector.

![bordered height=25%](./images/new_trait_attributes.png)

- The **Memory** setting lets you target different assets to devices with different amounts of RAM. 
- The **Graphics** setting allows you to target either first or second generation Metal-capable GPUs.

When you make use of these new settings, along with scale factors and device types, the App Store can slice your app into targeted bundles for specific devices.

As you noticed earlier, the Santa Cruz assets are not correctly compiled into the Assets.xcassets catalog within Xcode, resulting in the images being copied over to the main bundle. This means they won't be sliced, so they'll land on devices where they won't be used and tragically, consume storage for no real reason.

### Your first fix

The fix for this is quite simple: Just stick the Santa Cruz PNGs into the asset catalog.

Click **Assets.xcassets**, then click the **+** and select **New Image Set**. Drag the Santa Cruz images from the project navigator into their respective @1x, @2x and @3x slots, and make sure the **Image Set** name is **Santa Cruz**.

![bordered width=50%](./images/create_new_asset_group.png)

Once the images copy to the assets catalog, delete the Santa Cruz PNGs from the resources folder.

After that, make sure the Santa Cruz assets in the catalog looks like:

![bordered width=90%](./images/Santa_cruz_asset_catalog.png)

Build and run the application, again selecting the **iPad Air 2 Simulator**. Take a look at the size of **Assets.car** by looking at the package contents in the build directory as you did earlier.

![bordered width=40%](./images/ipad_air_2_asset_car_size.png)

This is using the @2x image for Santa Cruz, and it ends up at 107 KB. You may see a slight difference based on the compiler version you use.

>**Note**: Reviewing a debug build is a great way to see how App Thinning works, and even before App Thinning existed, Xcode was tailoring debug builds to the targeted device. So, App Thinning essentially builds on what Xcode already did, but now, the end user enjoys the benefits.

$[break]
Now build and run with the **iPhone 6 Plus** simulator and take a look at the size of **Assets.car**:
![bordered width=40%](./images/iphone_6_plus_asset_car_size.png)

As you can see, it's up to 144 KB. It makes sense that this build is larger given the higher resolution of @3x images used by the iPhone 6 Plus. While it may not directly reflect the size of the bundle on the store, this gives you a relative idea of how thinning works to size your bundle according to the needs of the target device.

>**Note**: Although PNGs are a good way to provide resources, you should also consider using vector-based PDFs. Xcode breaks down the PDF and resizes the image as needed, essentially future-proofing your app for whatever screen scales Apple comes up with. All the other thumbnail images in Old CA Maps use vector-based PDFs.

## Lazily (down)loading content

Now that you've migrated all the images into asset catalogs, essentially removing unused images, it's time to take a more aggressive approach at limiting content by using **On-Demand Resources**, or simply, **ODR**. 

ODR allows you to store resources on Apple's servers, and then your app can pull them down as needed.

`NSBundleResourceRequest` is responsible for dealing with ODR. By using this primary class, you can control the content that downloads with the use of **Tags**, which are string names you attach to resources that properly identify a group of content to download. 

Through tags, Apple abstracts the remote resource storage location and retrieval URL for your ODR content.

So, what can you include when using ODR? They can be images, data, OpenGL shaders, SpriteKit Particles, Watchkit Complications and more. The main thing to understand is that _ODR can't be executable code_. 

Fortunately for this particular application, NSBundles fall into the data file category. This means you can apply ODR to the bundles without changing any of the file infrastructure within Old CA Maps. 

$[break]
### Wire things up to use tags

Time to finally whip out your coding skills. 

Navigate to **MapChromeViewController.swift** and hunt down the **downloadAndDisplayMapOverlay()** function. It's here that you'll replace the synchronous loading of a local bundle with an asynchronous load for a remote bundle obtained through a `NSBundleResourceRequest`.

Replace the contents of `downloadAndDisplayMapOverlay()` with the following:
    
```swift 

// 1
guard let bundleTitle =
  mapOverlayData?.bundleTitle else { 
    return
}

// 2
let bundleResource =
NSBundleResourceRequest(tags: [bundleTitle]) 

// 3
bundleResource.beginAccessingResourcesWithCompletionHandler {
  [weak self] error in 

  // 4
  NSOperationQueue.mainQueue().addOperationWithBlock({

    // 5
    if error == nil {
      self?.displayOverlayFromBundle(bundleResource.bundle) 
    }
  })
}
```

What's going on in there?

1. Here you're grabbing the `bundleTitle` associated with your `mapOverlayData`, which was already set with an appropriate title in the included **HistoricMapOverlayData.swift**. You're using the `guard` statement, a new feature in Swift 2.0, that lets you maintain the "Golden Path" of code by returning immediately if the unwrap fails.
2. You're instantiating an `NSBundleResourceRequest` with the `bundleTitle` tag associated with your bundle. You'll add tags to all the content bundles shortly. 
3. `beginAccessingResourcesWithCompletionHandler(_:)` calls the completion block when your app finishes downloading on-demand content or upon error.  
4. The completion handler is not called on the main thread, so you'll need to supply a block running on the main queue to handle any updates to the UI. 
5. `NSBundleResourceRequest` has a read-only variable named **bundle**. Replacing `NSBundle.mainBundle()` with this variable makes the code more extensible if you decided to move the file structure of your resources around.

### How about those tags?

Build, run, and click on one of the cities. 

Whoops! Xcode should fail to load an overlay, and it'll spit out an error in the console. This is because you've told the `NSBundleResourceRequest` to look for tags that don't exist. Time to fix that.

Navigate to the Project Navigator tab and expand the **Map Bundles** group. Select **LA_Map.bundle**, and open Xcode's **File Inspector** tab on the right. Find the **On Demand Resource Tags** section. 

Give **LA_Map.bundle** the tag name **LA_Map**. Now go through the four remaining bundles and give each a tag name identical to the bundle name without the file extension. These will match the names used for the `bundleTitle` that were set in **HistoricMapOverlayData.swift**.

![bordered width=78%](./images/Xcode_Asset_Tagging.png)

>**Note**: Make sure you spell the tag name with _exactly the same_ spelling and case as the bundle file name. If you mistype it, you'll encounter issues.  

Build your application for **iPad Air 2**, but don't run it yet, using __Command-B__. Take note of the application bundle size in the report navigator. 

Originally, the app was over 200 MB. Now, Old CA Maps is around 10MB. Xcode has achieved this by removing the bundle resources from the main application bundle, which can be confirmed by reviewing its contents:

![bordered width=28%](./images/bundle_size_after_odr.png)
 
Now run your application. Select **Los Angeles** as the overlay and observe what happens. The app now downloads content on demand, then displays the overlay and adjusts the map when completed.

>**Note**: When your app is live in the App Store, it'll download these resources from there. However, to achieve the same effect while developing, Xcode makes a local network request from your device (or simulator) to your computer to download the ODR. This means that if you're testing your application and you turn your computer off, ODR will fail to work. It also means transfer time is significantly less when compared to what a user would see for assets housed on the store.

## Make it download faster

You tested loading Los Angeles, but as you may recall, the Los Angeles bundle asset is small in comparison to the San Diego bundle. 

Try clicking on the **San Diego** overlay and see how long it takes to display the content.

>**Note**: If you choose a city that you've already viewed after building and running, you're likely going to notice it loads immediately, because ODR caches the assets until purge conditions are met. You'll learn more about this later.  

![width=35%](./images/iOS_10_before_loads.png)

That took a little bit too long to display, right? Can you imagine how long it'll take for users that pull assets that are hosted on the store?

![width=40%](./images/user_tired_of_wait.png)

To avoid a deluge of rotten tomatoes and bad reviews, you'll need to show the user that something is happening while the app downloads content. 

Fortunately, `MapChromeViewController` already has an `IBOutlet property` called `loadingProgressView` which is a `UIProgressView`. You'll feed that view progress data to present the user while also displaying the network activity indicator.

Navigate back to **downloadAndDisplayMapOverlay()** and replace the content with the following:

```swift
guard let bundleTitle =
  mapOverlayData?.bundleTitle else {
    return
}

let bundleResource
  = NSBundleResourceRequest(tags: [bundleTitle])
// 1
bundleResource.loadingPriority
  = NSBundleResourceRequestLoadingPriorityUrgent 

// 2
loadingProgressView.observedProgress
  = bundleResource.progress 

// 3
loadingProgressView.hidden = false 
UIApplication.sharedApplication()
  .networkActivityIndicatorVisible = true


bundleResource.beginAccessingResourcesWithCompletionHandler {
  [weak self] error in
  NSOperationQueue.mainQueue().addOperationWithBlock({
    // 4
    self?.loadingProgressView.hidden = true 
    UIApplication.sharedApplication()
      .networkActivityIndicatorVisible = false
    
    if error == nil {
      self?.displayOverlayFromBundle(bundleResource.bundle)
    }
  })
}
```

1. This tells the system that the user is "patiently" waiting for this download and the system should be diverting all resources to complete it ASAP. 
2. The `loadingProgressView` hooks into the `NSProgress` of the `NSBundleResourceRquest`. It will begin updating automatically once `beginAccessingResourcesWithCompletionHandler(_:)` is kicked off.
3. Display the `loadingProgressView` and also the network activity indicator to inform the user that a network request is in progress.
4. Once the download completes, hide the `loadingProgressView` and network activity indicator. This code could result in unexpected results due to a potential race condition if there are concurrent downloads. However, for this simple implementation, this approach is sufficient. 

Build and run the application. Try all the bundles again and you'll notice a progress indicator just below the navbar while a download is in progress. 

It's better because at least there's a visual queue that something is happening, but the 120MB San Diego download still takes an eternity. Time to try something a bit more drastic. 

## The many flavors of tagging

Displaying the progress makes for a better experience, but nobody wants to wait for a download. Keep in mind that you're testing on a controlled device with Simulator and locally hosted resources. Imagine a real-world user moving in and out Wi-Fi or cellular coverage. 

![width=40%](./images/mobile_data_connections.png)

The San Diego asset is big and also likely to be the first thing the user selects since it's the first item in the table. It makes sense to include the San Diego asset along with the application itself so it feels snappy on initial use. 

At the same time, you need the flexibility to remove this huge overlay asset if the user runs low on disk space. 

### Initial install tags

The answer to this is **Initial Install Tags**. They work the same as the tags you've used so far, but they download with the app and count towards the size of the IPA. 

Open up the **Old CA Maps Project**, click on the Old CA Maps in the **Target** section and then select the **Resource Tags** tab. 

Before you make any changes, note that tags come in three type categories that define how ODR handles them. 

- **Initial Install Tags:** These install with your application. So why bother to manage them with ODR? Because you can remove it when it's no longer needed. These tags are perfect for resources you'll only need to use at first. 
- **Prefetched Tag Order:** These tags download once the application finishes downloading and in the order in which they are arranged. 
- **Download Only On Demand:** These resources are the ones you've worked with so far, and they download when you code them to do so. 

Next, move the San Diego bundle with the **SD_Map** tag from the **Download Only on Demand** section to the **Initial Install Tags** section. 

To do this, select the tag and drag it into the Initial Install Tag section. 

In addition to having San Diego load with the application, it would make sense to kick off San Francisco sooner than later since it is about 40MB. 

Drag **SF_Map** over to the **Prefetched Tag Order section** to trigger downloading as soon as the app is installed.

Once you're done, your tag setup should look like this:

![bordered width=70%](./images/Install_Tag_Groups.png)

Unfortunately, testing these changes is a bit trickier. You will have to submit your app to **TestFlight Beta Testing** in order to see these changes propegated in your app.

## Purging content

Since the OS can purge ODR content, provided that it's not in active use, it's important to be a good disk storage citizen. You can help guide the system to resources that you don't need anymore, which can decrease your app's footprint.

Change your build scheme to **iPhone 6 Plus**, then build and run the application. Tap on a city, then press the **back arrow** to jump back to the previous city selection screen. 

For these particular bundles, it's likely that you no longer need them as soon as you exit the view of a `MapChromeViewController`. But how do you know what the system does with your ODR content behind the scenes?

Fortunately, Apple has anticipated this problem and Xcode 7 ships with a super useful debugging view to aid in understanding the status of your ODR content.

With the app running, open the **Debug navigator** tab (1), then click on the **Disk** cell (2). Xcode will reveal a disk report that includes valuable information regarding the current status of each tagged ODR.

![bordered width=80%](./images/ODR_Guages.png)

As you can see, after clicking an image then clicking back, this view indicates that the ODR resource is still **In Use** while other resources are either **Not Downloaded** or **Downloaded**. 

Although UIKit and Foundation provide their own logic about when the device can reclaim these bundles, it's ideal to tell the system when your app is done with them.
### Set a resource to be purged

You'll indicate that the `NSBundleResourceRequest` is available for the system to reclaim as soon as you leave the `MapChromeViewController`.

Open up **MapChromeViewController.swift** and add the following property to the beginning of the class: 

```swift
var overlayBundleResource: NSBundleResourceRequest?
```
Now, in the **downloadAndDisplayMapOverlay()** function, add the following line underneath the `NSBundleResourceRequest` instantiation:

```swift
overlayBundleResource = bundleResource
```

Finally, add a new method override to `MapChromeViewController` to tell the system that you're done with the resource request when the view disappears:

```swift
override func viewDidDisappear(animated: Bool) {
  super.viewDidDisappear(animated)
  overlayBundleResource?.endAccessingResources()
}
```

Rebuild and run the system and keep an eye on the **Disk Report** screen while exploring different cities. The report should now indicate that your ODR content is no longer in active use as soon as you leave the map view screen. Sweet.

## Where to go from here? 

Congratulations, you've learned the in and outs of App Thinning! Remember that the same cellular limits apply for ODR resources, so there are limits on the resource size you can download.

Make sure to thoroughly test your ODR tags in a real-life setting using **TestFlight** before shipping your app off to the App Store. 

Also be sure to check out these WWDC videos:
- [Introducing On Demand Resources (http://apple.co/1HMTaju)](https://developer.apple.com/videos/wwdc/2015/?id=214)
- [App Thinning in Xcode (http://apple.co/1Kn8HIA)](https://developer.apple.com/videos/wwdc/2015/?id=404)

Now that you've tapped into App Thinning, you should be able to make those big, beautiful apps while being mindful of the user's storage space. 

While you might see amazing benefits, like a gajillion more downloads or parades to celebrate your brilliance, you're more likely to see reasonable benefits like fewer uninstalls, more usage and more positive reviews. That should be enough incentive to get you excited about App Thinning.