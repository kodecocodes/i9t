# Chapter _: App Thinning

Kicking yourself that you didn't drop the extra dinero to multiply your iOS device disk storage size by a factor of 2? Well don't be! Apple is now taking a more frugal approach to the apps stored on your device!

Back in the days of iOS 8, Apple began pushing developers to adopt a universal approach for building across devices. UISplitViewControllers, Trait Collections, and (a more respectable) Auto Layout led to a seamless experience for the iOS developer to build universal application for both iPhone & iPad.

However, packaging an universal app with device-specific content combined with an always increasing complexity to apps has its drawbacks. Apps are demanding more disk space, resulting in longer download times, more disk usage, and potentially consuming more memory.

Fortunately, in iOS 9, Apple has introduced several solutions to circumvent this problem: 
- **App Slicing**: Compiling only the resources and executable architecture specific to the device the app is executing on. 
- **On Demand Resources**: Resources for an application that are downloaded as needed an can be removed if the iOS device needs to make room for other storage on disk.

Packaged together, these techniques are known as **App Thinning**.

## Getting Started

You'll work with an app named **Good ol' CA**, which displays historical aerial overlays over different parts of California. This is a close to final project about to be sent to the App Store. Unfortunately, the resources for this app take up quite a bit of space. You'll use the App Thinning techniques to hack-and-slash the end product to a more managable size.

Open **GoodOldCA.proj**. Select the **iPad Air 2 Simulator** as the **scheme destination**, then build and run the application.

Play around with the app for a bit. Tap on **Santa Cruz** and other overlays and see how the historical maps overlay with the present day maps. 

[Image needed Santa Cruz -> Map]

>**Note:** These overlays are created from image tiles found in **NSBundle**s and passed into a **MKTileOverlayRenderer** for drawing. All of this is well beyond the scope of this tutorial on how it works. Think of this stuff as a black box--all you care about is how to make you app as small as possible to the end user. :] 

Once you are done seeing how much development occurred in Sunnyvale since 1948 (hometown of Apple's HQ), navigate to Xcode's **Project Navigator**, open **Products**, then 

### App Slicing

For example, apps  

Enabling App Slicing is a super easy process provided that you follow Apple's rules. 

Build the __Name__ for the iPhone 6 Simulator. Navigate to the products folder in the `Project Navigator` and right-click __Name__.app. Select `Show in Finder`. With Finder open, select `Debug-iphonesimulator` and then right click on the __Name__ IPA and select `Show Package Contents`  

### Executable Thinning

By default, Xcode will only include the active architecture and resources on `DEBUG` builds. This speeds up the build process as there is less content to copy over to the device/simulator. When switching over to a `RELEASE` build, all architectures will be packaged together (known as a fat binary) when you submit your app to the App Store. However, in iOS 9, Apple will now rip apart your App and separate the different packages specific to each device resulting in a smaller IPA. 

In order to properly enable App Slicing on the executable, all you have to do is... compile against iOS 9. See, wasn't that easy!?




### Resource Thinning with Asset Catalogs

Selectively grooming your app for assets takes a tiny bit more work (but not much!). 


Build & Archive app, check out IPA size App Slicing [Theory, Instruction]
Explanation
ENABLE_ONLY_ACTIVE_RESOURCES to YES
Convert image group into Asset Catalogs
Build and run app on simulator. Check out visually different images being selectively loaded from the asset catalog
(If space permitting... unlikely) [[[CUICatalog alloc] initWithName:@"Assets" fromBundle:[NSBundle mainBundle] error:nil] allImageNames]

## On Demand Slicing Explanation [Theory]

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