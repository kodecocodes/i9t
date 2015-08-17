# Multitasking

By Soheil Azarpour

iOS 9 introduces a phenomenal feature for the iPad — **multitasking**. For the first time ever on the iPad, users can run two apps on screen at the same time. You can read a proposal in your email client while you research the topic in Safari, open on the same screen. Or you can keep an eye on Twitter while you enjoy your favorite sports show at the same time on the same screen. This is an insane productivity boost for a small device you can hold in your hands and is likely to change the way users interact with their iPads.

In this chapter, you'll learn how to update an existing app so that it plays nicely in a multi-tasked iPad environment.

## Getting started

The starter project you’ll use for the remainder of this chapter is named **Travelog**. Open the project file in Xcode and build and run the application on the **iPad Air 2** simulator. You’ll see the following:

![width=90% ipad](images/mt05.png)

Travelog is a journaling app. The app uses `UISplitViewController` to display entries on the left side. Tap and entry to display it in the right-hand view; rotate the device and you'll find both master and detail views of the Split View Controller are visible in both orientations. However, the master view is narrower in portrait orientation to give the content more room in the detail view.

It's time to see how the app behaves in a multitasking environment. Swipe from the right edge of the screen to expose the list of multitasking-ready apps on your iPad. This can be tricky in the simulator; try starting with your mouse pointer just inside the simulator window to simulate a swipe in from the edge.

> **Note**:  If the locale of the iPad is set to a region with right-to-left language, swipe from the right edge of the screen to activate multitasking.

Tap on any app to launch it. A small version of the app opens in the previous position of the list. At this point you're in **Slide Over** multitasking mode. Note that Travelog is dimmed out but otherwise unaffected. The app running in slide over mode sits on top of Travelog, and a short handle bar sits at top of the slide over. Swipe down on the handle to expose the list of multitasking apps and launch a different app in the Slide Over.

You'll notice a handle at the edge of the slide over view. Tap it, and you'll see the following:

![width=90% ipad](images/mt06.png)

W00t! The screen just divided in two! Isn't that neat?! This is **Split View** multitasking mode. Travelog is now available for use and resized itself to fit the new, narrower portion of the window.

> **Note**: If an app isn't multitasking ready, it won't appear in the list. Even more reason to get your app ready for multitasking as soon as possible! :]

The **primary app** is the original running app, while the **secondary app** is the newly opened app. If you drag the divider further out, the screen will split 50:50 between the apps. Drag it all the way to the other side and you're back to single app mode. The primary app is backgrounded at this point.

The final type of multitasking, **Picture in Picture**, or **PIP**, works much like the picture-in-picture function on televisions. You can shrink the PIP window of a FaceTime call to one corner of the iPad and continue using other apps while you chat. PIP is only really applicable to video playing apps; therefore it won't be covered in this chapter.

> **Note:** At the time of writing, Split View is **only** available on the iPad Air 2. Picture in Picture and Slide Over is available on iPad Air, iPad Air 2, iPad Mini 2, and iPad Mini 3.

## Preparing your app for multitasking

Here's the good news: if you paid attention at WWDC 2014 and built a universal app with size classes, adaptive layout and a launch storyboard or XIB, you're done! Rebuild your app with the iOS 9 SDK, go grab yourself a beverage and I'll see you in the next chapter!

What's that? You live in the real world and don't _quite_ have all the above implemented in your app? Okay then; I can walk you through what it takes to make your app multitasking-ready.

Any new project created in Xcode 7 is automatically multitasking-ready. An existing app you convert to Xcode 7 automatically becomes multitasking-ready if your app:

* is a universal app
* is compiled with SDK 9.x
* supports all orientations
* uses launch storyboard

Since all the required criteria are in place, Travelog automatically becomes multitasking ready. That's great news, but just because it's multitasking ready doesn't mean that everything will work as expected. The remainder of this chapter will help you work through common pitfalls encountered when converting existing apps to multitasking apps.

## Orientation and size changes

Run Travelog in Split View mode and rotate the iPad to portrait orientation; you'll see the app layout as shown below:

![bordered ipad](images/mt061.png)

While this layout is functional, it can certainly stand to be improved. There's whitespace wasted on the left hand side and all the labels are squashed over to the right hand side.

Rotate the device to landscape orientation; you'll see the following:

![bordered ipad](images/mt062.png)

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

It looks like `viewWillTransitionToSize(_:, withTransitionCoordinator:)` is a good candidate for an update.Remove `viewDidLayoutSubviews()` and `updateMaximumPrimaryColumnWidth()` from **SplitViewController.swift** and add the following:

```swift
func updateMaximumPrimaryColumnWidthBasedOnSize(size: CGSize) {
  if size.width < UIScreen.mainScreen().bounds.width || size.width < size.height {
    maximumPrimaryColumnWidth = 160.0
  } else {
    maximumPrimaryColumnWidth = UISplitViewControllerAutomaticDimension
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
override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
  super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
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
static let widthThreshold: CGFloat = 160.0
```

The updated code checks the width of the cell itself instead of the width of the screen. This decouples the view's behavior from its superviews. Adaptivity is now self-contained! :]

Build and run; again, verify the app still looks and behaves as it did before multitasking. This time around, Split View mode should play nicely in all orientations:

![width=95%](images/mt09.png)

> **Note:** Unlike `UIScreen`, `UIWindow.bounds` always corresponds to the actual size of your app and its origin is always `(0, 0)`. In iOS 9 you can create a new instance of `UIWindow` _without_ passing a frame via `let window = UIWindow()`. The system will automatically give it a frame that matches your application's frame.

## Adaptive presentation

Continue your evaluation of the app: this time with the device in landscape orientation and the Split View at 33%, tap the **Photo Library** bar button. You'll see the following popover:***

![bordered ipad](images/mt091.png)

With popover still visible, drag the divider further to the left so that the screen is divided in half between the two apps.

![bordered ipad](images/mt092.png)

You notice that the popover automatically turns into a modal view. When you drag the divider to 50%, the horizontal size class of the app changes from regular to compact. In this situation the default behavior of UIKit is to present a popover as a modal view, but this is not exactly what you want.

You want to present Photo Library modally only if the app is in slide over mode or it is the secondary app in 33% Split View, similar to an iPhone screen size. You get to this size if your app is opened in the Slide Over. But at 50%, you'd still rather present the Photo Library in a popover.

In iOS 8 Apple introduced `UIPopoverPresentationController` to manage the display of content in a popover. You use `UIPopoverPresentationController` along with `UIModalPresentationPopover` presentation style to present popovers. You can intercept the presentation and customize by using `UIPopoverPresentationControllerDelegate` callbacks.

Open **LogsViewController.swift** and add a class extension at the end of the file:

```swift
extension LogsViewController : UIPopoverPresentationControllerDelegate {

  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
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

1. Ensure that this is an iPad (the photo picker should always be presented modally on the iPhone)
2. Check that the split view controller is larger than 320 points (the size of the slide over / 33% view). If it is, you can return `.None` to keep the popover, otherwise return `.FullScreen` to do a modal presentation instead.

Now that `LogsViewController` can be a delegate of the popover presentation controller, you can make it so. Find the implementation of `presentImagePickerControllerWithSourceType(_:)`. You see that if the source type is `.PhotoLibrary`, the `UIImagePickerController` instance is presented as a popover. Update its implementation by adding `presenter?.delegate = self` as shown below:

```swift
func presentImagePickerControllerWithSourceType(sourceType: UIImagePickerControllerSourceType) {
  // some code...
  if sourceType == UIImagePickerControllerSourceType.PhotoLibrary {
    // some code...
    presenter?.delegate = self
  }
  // some code...
}
```

Build and run. Verify that the only time you see the popover turning into a modal fullscreen view is when your app is in the Slide Over or in the portrait orientation with multitasking enabled.

![width=95%](images/mt093.png)

There are some great tools in UIKit to prepare you for multitasking and adaptivity. Auto Layout, Size Classes are couple of them. If you are not using them already, it's time to update your code. In addition to those, there are  some new tools in UIKit to further assist you with multitasking; `UIStackView`,  `UIView.readableContentGuide` and `UITableView.cellLayoutMarginsFollowReadableWidth` are just a few of them. You can learn more about **UIStackView and Auto Layout Changes** in chapter XX of this book.

## Other considerations

There are other things to look out for when multitasking. Many of these are things you already know or should be doing, but have to consider more carefully now. Here are a few:

### Keyboard

Dealing with keyboard presentation has always been an "interesting" topic in iOS. You probably have the experience of adjusting your view layout when the keyboard is presented to give user some room or move some UI elements to keep them visible.

In a multitasking environment you have new requirement: the keyboard could appear at any time, over any view controller!

Other apps running next to your app may present the keyboard and you need to adjust your layout so that the user can continue to use your app - or they may leave you bad reviews in the App Store! :]

Judicious use of scroll views and / or table view controllers (which automatically adjust for the keyboard!) will help you here.

### Designs

- **Be flexible:** Step away from a pixel-perfect design for various platforms and orientations. You need to think about different sizes and how you can have a flexible app that responds to size changes appropriately.
- **Use Auto Layout:** Remove hardcoded sizes or code that manually changes size of elements. It's time to consider Auto Layout and make your code more flexible and easier to maintain.
- **Use Size classes:** One single layout doesn't always fit all displays. Use size classes to build a base layout and then customize each specific size class based on the individual needs of that size class. Don’t treat each of the size classes as a completely separate design, though, because as you see in this chapter, an app on a single device can go from one size class to another size class. You don't want to make a dramatic change as user drags the divider!

### Resources

Memory is a limited resource. You've always been told to be a good memory citizen. In a multitasking enabled iPad, you can potentially have up to 3 apps running at full speed at the same time: the primary app, the secondary app and Picture in Picture. It's important to understand how these apps interact and how they affect available memory. Use Instruments and try and get your memory usage as low as possible.

## Where to go from here
In this chapter you learned about basics of Multitasking. Multitasking completely changes the way users use their iPads. Here are a number of resources that you can bookmark for future reference:
* [Adopting Multitasking Enhancements on iPad- http://apple.co/1MdssbK](https://developer.apple.com/library/prerelease/ios/documentation/WindowsViews/Conceptual/AdoptingMultitaskingOniPad/index.html)
* [Getting Started with Multitasking on iPad in iOS 9 (Session 205) - http://apple.co/1ItxCtH](https://developer.apple.com/videos/wwdc/2015/?id=205)
* [Multitasking Essentials for Media-Based Apps on iPad in iOS 9 (session 211) - http://apple.co/1hm8v5s](https://developer.apple.com/videos/wwdc/2015/?id=211)
* [Optimizing Your App for Multitasking on iPad in iOS 9 (Session 212) - http://apple.co/1T8CCcp](https://developer.apple.com/videos/wwdc/2015/?id=212)
