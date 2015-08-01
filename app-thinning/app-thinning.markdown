# Chapter _: App Thinning

Kicking yourself that you didn't drop the extra dinero to multiply your iOS device's disk storage size by a factor of 2? Well, don't! Apple is now taking a more frugal approach to how apps can be stored on your device.

When iOS 8 was introduced along with the iPhone 6 and 6 Plus and their new screen sizes, Apple began pushing developers to adopt a more universal approach to building across devices. Adaptive Layout, Trait Collections, Universal UISplitViewControllers, and (a more respectable) Auto Layout led to a seamless experience for the iOS developer to build universal application for both iPhone & iPad.

However, packaging a universal app with device-specific content has a huge impact to the bundle size of your app. Look at the chart below to see all the 1s and 0s being stored on your device never to be used. 

[NOTE TO EDITOR: Breakdown chart needed here...]

Fortunately, in iOS 9, Apple has introduced several solutions to address this problem:

- **App Slicing:** When you submit your iOS 9 binary to the App Store, Apple will compile resources and executable architecture into variants specific to each device. Devices will only download the variant specific to their traits, meaning they only get content they will use. Traits include graphics capabilities, memory level, architecture, size classes, screen scaling, and more. 
- **On Demand Resources:** Application resources are downloaded as needed and can be removed if the iOS device needs to make room for other resources.
- **Bitcode:** An intermediate representation of your compiled app can be sent when submitting to the App Store. This allows Apple to optimize your executables by compiling with the latest optimizations for a given target - including types that didn't exist when you submitted your app. 
 
Packaged together, these techniques are known as **App Thinning**.

## Getting Started

Open the **Old CA Maps** starter project. This application displays historical aerial overlays over different parts of California on a map. This is a close to final project about to be sent to the App Store. Unfortunately, the resources for this simple app takes up a huge amount of disk space (over 300 Megabytes!). You'll use the App Thinning techniques to hack-and-slash the end product to a more manageable size. 

With the Xcode project open, select the **iPad Air 2 Simulator** as the **scheme destination**, then build and run the application.

Play around with the app for a bit. Tap on **Santa Cruz** and other overlays and see how the historical maps overlay with the present day maps. 

![ipad-landscape](./images/ipad_air_2_starter_landscape.png)

>**Note:** These overlays are created from image tiles found in **NSBundle**s and passed into a **MKTileOverlayRenderer** for drawing. The details of how it works are well beyond the scope of this tutorial. Think of this stuff as a black box--all you care about is how to make this app as small as possible for the end user. :] 

### The Anatomy of an App 

When compiling your code into an iOS application, it's good to understand what Xcode is doing behind the scenes. 

This project contains a run script that will launch a Finder with the location of the build directory where you'll see an app file - otherwise known as the applicaiton bundle. Build & run, and in the launched Finder right click **Old CA Maps** and select **Show Package Contents** to view the compiled bundle.

![bordered width=%60](./images/show_app_contents.png)

Below is a side-by-side comparison of the Old CA Maps **Xcode project**'s directory (on the left) and Old CA Map's **application bundle**'s contents (on the right). Your output might vary slightly depending on whether you've built for a device or simulator.

![bordered width=%60](./images/Directory_IPA_Comparison.png)

There are a few important items to take note of:

- The assets catalog named **Assets.xcassets** in Xcode will become a binary version named **Assets.car** in the application bundle. This file's job is to hold resources specific to different scales, size classes, and devices. 
- Check out the sizes of each of the bundles. Notice the **SC_Map.bundle** is over 130 MB! 
- The item called **Old CA Maps** with the Terminal icon is the executable for your application. This is the actual program that is run on your iOS device. 
- Notice that the 3 **Santa Cruz PNGs** in the project but not in a bundle or asset catalog were not copied into the **Assets.car** file. Instead, they were copied over in a top-level directory - which won't get sliced! You will fix this soon...

### Measuring Your Work

It will be helpful to quantitatively measure your progress when working with App Thinning. You want to know how big the application bundle is before and after you touch this project. Fortunately, there is already a **Build Script** included in **Old CA Maps** that lists the size of the bundle in kilobytes. 

To view the size of a build using this script, first build the project, then:
1. Navigate to the **Report Navigator**
2. Select the **Build** you wish to inspect. 
3. Make sure the **All** and **All Messages** are selected
4. Find the **Run custom shell script** output.

![bordered width=90%](./images/app_size_viewing.png)

You will occasionally come back to this output to see your progress as you make the app smaller. Although this will not be the exact size of the IPA when you submit it to the App Store, this will give you a good idea of your progress with App Thinning.

## Slicing Up App Slicing

App Slicing can be further broken down into two parts: executable slicing and resource slicing. 

Executable slicing simply means Apple delivers a single executable of the apporpriate architecture for a given device. Fortunately, there isn't much you need to do to help the App Store make this happen. 

By default, **RELEASE** builds include all architectures configured in your build settings. When you submit such a build to the App Store, it will automatically create the variants needed on your behalf. All you have to do is compile for iOS 9. 

## Being Smart With Resources

Resource Slicing takes a tiny bit more work than doing absolutely nothing...but not by much. :]

All you have to do is make sure that your resources are compiled into **Asset Catalogs** and organized according to traits. You likely already organize your image assets according to scale factors. With Xcode 7, you can now also tag assets by **Memory** and **Graphics** requirements in the Attributes Inspector.

![bordered width=60%](./images/new_trait_attributes.png)

The **Memory** setting lets you target different assets to devices with different amounts of RAM. The **Graphics** setting allows you to target either first or second generation Metal capable GPUs.

Using these new settings along with scale factors and device types allows the App Store to slice your app into more targetted bundles for a given device.

As you noticed earlier, the **Santa Cruz** assets were not correctly compiled into the **Assets.xcassets** catalog within Xcode, resulting in images being copied over to the main bundle. This means they won't be sliced, landing them on devices where they wont' all be used.

The fix for this is quite simple. Just stick the **Santa Cruz** PNGs into the Asset Catalog.

Click the **Assets.xcassets**, then click on the plus button and select **New Image Set**. Drag over the Santa Cruz images from the project navigator into their respective @1x, @2x, @3x slots and make sure the **Image Set** name is labeled **Santa Cruz**.

![bordered width=60%](./images/create_new_asset_group.png)

Once the images are copied over into the Assets catalog, delete the Santa Cruz PNGs from the resources folder.

When finished, the Santa Cruz assets in the catalog should look like:

![bordered width=90%](./images/Santa_cruz_asset_catalog.png)

Debug builds are a great way to see how App Thinning works - because even before it existed, Xcode was tailoring debug builds to the target device. Build and run the application, again selecting the **iPad Air 2 Simulator**. Take a look at the size of **Asset.car** by looking at the Package Contents in the build directory as you did earlier.
![bordered width=90%](./images/ipad_air_2_asset_car_size.png)
This is using the @2x image for Santa Cruz, and ends up at 68 KB.

Now build and run with the **iPhone 6 Plus** simulator and take a look at the size of **Asset.car**:
![bordered width=90%](./images/iphone_6_plus_asset_car_size.png)
As you can see, it's up to 74 KB. The growth makes sense given the higher resolution of the @3x image used by the iPhone 6 Plus. While it may not directly reflect the size of the bundle on the store, this gives you a relative idea of how thinning works to size your bundle according to the needs of the target device.

>**Note:** Although PNGs are a good way to provide resources, you should also consider using vector-based PDFs. Xcode breaks down the PDF and resizes the image as needed, essentially future-proofing your app for whatever screen scales Apple will come up with next. All the other thumbnail images in Old CA Maps use vector-based PDFs.

## Lazily (Down)Loading Content

Now that you've migrated all the images into asset catalogs, essentially removing unused images, it's time to take a more aggressive approach at limiting content by using **On-Demand Resources**, or simply, **ODR**. 

The primary class responsible for dealing with ODR is called **NSBundleResourceRequest**. Using NSBundleResourceRequest, you can control the content to download with the use of **Tags**. Tags are string names you can attach to one or more resources to properly identify a group of content to download. Through tags, Apple abstracts the resource storage location and retrieval URL for your ODR content.

Wait, so what can you include when using On-Demand Resources? It can consist of images, data, OpenGL shaders, SpriteKit Particles, Watchkit Complications etc. The main thing to note is that ODR can't be executable code. 

Fortunately for this particular application, NSBundles fall into the data file category, allowing you to apply ODR to the bundles without changing any of the file infrastructure within Old CA Maps. 

Time to finally whip out some coding skrillz. Navigate to **MapChromeViewController.swift** and hunt down the **downloadAndDisplayMapOverlay()** function. It's here that you'll replace the synchronous loading of a local bundle into an asynchronous load for a remote bundle obtained through a `NSBundleResourceRequest`.

Change the **downloadAndDisplayMapOverlay()** function to now look like:
    
```swift 
  private func downloadAndDisplayMapOverlay() {
    guard let bundleTitle = self.mapOverlayData?.bundleTitle else { // 1
      return
    }
    
    let bundleResource = NSBundleResourceRequest(tags: [bundleTitle]) // 2 
    bundleResource.beginAccessingResourcesWithCompletionHandler {[weak self] (error) -> Void in // 3 
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in // 4
        if error == nil {
          self?.displayOverlayFromBundle(bundleResource.bundle) // 5
        }
      })
    }
  }
```

Breaking this down:
1. Using the new features in Swift 2.0, you're using the **guard** statement. This lets you maintain the "Golden Path" of code in an easier manner.
2. You're instantiating a `NSBundleResourceRequest` with the tag associated with your bundle. You will add tags to all the content bundles in one sec... 
3. The `beginAccessingResourcesWithCompletionHandler` method will call the completion block when your app finishes downloading your on-demand content or upon error.  
4. The completion handler is not called on the main thread, so you'll need to supply a block to the main queue to handle any updates to the UI. 
5. `NSBundleResourceRequest` has a read-only variable called **bundle**. Replacing `NSBundle.mainBundle()` with this variable makes the code more extensible if you were to move the file structure of your resources around.

Try building and running your application right now and click on one of the cities. Xcode will fail to load an overlay and spit out an error at you in the console. This is because you've told the `NSBundleResourceRequest` to look for Tags that don't exist yet... Time to fix that.

Navigate to the Project Navigator tab and expand the **Map Bundles** folder. Open the Xcode's **File Inspector** tab on the right. In the File Inspector column, find the **On Demand Resource Tags** section. 

Go through each bundle and give the tag the same name as the bundle name. For example, for **LA_Map.bundle** give it the Tag name **LA_Map**. Do this for each of the 5 bundles in the applciation.

![bordered width=80%](./images/Xcode_Asset_Tagging.png)

>**Note:** Make sure you spell the tag name in the exact same spelling and case. If you misstype it, you could come against some subtle errors.  

Build your application, but don't run it yet. Now would be a good time to look at the before and after of your IPA size. Originally, the app was over 300 MB, now Old CA Maps is around 10MB. Xcode has achieved this by removing the bundle resources found in the main bundle of the IPA and downloads them if they are not present on the app.

Now run your application. Select **Los Angeles** as the overlay and observe what happens. The app now waits until the content is downloaded then displays the overlay and adjusts the map when completed. 

>**Note:** When your app is live in the App Store, it will download these resources from there. However, to achieve the same affect while developing, Xcode makes a local network request from your device (or simulator) to your computer to download the ODR. This means that if you're testing your application and you turn your computer off, ODR will fail to work.

## Uuhh... This is Taking Too Long

You tried clicking on Los Angeles, but as you might have seen, the Los Angeles bundle asset is small in comparison to the Santa Cruz or San Diego bundles. 

Try clicking on the Santa Cruz overlay and see how long it takes to display the content.

That took a little bit too long to display, right?. Running this on a real device will only be worse. You need to indicate to the user that something is happening while you're downloading content. Fortunately, **MapChromeViewController** has a **IBOutlet property** called **loadingProgressView** which is a `UIProgressView`. You'll hook up the progress to this display to indicate to the user that a download is occurring while also displaying the network activity indicator.

Navigate back to **downloadAndDisplayMapOverlay()** and replace the content with the following:

```swift
  private func downloadAndDisplayMapOverlay() {
    guard let bundleTitle = self.mapOverlayData?.bundleTitle else {
      return
    }
    
    let bundleResource = NSBundleResourceRequest(tags: [bundleTitle])
    bundleResource.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent // 1


    self.loadingProgressView.observedProgress = bundleResource.progress // 2
    self.loadingProgressView.hidden = false // 3
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true

    bundleResource.beginAccessingResourcesWithCompletionHandler {[weak self] (error) -> Void in
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        self?.loadingProgressView.hidden = true // 4
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false

        if error == nil {
          self?.displayOverlayFromBundle(bundleResource.bundle)
        }
      })
    }
  }
```

1. This tells the system that the user is "patiently" waiting for this download to occur and to divert all resources to complete this download ASAP. 
2. The **loadingPorgressView** can hook into the `NSProgress` of the `NSBundleResourceRquest`. 
3. Display the loadingProgressView and also the network activity indicator to inform the user that a network request is occurring.
4. Once the download completes, hide the loadingProgressView and network activity indicator. It's important to note that with this code, you can run into the chance of a race condition with another download affecting the display of the network indicator, but that is not important to resolve for now. 

Build and run the application again. Try all the bundles again and observe the difference. 

It's getting better... but the ~130MB Santa Cruz download still seems to take too long. Time to try something a bit more drastic. 

## The Many Flavors of Tagging

[NOTE TO EDITOR: This section currently does not work. Am waiting on a reply here: https://forums.developer.apple.com/message/25090#25090. If I can't get this section to work, I'll put this stuff under the "Where to Go From Here"]

Displaying the progress is a marginally better experience, but it still feels like the large bundles take too long to load. Again, you're testing on a controlled device with the Simulator, image a real world user moving around in and out of Wifi/cell towers... 

So... the Santa Cruz asset is big and also is likely the first overlay the user will click since it's the first item displayed. You want the Santa Cruz asset to be included along with the application itself so it feels snappy, yet still be flexible enough to have the ability to remove this overlay if the user gets a low disk space notification. 

This means that this asset should be switched to the **Initial Install Tags** group where it will be counted along with it's IPA towards the total size and downloaded initially along with the app itself. 

Open up the **Old CA Maps Project**, click on the Old CA Maps in the **Target** section and then select **Resource Tags**. There are 3 types of cataloging for assets. 

- **Initial Install Tags:** These are installed along with your application. Wait why not just include them in the application? Well, you can remove this content when you no longer need it. This is perfect for onboarding content where you would use resources only once. 
- **Preferred Tag Order:** These tags are downloaded once the application finishes downloading. 
- **Download Only On Demand:** These resources are the ones you've worked with and are called when you call them through code. 

Move the Santa Cruz bundle with the SC_Map tag from the **Download Only on Demand** section to the **Initial Install Tag** section. To do this, select the Tag and drag it into the Initial Install Tag section. 

![bordered width=60%](./images/Initial_Install_Tags.png)

In addition, to having Santa Cruz load with the application, since San Diego is such a large file, it would be wise to move the San Diego overlay to the Preferred Tag Order group. Drag SD_Map over to the Preferred Tag Order section.

Clean, build, then run the application. Try clicking on Santa Cruz then San Diego. You will notice a marked increase in responsiveness. 

[NOTE TO EDITOR: END]

## Purging Content

Since the OS can purge ODR content at will provided that it's not in active use, it's important to be a good disk storage citizen with the ODR content in your application. You can help guide the system to determine what resources their device will throw out by indicating to the system when you are done using a resource.

Change your build scheme to build an **iPhone 6 Plus**, then build and run the application and tap on a city, then press the back arrow to jump back to the previous city selection screen. 

For these particular bundles, it's clear that you no longer need them as soon as you exit MapChromeViewController'view. But how do you know what the system is doing with your ODR content behind the scenes?

Fortunately, Apple has anticipated this problem on your behalf and Xcode 7 ships with a super useful debugging view to aid in understanding the status of your ODR content.

While your application is still running, open on the **Debug navigator** tab, then click on the **Disk** cell. Xcode will reveal the Disk report which includes valuable information regarding the current status of each tagged ODR.

![bordered width=80%](./images/ODR_Guages.png)

As you can see, clicking on an image then clicking back indicates to you that the ODR resource is still **In Use** while other resources are either **Not Downloaded** or **Downloaded**. Although UIKit and Foundation provide their own logic on when the device can reclaim these bundles, it's really ideal to indicate to the system when you are done using them.

You'll now indicate to the system that the NSBundleResourceRequest is available to be reclaimed by the system as soon as you leave the MapChromeViewController.

Open up **MapChromeViewController.swift** and add the following property to the beginning of the class: 

```swift
var overlayBundleResource: NSBundleResourceRequest?
```

Now, in the **downloadAndDisplayMapOverlayData()** function, add the following line underneath the NSBundleResourceRequest instantiation:

```swift
self.overlayBundleResource = bundleResource
```

Finally, add a new method for indicating to the system that you're done with the resource request when the view disappears:

```swift
override func viewDidDisappear(animated: Bool) {
  super.viewDidDisappear(animated)
  self.overlayBundleResource?.endAccessingResources()
}
```

Rebuild and run the system and keep an eye on the **Disk Report** screen while playing around with tapping on the different cities. The report will now indicate that your ODR content is no longer in active use as soon as you leave the map view screen. Sweet.

## Where to Go From Here? 

Congratulations, you've learned the in and outs of App Thinning! Remember that the same cellular limits apply for ODR resources so there are limits on the resource size you can download.

Two new cool methods added to **NSBundle** are: 
**setPreservationPriority(_priority: Double, forTags _: Set<String>)**  
and **preservationPriorityForTag(_ tag: String)**. Try to use these methods to increment the content of the tagged bundles every time you click on a city.

An additional challenge to to determine if the user is not on a WIFI network and prompt the user to be on a network before downloading any assets. 
