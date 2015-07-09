# Chapter _: App Thinning

Some text here because Deckle doesn't seem to work this correctly. blah blha blha blahblahblah


## Introduction

Recently, Apple has begun pushing developers to adopt a universal approach for building for both iPhone and iPad applications. Having a universal app that works across all iOS devices creates a more seamless experience for the user. However, as apps become more complex combined with this unification of ___ has a cost. Apps are now consuming a larger amount of disk space resulting in longer download times, more disk usage, and potentially more memory consumption.  

Apple has introduced several solutions to circumvent this problem: 
- **App Slicing** __hello
- **On Demand Resources** __hello 

Packaged together, these techniques are known as **App Thinning**.

## Getting Started

Download the <a href="">Sample Project</a>. This is a close to final (although simple) project about to be sent to the App Store. __Name__ displays historical map sattelite overlays of different parts of California. Unfortunately, the resources for this app take up a lot of space. You will use the App-Thinning techniques to hack and slash the end product to a more managable size.

Open __Sample_Project.proj__. Select the iPhone 6 Simulator as the **scheme destination**, then build and run the application. Take note of the iPhone specific title image in the navigation bar.  

Stop the application and change the scheme to be an iPad (any iPad type will do) and build and run the application. Take note of the iPad specific thumbnail images as well as the iPad specific navigation bar.

### App Slicing

**Note:**  It isn't best practice to have the same iPhone/iPad in images. However, for this particular example, having images which visually show the device will help aid in what is being displayed (and what is being ommitted).

By default, Xcode 7 will only include the active architecture and resources on DEBUG builds. This speeds up the build process as there are less resources to copy over to the device or simulator. When switching over to a RELEASE build, all architectures will be included when you submit your IPA to the App Store. However, in iOS 9, Apple will now rip apart your App and separate the different architectures and resources unique to each device.

This is all done for you be default in Xcode 7 on iOS 9 provided that you follow some simple guidelines.


Asset Catalogs

#### Transitioning PNGs into Asset Catalogs


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