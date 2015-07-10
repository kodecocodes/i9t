# Chapter _: App Thinning

Back in the days of iOS 8, Apple began pushing developers to adopt a universal approach for building both iPhone and iPad applications into one universal application resulting in a seamless experience for the user. 

However, apps have become more complex combined with supporting numerous arhcitectures with and numerous resources specific to each device . As a result, apps are now consuming a larger amount of disk space resulting in longer download times, more disk usage, and potentially consuming more memory. And why should users download everything if the majority of users will ?

Fortunately, in iOS 9, Apple has introduced several solutions to circumvent this problem: 
- **App Slicing**: Compiling only the resources and executable architecture specific to the device an app is running on. 
- **On Demand Resources**:   

Packaged together, these techniques are known as **App Thinning**.

## Getting Started

In this chapter, you'll work with __Name__, which displays historical sattelite overlays over different parts of California. This is a close to final project about to be sent to the App Store. Unfortunately, the resources for this app take up a lot of space. You will use the App-Thinning techniques to hack and slash the end product to a more managable size.

Open __Sample_Project.proj__. Select the `iPhone 6 Simulator` as the **scheme destination**, then build and run the application.

Play around with the app for a bit. Tap on `Santa Cruz` and other overlays and see how the historical maps overlay with the present maps. 

[Image needed Santa Cruz -> Map]

These overlays are created from image tiles found in `NSBundle`s and passed into a `MKTileOverlayRenderer` for drawing. All of this stuff is well beyond the scope of this tutorial on how to setup; think of this stuff as a black box. All you care about is how to make you app as small as possible to the end user. :] 

### App Slicing

By default, Xcode 7 will only include the active architecture and resources on `DEBUG` builds. This speeds up the build process as there is less content to copy over to the device or simulator. When switching over to a `RELEASE` build, all architectures will be packaged together (known as the fat binary that you are used to in the days of iOS 8 and earlier) when you submit your app to the App Store. However, in iOS 9, Apple will now rip apart your App and separate the different packages specific to each device. 

Enabling App Slicing is a super easy process provided that you follow Apple's rules. 

Build the __Name__ for the iPhone 6 Simulator. Navigate to the products folder in the `Project Navigator` and right-click __Name__.app. Select `Show in Finder`. With Finder open, select `Debug-iphonesimulator` and then right click on the __Name__ IPA and select `Show Package Contents`  

### Executable Thinning


### Resource Thinning with Asset Catalogs

Asset Catalogs


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