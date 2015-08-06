# Multitasking

By Soheil Azarpour

Apple introduced a game changing feature for iPad in iOS 9 - **multitasking**. For the first time users can run two apps on screen at the same time! For example, you can read a proposal in your emails while researching the topic in Safari next to it. You can also enjoy watching your favorite sports show at the same time on the same screen. And all of this happens on an iPad that you hold in  your hands while you lounge on a couch! This is super powerful!

Multitasking will change the way a lot of users use their iPads. In this chapter you will learn how to update an existing app so that it plays nicely in multitasking environment.

## Getting started

The starter project you’ll use for the remainder of this chapter is called **Travelog**. Open the project file in Xcode and build and run the application on the **iPad Air 2** simulator. You’ll see the following:

![width=90% ipad](images/mt05.png)

Travelog is a journaling app. The app uses `UISplitViewController` to display entries on the left side. If you tap on an entry, it's displayed in the right hand view. Rotate the device and you'll see both master and detail views of the Split View Controller are visible in both orientations. However, the master view is narrower in portrait orientation to give more room for the content in detail view.

It's time to see how the app behaves in a multitasking environment. Swipe from the right edge of the screen (this can be tricky in the simulator, start with your mouse pointer just inside the simulator window) to expose the list of multitasking-ready apps on your iPad. 

> **Note**:  If the locale of the iPad is set to a region with right-to-left language, you swipe from the right edge of the screen to activate multitasking.

Tap on one of the apps to launch it. A small version of the app opens up where the list was. At this point you are in **Slide Over** multitasking mode. Note that Travelog is dimmed out but otherwise unaffected. The app running in slide over is on top of Travelog. There is a short handle bar at top of the Slide Over. Swipe down on the handler to expose the list of multitasking apps again and launch a different app in the Slide Over.

You'll notice a handle at the edge of the slide over view. Tap it:

![width=90% ipad](images/mt06.png)

W00t! The screen just divided in two! Isn't that nice?! Now you're in **Split View** multitasking mode. Travelog is now available to use, and has resized to fit the new, narrower portion of the window. 

> **Note**: If an app isn't multitasking ready, it won't appear in the list. Make sure your app is ready!

The original running app is called the **primary app**, the new one the **secondary app**. You can drag the divider further out and have the screen split 50:50 between the apps. Drag it all the way to the other side and you're now in single app mode again, and the primary app is backgrounded.

The final type of multitasking is called **Picture in Picture** (PIP). This feature works the same way the picture-in-picture function on televisions work. You can shrink the PIP window or a FaceTime call to one corner of the iPad and continue using other apps while you watch or chat. PIP is only really applicable to video playing apps and isn't covered in this chapter.

> **Note:** At the time of writing, Split View is **only** available on the iPad Air 2. Picture in Picture and Slide Over is available on iPad Air, iPad Air 2, iPad Mini 2, and iPad Mini 3.

## Preparing your app for multitasking

Here's the good news: If you paid attention and WWDC 2014 and have built a universal app with size classes, adaptive layout and a launch storyboard or xib, you're done. Rebuild it with the iOS 9 SDK and get yourself a beverage. See you in the next chapter! 

What's that? You live in the real world? OK then. Here is what you have to do to have a multitasking-ready app. If you start a new project in Xcode 7, it's automatically multitasking ready. An existing app automatically becomes multitasking-ready if the following conditions are met:

* a universal app
* compiled with SDK 9.x
* supports all orientations
* uses launch storyboard

Since all the required criteria are in place, Travelog becomes multitasking ready. That's good news, but just because it's multitasking ready, it doesn't mean that everything will work as expected. For the rest of this chapter you'll work through a couple of common pitfalls found when converting an app to multitasking.

## Orientation and size changes

Running Travelog in Split View mode, rotate the iPad to portrait orientation, and you'll see the app with a layout shown below:

![bordered ipad](images/mt061.png)

You agree that while this layout is OK, it's not really what you want. There's a large white space wasted on the left hand side and all the labels are squashed to the right hand side.

Now rotate the device to landscape orientation:

![bordered ipad](images/mt062.png)

Again, it looks OK, but the master view column is too narrow and the text inside the table view cells don't really provide any value.

The app already does some layout update on an orientation change, So let's start with that. Open **SplitViewController.swift**. This is a subclass of `UISplitViewController` and overrides `viewDidLayoutSubviews()` to update the maximum width of primary column by calling a helper method, `updateMaximumPrimaryColumnWidth()`. In the implementation of `updateMaximumPrimaryColumnWidth()`, the code checks for status bar orientation to determine the maximum width. This approach is no longer appropriate, because in now the app can have a narrow window even although it's in landscape orientation.

UIKit provides a number of anchor points that you can hook on to and update your layout:

1. **willTransitionToTraitCollection(_:, withTransitionCoordinator:)**
2. **viewWillTransitionToSize(_:, withTransitionCoordinator:)**
3. **traitCollectionDidChange(_:):**

This diagram shows how the horizontal size classes of your app change during multitasking events. R means **Regular** and C means **Compact**:

![width=100%](images/sizeclasses.png)

Not all multitasking or orientation changes trigger a size class change, so you can't just rely on size class changes to provide the best user experience.

It looks like `viewWillTransitionToSize(_:, withTransitionCoordinator:)` is a good candidate to update this code. Remove `viewDidLayoutSubviews()` and `updateMaximumPrimaryColumnWidth()` from **SplitViewController.swift** and add the following:

```swift
func updateMaximumPrimaryColumnWidthBasedOnSize(size: CGSize) {
  if size.width < UIScreen.mainScreen().bounds.width || size.width < size.height {
    maximumPrimaryColumnWidth = 160.0
  } else {
    maximumPrimaryColumnWidth = UISplitViewControllerAutomaticDimension
  }
}
```

This helper method updates the split view's maximum primary column width. It gives the smaller version when the split view is narrower than the screen (e.g. you are in a multitasking situation) or the split view itself has a portrait orientation.

This helper method needs to be called when the view is first loaded, so add the following:

```swift
override func viewDidLoad() {
  super.viewDidLoad()
  updateMaximumPrimaryColumnWidthBasedOnSize(view.bounds.size)
}
```

This ensures that the split view starts in the right configuration. Add one final method:

```swift
override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
  super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
  updateMaximumPrimaryColumnWidthBasedOnSize(size)
}
```

This method updates the primary column when the size changes.

Build and run. First verify that the app still looks and behaves as before without multitasking in all orientations. Then bring in another app in Split View and try different orientations.

![width=95%](images/mt063.png)

It's certainly not fixed. It even looks more broken now because with multitasking enabled in landscape orientation the master column view is jacked up!

It looks like the table view cell doesn't adapt to size changes appropriately. Open **LogCell.swift** and find the implementation of `layoutSubviews()`. You see that the code checks for `UIScreen.mainScreen().bounds.width` to determine whether it should use the compact view or regular view.

`UIScreen` always represents the entire screen regardless of multitasking environment. You can no longer depend on screen sizes in your code because your app may not be taking the entire screen. So update the implementation of `layoutSubviews()` as follows:

```swift
override func layoutSubviews() {
  super.layoutSubviews()
  let isTooNarrow = bounds.width <= LogCell.widthThreshold
  // some code ...
}
```

Also update `widthThreshold`; it's declared at the beginning of `LogCell`:

```swift
static let widthThreshold: CGFloat = 160.0
```

The updated code is checking for the width of the cell itself instead of the width of the screen. This is better because you're not coupling the view's behaviour its superviews. Adaptivity is now self-contained!

Build and run. Again, verify that the app still looks and behaves as before without multitasking enabled. This time around, in Split View the app should play nicer in all orientations:

![width=95%](images/mt09.png)

> **Note:** Unlike `UIScreen`, `UIWindow.bounds` always corresponds to the actual size of your app and its origin is always at `(0, 0)`. Also in iOS 9 you can create a new instance of `UIWindow` without passing a frame. That is 'let window = UIWindow()'. The system will automatically give it a frame that matches your application's frame.

## Adaptive presentation

Continue evaluating the app in multitasking environment. This time with device in landscape orientation and the Split View at 33%, tap the **Photo Library** bar button, and you will be presented with a popover.

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
