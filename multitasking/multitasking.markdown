# Multitasking

By Soheil Azarpour

Apple introduced a game changing feature for iPad in iOS 9 called **multitasking**. Multitasking allows you to split the screen between two running apps, and interact with them at the same time on one screen. For example you can read a proposal in your emails, while researching the topic in Safari next to it. You can also enjoy watching your favorite sport show at the same time on the same screen. And all of this happens on an iPad that you hold in  your hands while you lounge on a couch! This is super powerful!

Multitasking completely changes the way a lot of users use their iPads. Users can now consider the iPad as a serious computer replacement.

In this chapter you learn how to update an existing app so that it plays nicely in a multitasking environment along with other apps.

## Getting started

The starter project you’ll use for the remainder of this chapter is called **Travelog**. Open the project file in Xcode and build and run the application for iPad Air 2 simulator. You’ll see the following screens:

![width=90% ipad](images/mt05.png)

Travelog is a journaling app. The app uses `UISplitViewController` to display entries on the left side. If you tap on an entry, it's displayed in the right hand view. Rotate the device and you'll see both master and detail views of the Split View Controller are visible in both orientations. However, the master view is narrower in portrait orientation to give more room for the content in detail view.

It's time to see how the app behaves in a multitasking environment. Swipe from the right edge of the screen to expose the list of multitasking-ready apps on your iPad. Tap on one of the apps like Calendar app to launch it. Notice there is a handle in the divider that suggests you can pin the divider. Go ahead and tap on that!

![width=90% ipad](images/mt06.png)

W00t! The screen just divided in two! Isn't that nice?!

> **Note**: If an app isn't multitasking ready, you won't see the handle and so you won't be able to pin it. There is also a short handle bar at top of the Slide Over. Swipe down on the handler to expose the list of multitasking apps again and launch a different app in the Slide Over.

There are three different aspects to multitasking on the iPad: Slide Over, Split View, and Picture in Picture. You activate Slide Over by swiping from the right edge of the screen. In the Slide Over you are presented with a list of multitasking-ready apps on your iPad, from which you can tap and launch one. If your app is not multitasking-ready, it won't show up in this list!

> **Note**:  If the locale of the iPad is set to a region with right-to-left language, you swipe from the right edge of the screen to activate multitasking.

If you can't get to Slide Over on your device or you wan to make sure whether an iPad supports multitasking, go to **Settings > General** of the device. If you see **Multitasking** in the list, your iPad is multitasking capable. As a user you can disable multitasking.

![width=90% ipad](images/mt04.png)

This is a great opportunity and you want your users to see your app in the list! This allows users to get into your app more often and spend more time in it while using your app alongside with other apps.

If for any reason, you really don't want to participate in a multitasking environment, you can opt out of this feature by checking **Requires full screen** box in the General tab of your app target settings.

![width=90% ipad](images/mt02.png)

Not only you can interact with both apps in the Split View at the same time, you can also bring in another view and watch your favorite sports show. The Picture in Picture (PIP) is another multitasking feature that works the same way the picture-in-picture function on televisions work. You can minimize the PIP window or a FaceTime call to one corner of the iPad and continue using other apps while you watch or chat.

![width=90% ipad](images/mt03.png)

> **Note:** At the time of writing this chapter, Slide Over is supported on iPad Air 2 only. Picture in Picture is supported on iPad Air, iPad Air 2, iPad Mini 2, and iPad Mini 3.

## Prepare for multitasking

 Here is what you have to do to have a multitasking-ready app. If you start a new project in Xcode 7, it's automatically multitasking ready. An existing app automatically becomes multitasking-ready if the following conditions are met:
* a universal app
* compiled with SDK 9.x
* supports all orientations
* uses launch storyboard

Since all the required criteria are in place, Travelog becomes multitasking ready. That's good news but just because it's multitasking ready, doesn't mean that everything will work as expected.

### Orientation and size changes
Still running the app, rotate the iPad to landscape orientation, and you'll see the app with a layout shown below:

![bordered ipad](images/mt061.png)

You agree that while this layout is OK, it's not really what you want. There's a large white space wasted on the left hand side and all the labels are squashed to the right hand side.

Now rotate the device to landscape orientation:

![bordered ipad](images/mt062.png)

Again, it looks OK, but the master view column is too narrow and the text inside table view cells don't really provide any value. You need to think about orientation changes as bound size changes!

You see that the app already does some layout update on an orientation change. So let's start with that. Open **SplitViewController.swift**. This is a subclass of `UISplitViewController` and overrides `viewDidLayoutSubviews()` to update the maximum width of primary column by calling a helper method, `updateMaximumPrimaryColumnWidth()`. In the implementation of `updateMaximumPrimaryColumnWidth()`, the code checks for status bar orientation to determine the maximum width. Clearly this approach isn't appropriate, because in multitasking environment the app can have a narrow window even although it's in landscape orientation.

UIKit provides a number of anchor points that you can hook on to and update your layout:

1. **willTransitionToTraitCollection(_, withTransitionCoordinator:)**
2. **viewWillTransitionToSize(_, withTransitionCoordinator:)**
3. **traitCollectionDidChange(_):**

When you launch an app in the Slide Over, it starts in compact horizontal size class. When you pin the app, it is still in compact horizontal size class. On the other side where the primary app is, in portrait orientation the size class changes from regular to compact horizontal size class. In landscape orientation the primary app stays in regular horizontal size class.

Because not all size changes trigger a size class change, you can't solely rely on size class changes to provide the best user experience.

It looks like `viewWillTransitionToSize(_, withTransitionCoordinator:)` is a good candidate to update this code. Remove the implementation of both `viewDidLayoutSubviews()` and `updateMaximumPrimaryColumnWidth()` from `SplitViewController` and update it with the following methods instead:

```swift
// 1
func updateMaximumPrimaryColumnWidthBasedOnSize(size: CGSize) {
  if size.width < CGRectGetWidth(UIScreen.mainScreen().bounds) || size.width < size.height {
    maximumPrimaryColumnWidth = 160.0
  } else {
    maximumPrimaryColumnWidth = UISplitViewControllerAutomaticDimension
  }
}

// 2
override func viewDidLoad() {
  super.viewDidLoad()
  updateMaximumPrimaryColumnWidthBasedOnSize(view.bounds.size)
}

// 3
override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
  super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
  updateMaximumPrimaryColumnWidthBasedOnSize(size)
}
```

Here you add a new helper method, `updateMaximumPrimaryColumnWidthBasedOnSize(_)` that takes in a `size` parameter and updates the `maximumPrimaryColumnWidth` property of the split view controller based on the overall size of the split view itself. You do the update once the split view is initially loaded and once when its size is changed.

Build and run. First verify that the app still looks and behaves as before without multitasking in all orientations. Then enable multitasking and try different orientations.

![width=95%](images/mt063.png)

It's certainly not fixed. It even looks more broken now because with multitasking enabled in landscape orientation the master column view is jacked up!

It looks like the table view cell doesn't adopt to size changes appropriately. Open **LogCell.swift** and find the implementation of `layoutSubviews()`. You see that the code checks for `UIScreen.mainScreen().bounds.width` to determine whether it should use the compact view or regular view. Even in multitasking environment `UIScreen` always represents the entire screen, even though the app window doesn't necessarily take up the entire screen. You can no longer depend on screen sizes in your code. This is a bad habit anyway. Let's update this code as follows:

```swift
override func layoutSubviews() {
  super.layoutSubviews()
  let isTooNarrow = CGRectGetWidth(bounds) <= LogCell.widthThreshold
  // some code ...
}
```

Make sure you also update `widthThreshold`; it's declared at the beginning of `LogCell` class declaration:

```swift
static let widthThreshold: CGFloat = 160.0
```

Here you check for the width of the cell boundary itself, `CGRectGetWidth(bounds)`, instead of the width of the screen. This is better because you don't couple your code with some conditions of its superviews in the view hierarchy. Adaptivity is now self-contained!

Build and run again. Again, verify that the app still looks and behaves as before without multitasking enabled. This time around with multitasking enabled,  the app should play nicer in all orientations.

![width=95%](images/mt09.png)

> **Note:** Unlike `UIScreen`, `UIWindow.bounds` always corresponds to the actual size of your app and its origin is always at `(0, 0)`. Also in iOS 9 you can create a new instance if `UIWindow` without passing a frame. That is 'let window = UIWindow()'. The system will automatically give it the right frame that matches your application's frame.

## Adaptive presentation

Continue evaluation the app in multitasking environment. This time with device in landscape orientation and the split view at 30%, tap the **Photo Library** bar button, and you will be presented with a popover.

![bordered ipad](images/mt091.png)

With popover still visible, drag the divider further to the left so that the screen is divided in half between the two apps.

![bordered ipad](images/mt092.png)

You notice that the popover automatically turns into a modal view. There a great flexibility built right into the UIKit out of the box. When you drag the divider to 50%, the size class of the app changes from regular to compact horizontal size class, in which the default behavior of UIKit is to present a popover asa modal view; but this is not exactly what you want.

You want to present Photo Library modally only if the width of your app is about one third of the screen, similar to an iPhone screen size. You get to size size if your app is opened in the Slide Over. But at 50% you still rather present the Photo Library in a popover.

In iOS 8 Apple introduced `UIPopoverPresentationController` to manage the display of content in a popover. You use `UIPopoverPresentationController` along with `UIModalPresentationPopover` presentation style to present popovers. To modify the default behavior you use `UIPopoverPresentationControllerDelegate` callbacks.

Open **LogsViewController.swift** and find the implementation of `presentCameraControllerForSourceType(_:)`. You see that if the source type is `.PhotoLibrary`, the `UIImagePickerController` instance is presented as a popover. Update its implementation by adding `presenter?.delegate = self` as follows:

```swift
func presentCameraControllerForSourceType(sourceType: UIImagePickerControllerSourceType) {
  // some code...
  if sourceType == UIImagePickerControllerSourceType.PhotoLibrary {
    // some code...
    presenter?.delegate = self
  }
  // some code...
}
```

Now that you indicated you'd like to be delegate of a `UIPopoverPresentationController`, update declaration of `LogsViewController` so that it conforms to `UIPopoverPresentationControllerDelegate` as follows:

```swift
class LogsViewController: UITableViewController, DetailViewControllerPresenter, UIPopoverPresentationControllerDelegate
```

`UIPopoverPresentationControllerDelegate` itself is a protocol that inherits from `UIAdaptivePresentationControllerDelegate`. The method that you're interested in is `adaptivePresentationStyleForPresentationController(_:, traitCollection:)` and it returns value from `UIModalPresentationStyle` enum.

Next add an implementation for `adaptivePresentationStyleForPresentationController(_:, traitCollection:)` method at the end of `LogsViewController` class as follows:

```swift
func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
  return (splitViewController?.view.bounds.size.width > 320 ? .None : .FullScreen)
}
```

Here you return `.None` if the width your Split View Controller's view is wider than 320 points, which tells the system not to change the behavior. Otherwise, you return `.FullScreen` so that the popover is actually presented in as fullscreen.

Build and run. Verify that the only time you see the popover turning into a modal fullscreen view is when your app is in the Slide Over or in the portrait orientation with multitasking enabled.

![width=95%](images/mt093.png)

There has been some great tools in UIKit to prepare you for multitasking and adaptivity. Auto Layout, Size Classes are couple of them. If you are not using them already, it's time to update your code. In addition to those, there are  some new tools in UIKit to further assist you with multitasking; `UIView.readableContentGuide` and `UITableView.cellLayoutMarginsFollowReadableWidth` are two of those. You can learn more about **UIStackView and Auto Layout Changes** in chapter XX of this book.

### Strategies

There are some other strategies that you can use to improve your code in a multitasking environment:

2. **Be flexible:** Step away from a pixle-perfect design for various platforms and orientations. You need to think about different sizes and how you can have a flexible app that responds to size changes appropriately.
3. **Use Auto Layout:** Remove hardcoded sizes or code that manually changes size of elements, it's time to consider Auto Layout and make your code more flexible and easier to maintain.
4. **Use Size classes:** One single layout doesn't always fit all displays. Use size classes to build a base layout and then customize each specific size class based on the individual needs of that size class. Don’t treat each of the size classes as a completely separate design, though, because as you saw earlier, an app on a single device can go from one size class to another size class. You don't want to make a dramatic change as user drags the divider!

> **Note:** To refresh your memories, iPhone portrait is compact horizontal size class; iPhone landscape is compact horizontal size class except for iPhone 6 Plus which is regular horizontal size class. iPad has regular horizontal size class in both portrait and landscape orientations. To learn more about size classes, you can check out **Adaptive Layout** in iOS 8 By Tutorials.

## Keyboard

Dealing with keyboard presentation has always been an interesting topic in iOS. You probably have the experience of adjusting your view layout when a keyboard is presented to give user some room or move some UI elements to the visible rect.

In a multitasking environment, you'll continue doing that with a new requirement: you are not the only person who will present the keyboard anymore!

Other apps running side by side next to your app may present the keyboard and you need to adjust your layout so that the user can continue using your app -- or they may leave you bad reviews in the App Store! :]

In Travelog, the only time you display a keyboard is when user edits a text log, which is presented modally in full screen view. So the rest of the app didn't use to make any adjustment for keyboard presentation. This is about to change. Open **LogsViewController.swift** and update implementation of `viewDidLoad()` as follows:

```swift
override func viewDidLoad() {
  // ... some code ...
  NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardAppearanceDidChangeWithNotification:", name: UIKeyboardDidShowNotification, object: nil)
  NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardAppearanceDidChangeWithNotification:", name: UIKeyboardDidHideNotification, object: nil)
}
```

Here you simply start listening for `UIKeyboardDidShowNotification` and `UIKeyboardDidHideNotification` notifications.

To balance the calls, unregister for the notifications you've registered for in `deinit`:

```swift
deinit {
  // ... some code ...
  NSNotificationCenter.defaultCenter().removeObserver(self)
}
```

Now add the implementation of `keyboardAppearanceDidChangeWithNotification(_)` as follows:

```swift
func keyboardAppearanceDidChangeWithNotification(notification: NSNotification) {
  guard let userInfo: [NSObject: AnyObject] = notification.userInfo else { return }
  let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
  let convertedFrame = view.convertRect(keyboardEndFrame, fromView: nil)
  let keyboardTop = CGRectGetMinY(convertedFrame)
  let delta = max(0.0, CGRectGetMaxY(tableView.bounds) - keyboardTop)
  var contentInset = tableView.contentInset
  contentInset.bottom = delta
  tableView.contentInset = contentInset
  tableView.scrollIndicatorInsets = contentInset

  if let selectedIndexPath = selectedIndexPath {
    tableView.scrollToRowAtIndexPath(selectedIndexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
  }
}
```

The code blob may seem lengthy but it's quite straight forward. You find what's the frame of the keyboard in respect to your app's coordinate system. If it's intersecting with your table view, you adjust the `contentInset` of the `tableView` or reset it to zero. To make it look nicer, you try to scroll the table view to the selected row so that user doesn't lose focus.

Build and run. Verify that when you are looking at the table of logs, and a secondary app presents the keyboard, the table view adjusts itself and you can scroll the entire table view.

![width=90%](images/mt11.png)

## System snapshot

You are probably familiar with iOS system snapshots. When your app becomes inactive and enters background, the OS takes a snapshot of the app's window to display to user when they activate App Switcher by double tapping the Home button. System snapshots happen automatically, and historically all you had to do was either obscuring your view if you were displaying some sensitive data or  do nothing! This is still true except that if user leaves your app while in multitasking mode, the system will resize your app in the background to get snapshots with various sizes. Be sure to keep this in mind when you write your multitasking-ready app and avoid making jarring changes or losing user's selection, while your app is resized in the background for snapshot purposes.

## Camera

Another area that you have to think about in a multitasking environment is availability of limited resources. Camera is a limited resource that can't be shared among multiple apps at the same time. If your app uses `UIImagePickerController` you are in better shape because `UIImagePickerController` knows how to behave in a multitasking environment. It pauses providing live preview and disables capture button. To see it in action, run **Travelog** on an iPad Air 2 device. Make sure you are in multitasking mode by sliding over another app and pin it on top of Travelog. Now add a new multimedia log by tapping the camera button and select **VIDEO** mode:

![width=90% ipad](images/mt14.png)

If your app uses `AVCaptureSession`, you may need to do some additional work and beef up your code to better cover cases where the camera feed is suspended while the app is running. There are two important `NSNotification` that you want to listen to: `AVCaptureSessionWasInterruptedNotification` and `AVCaptureSessionInterruptionEndedNotification`. In the `userInfo` of the notification you'll receive a key named `AVCaptureSessionInterruptionReasonKey` with a value that explains why camera feed is interrupted. In the multitasking mode the value is `AVCaptureSessionInterruptionReasonVideoDeviceNotAvailableWithMultipleForegroundApps`.

## Good memory citizen

Memory is another limited resource. You've always been told to be a good memory citizen. In a multitasking enabled iPad, you can potentially have up to 3 apps running at full speed at the same time: the primary app, the secondary app and Picture in Picture. It's important to understand how these apps interact and how they affect available memory.

You may have heard of **Springboard**. It's the built-in system application that manages display of icons and user's home screen. Springboard is a `UIApplication` object and a multitasking app in its own right. Springboard always runs in the foreground. When system is under memory pressure, primary app and the secondary app are the first apps to be ditched. That's because the system wants to reclaim some memory to make its Springboard stable. Picture in Picture is considered a background task of the Springboard, so it's not in the first line of jettison row! The first apps to be jettisoned is the primary app and along with that the secondary app is also terminated.

You can use the following strategies to reduce your app's memory footprint and optimize its memory use for multitasking environment:
* **Fix leaks, retain cycles and algorithms**: Check your app for memory leaks, remove retain cycles and unbounded memory growth, and fix inefficient algorithms. Manage CPU time better and do as little work as possible on the main thread. Keep in mind that main thread’s main responsibility is responding to user interactions. Perform any other tasks in the background with appropriate Quality of Service (QoS) priority.

> **Note:** `NSOperation` and `NSOperationQueue` are your friends. Make sure you check out their documentation for the latest updates. There is a great talk in WWDC 2015, Session 226: Advanced NSOperations that you can check out for practical examples.

* **Working set**: It refers to critical objects and resources that you need right now. Listen to memory warnings and free up anything that is not in your working set.
* **NSCache**: Take advantage of `NSCache`. It's a collection-like container similar to the `NSDictionary` class that incorporates various auto-removal policies. The system automatically carries out these policies if memory is needed by other applications. You can add, remove, and query items in a `NSCache` object from different threads without having to lock the cache yourself. Unlike an `NSMutableDictionary` object, a cache does not copy the key objects. It's a great tool for objects that can be regenerated on demand.
* **Test**: Test your app in different multitasking modes and run memory intensive apps alongside it. The Maps app Flyover mode is a great candidate for testing memory pressure in a multitasking environment.
* **Instruments**: Use Instruments to profile your app and monitor both its memory and VM footprint. Look out for virtual memory misuses because abuse of VM causes in fragmentation and eventually results in termination too!

## Best Practices
Before you go, consider these few thoughts on multitasking best practices.
* **User control's your app size**: You can't prevent or cause size changes. User can change the size of the window your app is displayed in it at any time. The system may change the app’s window size to take a snapshot. Make your app flexible!
* **Keep the user oriented**: With size changes, it's easy to confuse user. Make sure you keep your users oriented and avoid abrupt changes. You need to be smart in new ways.
* **Consider size and Size Class instead of orientation**: Think about how to respond to transition from one size to another, instead of device orientation. Make your app universal and use adaptive presentations. Make sure you check out `UIAdaptivePresentationControllerDelegate` protocol, and its two helpful delegate callback methods, `adaptivePresentationStyleForPresentationController(_:)` and `presentationController(_:,
viewControllerForAdaptivePresentationStyle:)`.
* **Use setNeedsLayout()**: Do not call `layoutIfNeeded()` while transitioning in either `willTransitionToTraitCollection(_, withTransitionCoordinator:)` or `viewWillTransitionToSize(_, withTransitionCoordinator:)` because the system will do that for you. Try using `setNeedsLayout()` instead.
* **Be quick**: Transitioning is time-boxed by the operating system. You need to do as little work as possible to provide a smooth transition. Use the completion block for longer, time consuming tasks.

## Where to go from here
In this chapter you learned about basics of Multitasking. Multitasking completely changes the way users use their iPads. Here are a number of resources that you can bookmark for future reference:
* [Adopting Multitasking Enhancements on iPad](https://developer.apple.com/library/prerelease/ios/documentation/WindowsViews/Conceptual/AdoptingMultitaskingOniPad/index.html)
* [Getting Started with Multitasking on iPad in iOS 9 (Session 205)](https://developer.apple.com/videos/wwdc/2015/?id=205)
* [Multitasking Essentials for Media-Based Apps on iPad in iOS 9 (session 211)](https://developer.apple.com/videos/wwdc/2015/?id=211)
* [Optimizing Your App for Multitasking on iPad in iOS 9 (Session 212)](https://developer.apple.com/videos/wwdc/2015/?id=212)
