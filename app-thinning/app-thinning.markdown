# Chapter _: App Thinning

Kicking yourself that you didn't drop the extra dinero to multiply your iOS device's disk storage size by a factor of 2? Well, don't be! Apple is now taking a more frugal approach to the apps stored on your device!

Back in the days of iOS 8, Apple began pushing developers to adopt a universal approach for building across devices. UISplitViewControllers, Trait Collections, and (a more respectable) Auto Layout led to a seamless experience for the iOS developer to build universal application for both iPhone & iPad.

However, packaging a universal app with device-specific content combined with an always increasing complexity of images, sounds, and video packaged into apps has its drawbacks. Apps are demanding more disk space, resulting in longer download times, more disk usage, and potentially consuming more memory.

Fortunately, in iOS 9, Apple has introduced several solutions to circumvent this problem:

- **App Slicing:** Compiling only the resources and executable architecture into variants specific to each device. 
- **On Demand Resources:** Resources for an application that are downloaded as needed an can be removed if the iOS device needs to make room for other storage on disk.
- **Bitcode:** An intermmediate representation that is sent along with your app to the App Store. This allows Apple to re-optimize your app as future optimizations are made to their compiler technology and applied to your intermediate code.
 
Packaged together, these techniques are known as **App Thinning**.

## Getting Started

Before you get to have any fun, you'll need to eat your vegatables (AKA setup some **LLDB debugging commands** :] ). 

Open the project called **Old CA Maps**. Navigate to **GettingStarted.txt**. Copy/paste the command into **Terminal** and press enter. 

```
echo -e "command alias dump_app_contents e -l objc++ -O -- [[NSFileManager defaultManager] contentsOfDirectoryAtPath:((id)[[NSBundle mainBundle] bundlePath]) error:nil]\ncommand alias dump_asset_names e -l objc++ -O --  [[[CUICatalog alloc] initWithName:@\"Assets\" fromBundle:[NSBundle mainBundle] error:nil] allImageNames]\ncommand regex assets_for_name 's/(.+)/e -l objc++ -O -- [[[CUICatalog alloc] initWithName:@\"Assets\" fromBundle:[NSBundle mainBundle] error:nil] imagesWithName: @\"%1\"]/'" >> ~/.lldbinit 
```

This angry blob of text will add 3 niffty commands pertaining to App Thinning to help aid in understanding what content is being placed into your application and help debug your content when things go awry. They do the following:

- **dump_app_contents:** This will list all the top level files found in your application bundle. This does not display files found in deeper levels. 
- **dump_asset_names:** This lists image resources names found in the **Assets.car** file. Wait, what's the Assets.car file? You'll learn about that in a second...
- **assets_for_name:** This will list all the resources found for a specific image name in the Assets.car file.

>**Note:** The last two commands use Apple's private APIs, so make sure you don't include these classes in your app.   

With the Terminal command entered, you can open and explore **Old CA Maps**. This application displays historical aerial overlays over different parts of California on a map. This is a close to final project about to be sent to the App Store. Unfortunately, the resources for this simple app take up a huge amount of disk space (over 300 Megabytes!). You'll use the App Thinning techniques to hack-and-slash the end product to a more managable size.

Select the **iPad Air 2 Simulator** as the **scheme destination**, then build and run the application.

Play around with the app for a bit. Tap on **Santa Cruz** and other overlays and see how the historical maps overlay with the present day maps. 

![ipad-landscape](./images/ipad_air_2_starter_landscape.png)

>**Note:** These overlays are created from image tiles found in **NSBundle**s and passed into a **MKTileOverlayRenderer** for drawing. All of this is well beyond the scope of this tutorial on how it works. Think of this stuff as a black box--all you care about is how to make you app as small as possible to the end user. :] 

### The Anatomy of Old CA Maps 

Need content here....  


### Measuring Your Work

It would be a good idea to quantitatively measure you progress when working with App Thinning. That is, how big is the IPA when before and after you touched this project. Fortunately, there is already a **Build Script** included in **Old CA Maps** that lists the size of the IPA in Kilobytes. 

To view the size of an app you built, first build the project, then navigate to the Report Navigator, and select the build you wish to inspect. Make sure the **All** and **All Messages** are selected and find the **Run Custom Shell Script** output.

![bordered width=90%](./images/app_size_viewing.png)

### App Slicing

App Slicing can be further broken down into two parts: executable slicing and resource slicing. 

Fortunately, there is not much you need to do to enable App Slicing for your executable. The build setting, **ONLY_ACTIVE_ARCH** is enabled by default for **DEBUG** builds, and is off for **RELEASE** builds. Even though you're sending up an executable that has multiple builds attached to it in a Release configuration, the Apple will automatically create the variants needed on your behalf. All you have to do is just compile for iOS 9. 

### Being Smart With Resources

Resource Slicing takes a tiny bit more work than doing absolutely nothing, but not by very much. 

All you have to do is make sure that your resources are compiled into Asset Catalogs. If they are not, then Xcode won't be able to figure out how to properly slice your resources for you. 

Let's try migrating image assets into an Asset Catalog.

With Old CA Maps running, pause the application open up the LLDB debugger console. In LLDB, type:

```
dump_app_contents
```

This will spit out a list of the content that occupies the IPA bundle for Old CA Maps. 

Notice that there are 3 images of different sizes by the name **Santa Cruz**. This means that the these sets of images are not being put into an Asset Catalog. Make sure this is the case by dumping all of the image names of the Asset Catalog in LLDB.

```
dump_asset_names
```

- Image,
- Los Angeles,
- San Diego,
- San Francisco,
- Sunnyvale

The fix for this is quite simple. Just stick the Santa Cruz PNG group into the Asset Catalog present in the project. 

Click the **Assets.xcassets**, then click on the plus button and select **New Image Set**. Drag over the Santa Cruz images from the project navigator into their respective @1x, @2x, @3x slots and make sure the **Image Set** name is labeled **Santa Cruz**.

Once the images are copied over into the Assets catalog, delete the "Santa Cruz" PNGs from the resources folder.

Build and run the application. Notice that the Santa Cruz image is still being displayed and if you use **dump_app_contents**, the Santa Cruz set of images will no longer be displayed. You can verify the Assets catalog has the name "Santa Cruz" by typing **dump_asset_names** in **LLDB**. Finally, you can see how many copies of the Santa Cruz image are currently in the app by typing in LLDB:

```
assets_for_name Santa Cruz
```

This will spit out an `NSArray` containing 1 image. 

>**Note:** Although PNGs are a good way to provide resources, you should also consider using vectorized PDFs. Xcode breaks down the PDF and resizes the image as needed, essentially future-proofing your app for whatever screen sizes Apple will dream up next. All the other thumbnail images use vectorized PDFs to achieve this in the sample project.

Build & Archive app, check out IPA size App Slicing [Theory, Instruction]
Explanation
ENABLE_ONLY_ACTIVE_RESOURCES to YES
Convert image group into Asset Catalogs
Build and run app on simulator. Check out visually different images being selectively loaded from the asset catalog
(If space permitting... unlikely) 

## On Demand Slicing Explanation [Theory]

Now that you have provided the infrastructure for Apple to slice your Asset Catalog resources, it's time to take a more aggressive approach at limiting content on the initial download. That is, you'll incorporate "lazily downloading", where you only get the resource when it's needed immediately or in the near future.

The primary class responsible for dealing with on-demand resources is called **NSBundleResourceRequest**. This class is responsible for fetching the resources that need to be downloaded from the App Store. 

Wait so what's an on-demand resource? It can consist of images, data, openGL shaders, SpriteKit Particles, Watchkit Complications etc. The main thing to note is that it just can't be executable code. You will use on-demand resources to load a data file using Bundles

Time to whip out the coding skrillz. Navigate to **MapChromeViewController.swift** and hunt down the **downloadAndDisplayMapOverlay** function. It is here that you will replace the content of an MKTileOverlay rendered on the device instead of online. 

Change the downloadAndDisplayMapOverlay function to now look like
    
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

Breaking this change apart:
- Using the new features in Swift 2.0, you are using the **guard** statement. This lets you maintain the "Golden Path" of code in an easier manner.
- You're instantiating a `NSBundleResourceRequest` with the tag associated with your bundle. You will add tags to all the content bundles in one sec... 
- The `beginAccessingResourcesWithCompletionHandler` method will call the completion block when your app finishs downloading your on-demand content or upon error.  
- The completion handler is not called on the main queue, so you'll need to supply a block to the main thread to handle any updates to the UI. 
- `NSBundleResourceRequest` has a read-only variable called bundle. Replacing `NSBundle.mainBundle()` with this varaible makes the code more extendible if you were to move the location of your bundles around. 

Try building and running your application right now and click on one of the cities. Xcode will fail to load an overlay and spit out an error at you in the console. This is because you have told the `NSBundleResourceRequest` to look for tags that don't exist yet. You'll change that now. 

Navigate to the Project Navigator tab and expand the **Map Bundles** folder. Open the Xcode's **File Inspector** tab on the right. In the File Inspector column find the **On Demand Resource Tags** section. 

Go through each bundle and give name the tag the same name as the bundle name. For example, for **LA_Map.bundle** give it the name **LA_Map** tag. Do this for each of the 5 bundles in the applciation.

>**Note:** Make sure you spell the tag name in the exact same spelling and case. If you misstype it, you could result in some subtle errors.  

The app now waits until the content is downloaded then displays the map when completed. 

Build and run the application with all the tags applied to the bundles in your project. Select **Los Angeles** as the overlay and watch what happens. 

Now try with a larger bundle. The Santa Cruz or the San Diego map is over 100MB respectively. Click on either one and see how long it takes to display the content.

That took a little bit too long. You should probably indicate to the user that something is happening. Fortunately, MapChromeViewController has a IBOutlet property called **loadingProgressView** which is a `UIProgressView`. You'll hook up the progress to this display to indicate to the user that a download is occuring. 

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

- This tells the system that the user is "patiently" waiting for this download to occur and to divert all resources to getting these download to complete ASAP. 
- The **loadingPorgressView** can hook into the `NSProgress` of the `NSBundleResourceRquest`. 
- Display the loadingProgressView and also the network activity indicator to indicator to the user a network request is occurring.
- Once the download completes, hiden the loadingProgressView and network activity indicator. With this code, you can run into the chance of a race condition with another download affect the display of the network indicator, but that is not important to resolve for now. 


Now would be a good time to look at the before and after of your IPA size. Originally, the app was over 300 MB! Now the app is around 10MB. Xcode has achieved this by removing the bundle resources found in the IPA and downloads them if they are not present on the app.


In order to mark a resource as downloadable for on-demand resources, you simply need to tag it. Xcode will take care of the hard work of attaching this resource to a separate directory and make it available to download from the App Store. 



Moving Content to the Cloud ("Lazy Downloading”) [Instruction] Tagging Assets
NSBundleResourceRequest
Move Topographic Map Assets to ODR Prioritizing ODR [Instruction]
Prioritize ODR Resources Managing ODR lifetimes Debugging w/ new Xcode Features


## ODR Best Practices [Theory]

When to call NSBundleResourceRequest
How to best group tagged asset bundles based upon situation
Final Project
Before/After size drop
(If space permitting) Terminal command `file` for ARCH
Where to Go From Here? Bitcode?
Build Machine ODR Testing? 