# Chapter _: App Thinning

Kicking yourself that you didn't drop the extra dinero to multiply your iOS device disk storage size by a factor of 2? Well, don't be! Apple is now taking a more frugal approach to the apps stored on your device!

Back in the days of iOS 8, Apple began pushing developers to adopt a universal approach for building across devices. UISplitViewControllers, Trait Collections, and (a more respectable) Auto Layout led to a seamless experience for the iOS developer to build universal application for both iPhone & iPad.

However, packaging an universal app with device-specific content combined with an always increasing complexity of images, sounds, and video packaged into apps has its drawbacks. Apps are demanding more disk space, resulting in longer download times, more disk usage, and potentially consuming more memory.

Fortunately, in iOS 9, Apple has introduced several solutions to circumvent this problem:

- **App Slicing:** Compiling only the resources and executable architecture specific to the device the app is executing on. 
- **On Demand Resources:** Resources for an application that are downloaded as needed an can be removed if the iOS device needs to make room for other storage on disk.
- **Bitcode:** An intermmediate representation that is sent along with your app to the App Store. This allows Apple to re-optimize your app as future optimizations are made on their compiler and then applied to your code. Since this 100% on Apple's end (minus allowing Xcode to send Bitcode), this will not be discussed in depth in this chapter. 

Packaged together, these techniques are known as **App Thinning**.

## Getting Started

You'll work with an app named **Good ol' CA**, which displays historical aerial overlays over different parts of California on a map. This is a close to final project about to be sent to the App Store. Unfortunately, the resources for this app take up quite a bit of disk space. You'll use the App Thinning techniques to hack-and-slash the end product to a more managable size.

Open **GoodOldCA.proj**. Select the **iPad Air 2 Simulator** as the **scheme destination**, then build and run the application.

Play around with the app for a bit. Tap on **Santa Cruz** and other overlays and see how the historical maps overlay with the present day maps. 

[Image needed Santa Cruz -> Map]

>**Note:** These overlays are created from image tiles found in **NSBundle**s and passed into a **MKTileOverlayRenderer** for drawing. All of this is well beyond the scope of this tutorial on how it works. Think of this stuff as a black box--all you care about is how to make you app as small as possible to the end user. :] 

Once you're done seeing how much development occurred in Sunnyvale since 1948, select **iOS Device** in the scheme destination and build the target. Navigate to Xcode's **Project Navigator**, open **Products**, then right click the **GoodOldCA** app and select **Show in Finder**. Navigate to the **Debug-iphoneos** directory and right click the **GoodOldCA** app and select **Show Package Contents**

This is pretty much what the end users will have on the phone in iOS 9. Take note of the 3 images, **Santa_Cruz.png**, **Santa_Cruz@2x.png**, and **Santa_Cruz@3x.png**. You'll be filtering those soon so only one will be displayed on the appropriate device... 

### App Slicing

For example, apps  

Enabling App Slicing is a super easy process provided that you follow Apple's rules. 

Build the GoodOldCA for the iPhone 6 Simulator. Navigate to the products folder in the **Project Navigator** and right-click **GoodOldCA.app**. Select **Show in Finder**. With Finder open, select **Debug-iphonesimulator** and then right click on the **GoodOldCA** IPA and select **Show Package Contents**  

### Executable Thinning

By default, Xcode will only include the active architecture and resources on **DEBUG** builds. This speeds up the build process as there is less content to copy over to the device/simulator. When switching over to a **RELEASE** build, all architectures will be packaged together (known as a fat binary) when you submit your app to the App Store. However, in iOS 9, Apple will now rip apart your App and separate the different packages specific to each device resulting in a smaller IPA. 

In order to properly enable App Slicing on the executable, all you have to do is... compile against iOS 9. See, wasn't that easy!?

### Resource Thinning with Asset Catalogs

Selectively grooming your app for assets takes a tiny bit more work than doing nothing (but not much!). 


Build & Archive app, check out IPA size App Slicing [Theory, Instruction]
Explanation
ENABLE_ONLY_ACTIVE_RESOURCES to YES
Convert image group into Asset Catalogs
Build and run app on simulator. Check out visually different images being selectively loaded from the asset catalog
(If space permitting... unlikely) 

```objectivec
[[[CUICatalog alloc] initWithName:@"Assets" fromBundle:[NSBundle mainBundle] error:nil] allImageNames]
```

## On Demand Slicing Explanation [Theory]

Now that you have provided the infratstructure for Apple to slice your predefined resources, it's time to take a more aggressive approach at limiting resources. That is, "lazily downloading", where you only get the resource when it will be needed (in the near future).

The primary class responsible for dealing with on-demand resources is called **NSBundleResourceRequest**. This class is responsible for fetching the resources that need to be downloaded from the App Store. 

In order to mark a resource as downloadable for on-demand resources, you simply need to tag it. Xcode will take care of the hard work packaging and sending the information to the App Store. 




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