```metadata
author: "By Soheil Azarpour"
number: "5"
title: "Chapter 5: Multitasking"
```

# Chapter 5: Multitasking

iOS 9 introduces a phenomenal feature for the iPad — **multitasking**. For the first time, iPad users can run two apps on the screen at the same time. Maybe you want to read a proposal in your email app while you research the topic in Safari. Or you'd like to keep an eye on Twitter while you enjoy your favorite sports show. For a device that you can hold in one hand, this is a crazy amount of productivity power. It's undoubtedly going to change the way users interact with their iPads.

In this chapter, you'll learn how to update an existing app so that it plays nicely in a multi-tasking iPad environment.

## Getting started

The starter project you’ll use for this chapter is named **Travelog**. Open the project file in Xcode and build and run the application on the **iPad Air 2** simulator. You’ll see the following:

![width=85%](images/mt05.png)

Travelog is a journaling app. The app uses `UISplitViewController` to display entries on the left side. Tap any entry to display it in the right-hand view; rotate the device and you'll find both master and detail views of the Split View Controller are visible in both orientations.

It's time to see how the app behaves in a multitasking environment. Swipe from the right edge of the screen to expose the list of multitasking-ready apps on your iPad. This can be tricky in the simulator; try starting with your mouse pointer just inside the simulator window to simulate a swipe in from the edge.

> **Note**:  If the locale of the iPad is set to a region with right-to-left language, swipe from the left edge of the screen to activate multitasking.

Tap on any app to launch it. A small version of the app opens in the previous position of the list. At this point you're in **Slide Over** multitasking mode. Note that Travelog is dimmed out but otherwise unaffected. The app running in Slide Over mode sits on top of Travelog, and a short handle bar sits at top of the Slide Over. Swipe down on the handle to expose the list of multitasking apps and launch a different app in the Slide Over.

You'll notice a handle at the edge of the Slide Over view. Tap it, and you'll see the following:

![width=90%](images/mt06.png)

W00t! The screen just divided in two! Isn't that neat?! This is **Split View** multitasking mode. Travelog is now available for use and resized itself to fit the new, narrower portion of the window.

> **Note**: If an app isn't multitasking ready, it won't appear in the list. Even more reason to get your app ready for multitasking as soon as possible! :]

The **primary app** is the original running app, while the **secondary app** is the newly opened app. If you drag the divider further out, the screen will split 50:50 between the apps. Drag it all the way to the other side and you're back to single app mode. The primary app is backgrounded at this point.

The final type of multitasking, **Picture in Picture**, or **PIP**, works much like the picture-in-picture function on televisions. You can shrink the PIP window of a FaceTime call to one corner of the iPad and continue using other apps while you chat. PIP is only really applicable to apps that play video; therefore it won't be covered in this chapter.

> **Note:** At the time of writing, Split View is **only** available on the iPad Air 2. Picture in Picture and Slide Over is available on iPad Air, iPad Air 2, iPad Mini 2, and iPad Mini 3.

## Preparing your app for multitasking

Here's the good news: if you paid attention at WWDC 2014 and built a universal app with size classes, adaptive layout and a launch storyboard or XIB, you're done! Rebuild your app with the iOS 9 SDK, go grab yourself a beverage and I'll see you in the next chapter!

What's that? You live in the real world and don't _quite_ have all the above implemented in your app? Okay then; this chapter is here to walk you through what it takes to make your app multitasking-ready.

Any new project created in Xcode 7 is automatically multitasking-ready. An existing app you convert to Xcode 7 automatically becomes multitasking-ready if your app:

* Is a universal app
* Is compiled with SDK 9.x
* Supports all orientations
* Uses a launch storyboard

Since all the required criteria are in place, Travelog automatically becomes multitasking ready. That's great news, but just because it's multitasking ready doesn't mean that everything will work as expected. The remainder of this chapter will help you work through common pitfalls encountered when converting existing apps to multitasking apps.

## Orientation and size changes

Run Travelog in Split View mode and rotate the iPad to portrait orientation; you'll see the app layout as shown below:

![bordered ipad](images/mt061.png)

While this layout is functional, it can certainly stand to be improved. There's whitespace wasted on the left hand side and all the labels are squashed over to the right hand side.

Rotate the device to landscape orientation; you'll see the following:

![bordered width=70%](images/mt062.png)

Again, it's functional, but the master view column is too narrow and the text inside the table view cells doesn't really provide any value.

The app already performs some layout updates on orientation change; that seems like the best place to start.

Open **SplitViewController.swift**; this is a subclass of `UISplitViewController` and overrides `viewDidLayoutSubviews()` so it can update the maximum width of primary column via helper method `updateMaximumPrimaryColumnWidth()`. The implementation of `updateMaximumPrimaryColumnWidth()` checks the status bar orientation to determine what the maximum width should be. This approach won't work any longer, since the app can still have a narrow window in split view mode when it's in landscape orientation.

UIKit provides a number of anchor points where you can hook in and update your layout:

1. **willTransitionToTraitCollection(_:, withTransitionCoordinator:)**
2. **viewWillTransitionToSize(_:, withTransitionCoordinator:)**
3. **traitCollectionDidChange(_:):**

The diagram below shows how the horizontal size classes of your app change during multitasking events (**R** means **Regular** and **C** means **Compact**):

![width=100%](images/sizeclasses.png)

Not all multitasking or orientation changes trigger a size class change, so you can't simply rely on size class changes to provide the best user experience.

It looks like `viewWillTransitionToSize(_:, withTransitionCoordinator:)` is a good candidate for an update. Remove `viewDidLayoutSubviews()` and `updateMaximumPrimaryColumnWidth()` from **SplitViewController.swift** and add the following:

```swift
func updateMaximumPrimaryColumnWidthBasedOnSize(size: CGSize) {
  if size.width < UIScreen.mainScreen().bounds.width
    || size.width < size.height {
    
    maximumPrimaryColumnWidth = 170.0
  } else {
    maximumPrimaryColumnWidth =
      UISplitViewControllerAutomaticDimension
  }
}
```

This helper method updates the split view's maximum primary column width; it returns the smaller version when the split view is narrower than the screen, such as in a multitasking situation, or when the split view itself has a portrait orientation.

You'll need to call this helper method when the view is first loaded, so add the following:

```swift
override func viewDidLoad() {
  super.viewDidLoad()
  updateMaximumPrimaryColumnWidthBasedOnSize(view.bounds.size)
}
```

This ensures that the split view starts in the right configuration.

Add one final method:

```swift
override func viewWillTransitionToSize(size: CGSize,
  withTransitionCoordinator coordinator:
  UIViewControllerTransitionCoordinator) {

  super.viewWillTransitionToSize(size,
    withTransitionCoordinator: coordinator)
  updateMaximumPrimaryColumnWidthBasedOnSize(size)
}
```

This method updates the primary column when the size changes.

Build and run your app; first verify for all orientations that the app still looks and behaves as it did before multitasking. Then bring in another app in Split View and try some different orientations:

![width=95%](images/mt063.png)

Hmm — it's certainly not fixed. It even looks more broken now: with multitasking enabled in landscape orientation, the master column view has been jacked up! It looks like the table view cell doesn't adapt to size changes appropriately.

 Open **LogCell.swift** and find the implementation of `layoutSubviews()`; you'll see the code checks for `UIScreen.mainScreen().bounds.width` to determine whether it should use the compact view or regular view.

`UIScreen` always represents the _entire_ screen, regardless of the multitasking state. However, you can't rely on screen sizes alone anymore. Update the implementation of `layoutSubviews()` as follows:

```swift
override func layoutSubviews() {
  super.layoutSubviews()
  let isTooNarrow = bounds.width <= LogCell.widthThreshold
  // some code ...
}
```

Also update `widthThreshold`, declared at the beginning of `LogCell`, as follows:

```swift
static let widthThreshold: CGFloat = 180.0
```

The updated code checks the width of the cell itself instead of the width of the screen. This decouples the view's behavior from that of its superview. Adaptivity is now self-contained! :]

Build and run; again, verify the app still looks and behaves as it did before multitasking. This time around, Split View mode should play nicely in all orientations:

![width=95%](images/mt09.png)

> **Note:** Unlike `UIScreen`, `UIWindow.bounds` always corresponds to the actual size of your app and its origin is always `(0, 0)`. In iOS 9 you can create a new instance of `UIWindow` _without_ passing a frame via `let window = UIWindow()`. The system will automatically give it a frame that matches your application's frame.

## Adaptive presentation

Continue your evaluation of the app: this time with the device in landscape orientation and the Split View at 33%, tap the **Photo Library** bar button. You'll see the following popover:

![bordered ipad](images/mt091.png)

With the popover still visible, drag the divider further to the left so the screen is evenly divided between the two apps:

![bordered ipad](images/mt092.png)

The popover automatically turned into a modal view without any action on your part; dragging the divider to 50% changes the horizontal size class of the app from regular to compact. That's neat, but it's not quite the functionality you're looking for.

Instead, you only want to present the Photo Library in a modal fashion when the app is in Slide Over mode, or when it's the secondary (smaller) app in the 33% Split View mode. When your app is full screen or has 50% width, you'd prefer to present the Photo Library in a popover.

iOS 8 introduced `UIPopoverPresentationController` to manage the display of the content in a popover; you use it along with the `UIModalPresentationPopover` presentation style to present popovers. However, you can intercept the presentation and customize it with `UIPopoverPresentationControllerDelegate` callbacks.

Open **LogsViewController.swift** and add the following class extension to the end of the file:

```swift
extension LogsViewController:
  UIPopoverPresentationControllerDelegate {

  func adaptivePresentationStyleForPresentationController(
    controller: UIPresentationController,
    traitCollection: UITraitCollection)
    -> UIModalPresentationStyle {

    //1
    guard traitCollection.userInterfaceIdiom == .Pad else {
      return .FullScreen
    }

    if splitViewController?.view.bounds.width > 320 {
      return .None
    } else {
      return .FullScreen
    }
  }
}
```

Here's a breakdown of the code:

1. Check that the app is running on an iPad; the photo picker should always be presented modally on the iPhone.
2. Check that the split view controller is larger than 320 points — the size of the Slide Over / 33% view. If so, return `.None` to retain the popover, otherwise return `.FullScreen` for a modal presentation instead.

Now you can make `LogsViewController` a delegate of the popover presentation controller.

Find the implementation of `presentImagePickerControllerWithSourceType(_:)`. Read through the implementation and you'll see that when the source type is `.PhotoLibrary`, `UIImagePickerController` presents as a popover. Update the implementation by adding `presenter?.delegate = self` as shown below:

```swift
func presentImagePickerControllerWithSourceType(sourceType:
  UIImagePickerControllerSourceType) {
  // some code...
  if sourceType ==
    UIImagePickerControllerSourceType.PhotoLibrary {
    // some code...
    presenter?.delegate = self
  }
  // some code...
}
```

Build and run your app; verify that the popover transitions to a modal fullscreen view only when your app is in the Slide Over mode or when the Split View pane is sufficiently narrow.

![width=95%](images/mt093.png)

### The path to adaptivity

If you're not already using Auto Layout, Size Classes or other excellent responsive layout tools in UIKit, you should definitely consider upgrading your code to do so. UIKit has some new functionality to further assist you with multitasking, including `UIStackView`,  `UIView.readableContentGuide` and `UITableView.cellLayoutMarginsFollowReadableWidth`. Want more information on this functionality? Chapter 7, "UIStackView & Auto Layout Changes" has you covered.

## Other considerations

Beyond what's been covered in this chapter, there are a few other things to look out for when multitasking. You should already have incorporated most of these suggestions into your existing apps, but the sections below highlight a few extra considerations to be made in the new paradigm of multitasking apps.

### Keyboard

Dealing with keyboard presentation has always been an "interesting" topic in iOS. :] You've probably had to adjust the layout of your view so critical elements weren't covered when the keyboard appeared, or perhaps you had to shuffle things around to give the keyboard enough room. In the multitasking world, you need to anticipate that the keyboard can appear at any time — and over any view controller.

Apps running next to yours may present the keyboard, which means you'll have to adjust the layout of your app in a way that a user can still effectively work with it — or you'll risk getting one-star reviews in the App Store! Judicious use of scroll views and/or table view controllers that automatically adjust for the keyboard will help you out here.

### Designs

Above and beyond coding considerations, you'll need to change your approach to app visual design a little differently:

- **Be flexible:** Step away from a pixel-perfect design for various platforms and orientations. You need to think about different sizes and how you can have a flexible app that responds appropriately to size changes.
- **Use Auto Layout:** Remove hardcoded sizes or custom code that resizes elements. It's time to consider Auto Layout and make your code more flexible and future-proof.
- **Use size classes:** One single layout won't always fit all displays. Use size classes to build a base layout and then customize each specific size class based on individual needs. But don’t treat each size class as a completely separate design; as you saw in this chapter, your app should easily transition from one size class to another, and you don't want to surprise your user with a dramatic change as they drag the divider.

### Resources

You've worked hard to be a good memory citizen over the years, and that won't change with multitasking. You can potentially have up to three apps running at full speed, all at the same time: the primary app, the secondary app and Picture in Picture. Instruments is an invaluable tool for monitoring memory usage in your app and can help you whittle your memory usage back to the bare minimum.

## Where to go from here?

This chapter only touched on the basics of multitasking — it's up to developers like you to help chart the course for accepted multitasking design patterns of the future. To help you along the journey to multitasking, here are some resources you can bookmark for future reference:

* Adopting Multitasking Enhancements on iPad– [apple.co/1MdssbK](https://developer.apple.com/library/prerelease/ios/documentation/WindowsViews/Conceptual/AdoptingMultitaskingOniPad/index.html)
* Getting Started with Multitasking on iPad in iOS 9 (Session 205) – [apple.co/1ItxCtH](https://developer.apple.com/videos/wwdc/2015/?id=205)
* Multitasking Essentials for Media-Based Apps on iPad in iOS 9 (session 211) – [apple.co/1hm8v5s](https://developer.apple.com/videos/wwdc/2015/?id=211)
* Optimizing Your App for Multitasking on iPad in iOS 9 (Session 212) – [apple.co/1T8CCcp](https://developer.apple.com/videos/wwdc/2015/?id=212)
