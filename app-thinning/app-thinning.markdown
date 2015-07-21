# Chapter _: App Thinning

Kicking yourself that you didn't drop the extra dinero to multiply your iOS device's disk storage size by a factor of 2? Well, don't be! Apple is now taking a more frugal approach to how apps can be stored on your device!

Back in the days of iOS 8, Apple began pushing developers to adopt a universal approach for building across devices. UISplitViewControllers, Trait Collections, and (a more respectable) Auto Layout led to a seamless experience for the iOS developer to build universal application for both iPhone & iPad.

However, packaging a universal app with device-specific content combined with an always increasing complexity of images, sounds, and video packaged into apps has its drawbacks. Apps are demanding more disk space, resulting in longer download times, more disk usage, and potentially consuming more memory.

Fortunately, in iOS 9, Apple has introduced several solutions to circumvent this problem:

- **App Slicing:** When downloading an app from the App Store in iOS 9, Apple will compile resources and executable architecture into variants specific to each device. The device will only download the variant specific to its architecture, Size classes, screen scaling, etc. 
- **On Demand Resources:** Resources for an application that are downloaded as needed and can be removed if the iOS device needs to make room for other storage on disk.
- **Bitcode:** An intermediate representation that is sent along with your app when submitting to the App Store. This allows Apple to re-optimize your app as future optimizations are made on their end without you having to resubmit your app to the App Store. 
 
Packaged together, these techniques are known as **App Thinning**.

## Getting Started

Open the **Old CA Maps** project. This application displays historical aerial overlays over different parts of California on a map. This is a close to final project about to be sent to the App Store. Unfortunately, the resources for this simple app takes up a huge amount of disk space (over 300 Megabytes!). You'll use the App Thinning techniques to hack-and-slash the end product to a more manageable size. 

Select the **iPad Air 2 Simulator** as the **scheme destination**, then build and run the application.

Play around with the app for a bit. Tap on **Santa Cruz** and other overlays and see how the historical maps overlay with the present day maps. 

![ipad-landscape](./images/ipad_air_2_starter_landscape.png)

>**Note:** These overlays are created from image tiles found in **NSBundle**s and passed into a **MKTileOverlayRenderer** for drawing. All of this is well beyond the scope of this tutorial on how it works. Think of this stuff as a black box--all you care about is how to make you app as small as possible to the end user. :] 

### The Anatomy of an App 

When compiling your code into an iOS application, it's good to understand what Xcode is doing behind the scenes.

Below is a side-by-side comparison of the **Old CA Maps Xcode project**'s directory (on the left) and Old CA Map's archived bundle's contents, or **IPA** (on the right).

![bordered width=%60](./images/Directory_IPA_Comparison.png)

There's a couple important items to take note of:

- The assets catalog in Xcode named **Assets.xcassets** will turn into the **Assets.car** file in the IPA. This file's job is to hold resources specific to different scales, size classes, and devices. 
- Check out the sizes of each of the bundles. Notice the **SC_Map.bundle** is over 130 MB! 
- Notice that since the 3 **Santa Cruz PNGs** found in Xcode were not copied into the **Assets.car** file, but instead copied over in the top-level directory. You will fix this soon...

For example, this project contains 


### Measuring Your Work

It would be a good idea to quantitatively measure your progress when working with App Thinning. That is, how big is the IPA before and after you touched this project. Fortunately, there is already a **Build Script** included in **Old CA Maps** that lists the size of the IPA in Kilobytes. 

To view the size of an app you built, first build the project, then:
1. Navigate to the **Report Navigator**
2. Select the build you wish to inspect. 
3. Make sure the **All** and **All Messages** are selected
4. Find the **Run Custom Shell Script** output.

![bordered width=90%](./images/app_size_viewing.png)

You should occasionally come back to this view to see your progress of making your app smaller. Although this will not be the exact size of the IPA when you submit it to the App Store, this will give you a good idea of your progress with App Thinning.

## Slicing Up App Slicing

App Slicing can be further broken down into two parts: executable slicing and resource slicing. 

Fortunately, there is not much you need to do to enable App Slicing for your executable. The build setting, **ONLY_ACTIVE_ARCH** is enabled by default for **DEBUG** builds, and is off for **RELEASE** builds. Even though you're sending up an executable that has multiple builds attached to it in a Release configuration, Apple will automatically create the variants needed on your behalf. All you have to do is just compile for iOS 9. 

### Being Smart With Resources

Resource Slicing takes a tiny bit more work than doing absolutely nothing... but not by much. :]

All you have to do is make sure that your resources are compiled into **Asset Catalogs**. If they are not, then Xcode won't be able to figure out how to properly compile the resources only your device will use. 

As you noticed earlier, the **Santa Cruz** assets were not correctly compiled into the **Assets.xcassets** catalog within Xcode, resulting in unneeded images being copied over to the main bundle.

The fix for this is quite simple. Just stick the **Santa Cruz** PNGs into the Asset Catalog.

Click the **Assets.xcassets**, then click on the plus button and select **New Image Set**. Drag over the Santa Cruz images from the project navigator into their respective @1x, @2x, @3x slots and make sure the **Image Set** name is labeled **Santa Cruz**.

![bordered width=40%](./images/create_new_asset_group.png)

Once the images are copied over into the Assets catalog, delete the Santa Cruz PNGs from the resources folder.

Build and run the application. Since you can visually see the image in the app, you can verify the application correctly sees the new asset placement.

In addition, the Santa Cruz set of images will no longer be part of the top level content in the IPA. 

>**Note:** Although PNGs are a good way to provide resources, you should also consider using vector-based PDFs. Xcode breaks down the PDF and resizes the image as needed, essentially future-proofing your app for whatever screen sizes Apple will dream up next. All the other thumbnail images in Old CA Maps use vector-based PDFs.

## Lazily (Down)Loading Content

Now that you've provided the infrastructure for Apple to slice your Asset Catalog resources, it's time to take a more aggressive approach at limiting content by using **On-Demand Resources**, or simply, **ODR**. 

The primary class responsible for dealing with ODR is called **NSBundleResourceRequest**. This class handles fetching resources that need to be downloaded from the App Store through a feature known as **Tags**. Tags are string names you can attach to resources to properly identify a group of resources to download. 

Wait, so can a resource consist of for the On-Demand Resources? It can consist of images, data, OpenGL shaders, SpriteKit Particles, Watchkit Complications etc. The main thing to note is that ODR can't be executable code. 

Fortunately for this particular application, NSBundles fall into the data file category, allowing you to apply ODR to the bundles without changing any of the file infrastructure within Old CA Maps. 

Time to finally whip out some coding skrillz. Navigate to **MapChromeViewController.swift** and hunt down the **downloadAndDisplayMapOverlay()** function. It's here that you'll replace the synchronous loading of a local bundle into an asynchronous load for a remote bundle obtained through a `NSBundleResourceRequest`.

Change the **downloadAndDisplayMapOverlay** function to now look like:
    
```swift 
  private func downloadAndDisplayMapOverlay() {
    guard let bundleTitle = self.mapOverlayData?.bundleTitle else { // 1
      return
    }
    
    let bundleResource = NSBundleResourceRequest(tags: [bundleTitle]) // 2 
    bundleResource.beginAccessingResourcesWithCompletionHandler { (error) -> Void in // 3 
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in // 4
        if error == nil {
          self.displayOverlayFromBundle(bundleResource.bundle) // 5
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
5. `NSBundleResourceRequest` has a read-only variable called bundle. Replacing `NSBundle.mainBundle()` with this variable makes the code more extensible if you were to move the file structure of your resources around.

Try building and running your application right now and click on one of the cities. Xcode will fail to load an overlay and spit out an error at you in the console. This is because you've told the `NSBundleResourceRequest` to look for Tags that don't exist yet... Time to fix that.

Navigate to the Project Navigator tab and expand the **Map Bundles** folder. Open the Xcode's **File Inspector** tab on the right. In the File Inspector column, find the **On Demand Resource Tags** section. 

Go through each bundle and give the tag the same name as the bundle name. For example, for **LA_Map.bundle** give it the Tag name **LA_Map**. Do this for each of the 5 bundles in the applciation.

![bordered width=80%](./images/Xcode_Asset_Tagging.png)

>**Note:** Make sure you spell the tag name in the exact same spelling and case. If you misstype it, you could come against some subtle errors.  

Build your application, but don't run it yet. Now would be a good time to look at the before and after of your IPA size. Originally, the app was over 300 MB, now Old CA Maps is around 10MB. Xcode has achieved this by removing the bundle resources found in the main bundle of the IPA and downloads them if they are not present on the app.

Now run your application. Select **Los Angeles** as the overlay and observe what happens. The app now waits until the content is downloaded then displays the overlay and adjusts the map when completed. 

>**Note:** When your app is live in the App Store, it will download these resources from there. However, to achieve the same affect while developing, Xcode makes a local network request from your device (or simulator) to your computer to download the ODR. This means that if you're testing your application and you turn your computer off, ODR will fail to work.

## Uuhh... This is Taking Too Long


You tried clicking on Los Angeles, but as you might have seen, the Los Angeles bundle asset was small in comparison to the Santa Cruz or San Diego bundles. 

Try clicking on the Santa Cruz overlay and see how long it takes to display the content.

That took a little bit too long to display, right?. Running this on a real device will only be worse. You should probably indicate to the user that something is happening while you're downloading the ODR. Fortunately, **MapChromeViewController** has a **IBOutlet property** called **loadingProgressView** which is a `UIProgressView`. You'll hook up the progress to this display to indicate to the user that a download is occurring while also displaying the network activity indicator.

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

    bundleResource.beginAccessingResourcesWithCompletionHandler { (error) -> Void in
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        self.loadingProgressView.hidden = true // 4
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false

        if error == nil {
          self.displayOverlayFromBundle(bundleResource.bundle)
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

It's getting better... but the ~130MB download still seems to take too long. Time to try something a bit more drastic. 

## Prioritizing Resources 

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

## Prioritizing Storage 

The great thing about ODR resources is that if the user is low on space, the OS will actively look for resources to purge. You can help the system determine what resources their device will throw out by specifying a priority to the ODR content.

The OS will tell you via the **NSBundleResourceRequestLowDiskSpaceNotification** that it's looking into your app to see what resources can be purged. You should listen for this notification and see if there are any items you can let go of. 

Unfortunately, the simulator does not have an option to call this system notification for you. As a result, you will build a debug UIBarButtonItem and call the notification yourself.

Head back to **MapChromeViewController.swift** and at the bottom of **viewDidLoad**, insert this code: 

```swift
    let debugButton = UIBarButtonItem(title: "Bundle Debug", style: .Done, target: self, action: "debugActionTapped:")
    self.navigationItem.rightBarButtonItem = debugButton
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleDiskSpaceNotification:", name: NSBundleResourceRequestLowDiskSpaceNotification, object: nil)
```

This code will insert a `UIBarButtonItem` into your navigationBar which calls **debugActionTapped\(\_\:\)**. In addition, you are telling this view controller to call **handleDiskSpaceNotification\(\_\:\)** when the low disk space notification occurs. 

However, you added the targets, but you also need to add the methods.

Add these two functions in the IBActions section of MapChromeViewController.swift: 

```swift
  func debugActionTapped(sender: UIBarButtonItem) {
    NSNotificationCenter.defaultCenter().postNotificationName(NSBundleResourceRequestLowDiskSpaceNotification, object: nil)
  }
  
  func handleDiskSpaceNotification(notification: NSNotification) {
    let tags = HistoricMapOverlayData.generateAllBundleTitles()
    for tag in tags {
      let resource = NSBundleResourceRequest(tags: [tag])
      resource.conditionallyBeginAccessingResourcesWithCompletionHandler({ (hasResource) -> Void in
        resource.endAccessingResources()
      })
    }
  }
```

Now once you tap on the debug button, your ODR content will be freed up! 


## Where to Go From Here? 

Congratulations, you've learned the in and outs of App Thinning! Remember that the same cellular limits apply for ODR resources so you can't download > 100MB without being on a WIFI network. 

As a challenge try to determine if the user is not on a WIFI network and prompt the user to be on a network before downloading any assets. 
