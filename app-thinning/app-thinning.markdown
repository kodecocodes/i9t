# Chapter _: App Thinning

Kicking yourself that you didn't drop the extra dinero to multiply your iOS device's disk storage size by a factor of 2? Well, don't be! Apple is now taking a more frugal approach to the apps stored on your device!

Back in the days of iOS 8, Apple began pushing developers to adopt a universal approach for building across devices. UISplitViewControllers, Trait Collections, and (a more respectable) Auto Layout led to a seamless experience for the iOS developer to build universal application for both iPhone & iPad.

However, packaging an universal app with device-specific content combined with an always increasing complexity of images, sounds, and video packaged into apps has its drawbacks. Apps are demanding more disk space, resulting in longer download times, more disk usage, and potentially consuming more memory.

Fortunately, in iOS 9, Apple has introduced several solutions to circumvent this problem:

- **App Slicing:** Compiling only the resources and executable architecture specific to the device the app is executing on. 
- **On Demand Resources:** Resources for an application that are downloaded as needed an can be removed if the iOS device needs to make room for other storage on disk.
- **Bitcode:** An intermmediate representation that is sent along with your app to the App Store. This allows Apple to re-optimize your app as future optimizations are made on their compiler and then applied to your code. Since this 100% on Apple's end (minus allowing Xcode to send Bitcode), this will not be discussed in depth in this chapter. 

Packaged together, these techniques are known as **App Thinning**.

## Getting Started

Before you get to have any fun, you'll need to eat your vegatables (also known as setup some debugging commands). 

Navigate to GettingStarted.txt, copy the command. Then open up **Terminal** and paste this big angry blob of text into the console and press enter:

```
echo -e "command alias dump_app_contents e -l objc++ -O -- [[NSFileManager defaultManager] contentsOfDirectoryAtPath:((id)[[NSBundle mainBundle] bundlePath]) error:nil]\ncommand alias dump_asset_names e -l objc++ -O --  [[[CUICatalog alloc] initWithName:@\"Assets\" fromBundle:[NSBundle mainBundle] error:nil] allImageNames]\ncommand regex assets_for_name 's/(.+)/e -l objc++ -O -- [[[CUICatalog alloc] initWithName:@\"Assets\" fromBundle:[NSBundle mainBundle] error:nil] imagesWithName: @\"%1\"]/'" >> ~/.lldbinit 
```

This will add 3 niffty commands pertaining to App Thinning to help aid in understanding what content is being placed into your application and help debug your content when things go awry. They do the following:

- **dump_app_contents:** This will list all the top level files found in your application bundle. This does not display files found in deeper levels. 
- **dump_asset_names:** This lists image resources names found in the **Assets.car** file. What's the Assets.car file? You'll learn about that in a second...
- **assets_for_name [name]** This will list all the resources found for a specific image name in the Assets.car file.

**Note:** The last to commands use Apple's private APIs, so make sure you not to include these classes in your app.   

Now you can check out the project! You'll work with an app named **Good ol' CA**, which displays historical aerial overlays over different parts of California on a map. This is a close to final project about to be sent to the App Store. Unfortunately, the resources for this app take up quite a bit of disk space. You'll use the App Thinning techniques to hack-and-slash the end product to a more managable size.

Open **GoodOldCA.proj**. Select the **iPad Air 2 Simulator** as the **scheme destination**, then build and run the application.

Play around with the app for a bit. Tap on **Santa Cruz** and other overlays and see how the historical maps overlay with the present day maps. 

[Image needed Santa Cruz -> Map]

>**Note:** These overlays are created from image tiles found in **NSBundle**s and passed into a **MKTileOverlayRenderer** for drawing. All of this is well beyond the scope of this tutorial on how it works. Think of this stuff as a black box--all you care about is how to make you app as small as possible to the end user. :] 

### App Slicing

<!-- For example, apps  

Enabling App Slicing is a super easy process provided that you follow Apple's rules. 

Build the GoodOldCA for the iPhone 6 Simulator. Navigate to the products folder in the **Project Navigator** and right-click **GoodOldCA.app**. Select **Show in Finder**. With Finder open, select **Debug-iphonesimulator** and then right click on the **GoodOldCA** IPA and select **Show Package Contents**  

### Executable Thinning

By default, Xcode will only include the active architecture and resources on **DEBUG** builds. This speeds up the build process as there is less content to copy over to the device/simulator. When switching over to a **RELEASE** build, all architectures will be packaged together (known as a fat binary) when you submit your app to the App Store. However, in iOS 9, Apple will now rip apart your App and separate the different packages specific to each device resulting in a smaller IPA. 

In order to properly enable App Slicing on the executable, all you have to do is... compile against iOS 9. See, wasn't that easy!? -->

<!-- ### Resource Thinning with Asset Catalogs -->

Slicing down resources is a good warmup for widdling away your apps "metaphorical pounds" known as Megabytes. Apple, by default 

something something ____ fat binary

Selectively grooming your app for assets takes a tiny bit more work than doing nothing (but not much!). All you have to do is make sure that your resources are compiled into Asset Catalogs. If they are not, then Xcode won't be able to figure out how to properly slice your resources for you. 

With GoodOldCA running, pause the application in navigate to the debugger. In LLDB:

```
dump_app_contents
```

This will spit out a list of the content that occupies the IPA bundle for **Good Ol' CA**. 

- Assets.car,
- Base.lproj,
- example_map.png,
- Frameworks,
- GoodOldCA,
- Info.plist,
- LA_Map.bundle,
- PkgInfo,
- Santa Cruz.png,
- Santa Cruz@2x.png,
- Santa Cruz@3x.png,
- SC_Map.bundle,
- SD_Map.bundle,
- SF_Map.bundle,
- SNVL_Map.bundle

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

Once the images are copied over into the Assets catalog, remove the Santa Cruz pngs from the resources folder.

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

Now that you have provided the infratstructure for Apple to slice your Asset Catalog resources, it's time to take a more aggressive approach at limiting content on the initial download. That is, you'll incorporate "lazily downloading", where you only get the resource when it's needed immediately or in the near future.

The primary class responsible for dealing with on-demand resources is called **NSBundleResourceRequest**. This class is responsible for fetching the resources that need to be downloaded from the App Store. 

Wait so what's a resource? A resource can be a number of things, an image, images, NSBundles, NSBundleResourcesRequests can load a number of things--it just can't be executable code (what about steganography?). 

Time to whip out the coding skrillz. Navigate to **MapChromeViewController.swift** and hunt down the **downloadAndDisplayMapOverlay** function. It is here that you will replace the content of an MKTileOverlay rendered on the device instead of online. 



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