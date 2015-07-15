# Multitasking

By Soheil Azarpour

Apple introduced a game changing feature for iPad in iOS 9 called __multitasking__. Multitasking completely changes the way a lot of users use their iPads. Users can now consider the iPad as a serious computer replacement.

In this chapter you learn how to update an existing app so that it plays nicely in a split view along with other apps.

## Getting started

There are three different aspects to multitasking on the iPad: Slide Over, Split View, and Picture in Picture. You activate Slide Over by swiping from the right edge of the screen (or the left edge if you have changed your iPad locale to a region with right-to-left language). You will see a list of multitasking-ready apps on your iPad in that list, from which you can tap and launch one. If your app is not multitasking-ready, it won't show up in this list!

This is a great opportunity and you want your users to see your app in the list! This allows users get into your app more often and spend more time in it while using your app alongside with other apps.

You can then pin the Slide Over and activate Split View. In Split View the screen is divided between the two apps. You can use both apps independently and both are fully functional.

![width=90% ipad](images/mt01.png)

If for any reason, you really don't want to participate in a multitasking environment, you can opt out of this feature by checking __Requires full screen__ box in the General tab of your app target settings.

![width=90% ipad](images/mt02.png)

The Picture in Picture (PIP) multitasking feature works similarly to the picture-in-picture function on televisions. When watching a video or participating in a FaceTime call, the video window can be minimized to one corner of the iPad so you can continue to use other apps while you watch or chat.

![width=90% ipad](images/mt03.png)

> **Note:** At the time of writing this chapter, Slide Over is supported on iPad Air 2 only. Picture in Picture is supported on iPad Air, iPad Air 2, iPad Mini 2, and iPad Mini 3.

If you are not sure whether your iPad supports multitasking, go to __Settings > General__ on your iPad. If you see __Multitasking__ in the list, your iPad is multitasking capable. As a user you can disable multitasking.

![width=90% ipad](images/mt04.png)

## The starter project

The starter project you’ll use for the remainder of this chapter is called __Travelog__. Open the project file in Xcode and build and run the application for iPad Air 2 simulator. You’ll see the following screens:

![width=90% ipad](images/mt05.png)

Travelog is a journaling app. The app uses `UISplitViewController` to display entries on the left side. If you tap on an entry, it's displayed in the right hand view. Rotate the device and you'll see both master and detail views of the Split View Controller are visible in both orientations. However, the master view is narrower in portrait orientation to give more room to the detail view.

It's time to see how the app behaves in a multitasking environment. Swipe from the right edge of the screen to expose the list of multitasking-ready apps on your iPad. Tap on one of the apps, like Calendar app to launch it. Notice there is a handle in the divider that suggests you can pin the divider. Go ahead and do that.

![width=90% ipad](images/mt06.png)

The screen just divided in two! But how did that happen? It turns out if you start a new project in Xcode 7, it's automatically multitasking ready. An existing app automatically becomes multitasking-ready if the following conditions are met:
* a universal app
* compiled with SDK 9.x
* supports all orientations
* uses launch storyboard

Since all the required criteria are in place, Travelog becomes multitasking ready. That's good news but just because it's multitasking ready, doesn't mean that everything will work as expected.

> **Note:** There is a short handle bar at top of the Slide Over. Swipe down on the handler to expose the list of multitasking apps again and launch a different app in the Slide Over.

There has been some great tools in UIKit to prepare you for multitasking and adaptivity. Auto Layout, Size Classes are couple of them. If you are not using them already, it's time to update your code. In addition to those, there are  some new tools in UIKit to further assist you with multitasking; `UIView.readableContentGuide` and `UITableView.cellLayoutMarginsFollowReadableWidth` are two of those. You can learn more about __UIStackView and Auto Layout Changes__ in chapter XX of this book.

## Prepare for multitasking

With that said, there are some strategies that you can use to improve your code in a multitasking environment:
1. __Universal:__ Make your app universal. Your users will be happier and feel more like home when they can interactive with your app on their iPad, for example, very much the same way they interact with it on their iPhone. If you look around you'll see that's how most of the apps that you also use on a daily basis behave. For example Mail, Calendar, and Notes just to name a few provide almost an identical user experience whether you use them on a Mac, on an iPad or on your iPhone.
2. __Be flexible:__ You need to step away from a pixle-perfect design for various platforms and orientations. You need to think about different sizes and how you can have a flixble app that responds to size changes appropriately.
3. __Use Auto Layout:__ If you still have some legacy code with hardcoded sizes or code that manually changes size of elements, it's time to consider Auto Layout to make your code more flexible and easier to maintain.
4. __Use Size classes:__ It's great to have universal storyboards, but one single layout doesn't always fit all displays. Use size classes to build a base layout and then customize each specific size class based on the individual needs of that size class. Don’t treat each of the size classes as a completely separate design, though, because as you will see later in multitasking, an app on a single device can go from one size class to another size class. You don't want to make a dramatic change as user drags the divider!

> **Note:** To refresh your memories, iPhone portrait is compact horizontal size class; iPhone landscape is compact horizontal size class except for iPhone 6 Plus which is regular horizontal size class. iPad has regular horizontal size class in both portrait and landscape orientations. To learn more about size classes, you can check out __Adaptive Layout__ in iOS 8 By Tutorials.

5. __UIAdaptivePresentationControllerDelegate:__ This is another great tool that's been around since iOS 8. You can easily change the presentation of a view controller based on the current context and the environment of the app. For example you can present a view controller either in a popover or modally depending on the current size class.
6. __UISplitViewController:__ This is probably the oldest tool you have in your toolbox for adaptivity and it's still very useful. Out of the box, `UISplitViewController` provides some great adaptivity to make your life easier. Make sure you check out the latest documentation for `UISplitViewController` for the updated API.

You will use some of these strategies in this tutorial to improve Travelog.

It's time to explore the app and examine it while in multitasking. Still in multitasking, if you look at the app in landscape orientation you'll notice even though the master view is displayed appropriately, table view cells are too cramped! Knowing that in portrait orientation you gave the master view a narrower width, you want to achieve the same look here.

![width=90%](images/mt06-1.png)

## Orientation and size changes
You need to think about orientation changes as bound size changes! In a multitasking environment, `UIScreen.bounds` still returns the visible bounds of the entire display. This is true even though your app may not be full screen.

On the other hand, `UIWindow.bounds` is not necessarily the same as `UIScreen` size anymore. `UIWindow`'s origin is always `(0, 0)`. Let's take a quick view at how orientation and size changes affect your app. You'll refer to the app that you open in the Slide Over as __secondary app__ and the app that's already open on the left hand side as __primary app__.

> **Note:** In iOS 9 you can create a new instance if `UIWindow` by simply calling `let window = UIWindow()`. You don’t have to pass a frame. The system will automatically give it the right frame that matches your application's frame.

![width=90% ipad](images/mt07.png)

When you launch an app in the Slide Over, it starts in compact horizontal size class. When you pin the app, it is still in compact horizontal size class. But it's different for the primary app. If the orientation is portrait, the primary app changes from regular horizontal size class to compact horizontal size class. If orientation is landscape, the primary app stays in regular horizontal size class.

If the device is in landscape orientation, you can still move the divider further to divide the screen in half between the two apps. At this point the primary app changes to compact horizontal size class.

You see that not all size changes trigger a size class change. You can't solely rely on size class changes to provide the best user experience.

UIKit provides a number of anchor points that you can hook on to and update your layout:

1. __willTransitionToTraitCollection(_, withTransitionCoordinator:)__
2. __viewWillTransitionToSize(_, withTransitionCoordinator:)__
3. __traitCollectionDidChange(_):__

Note that not all of the mentioend methods will be called. Almost always a size class changes accompanies a size change. But a size change may not necessarily change the size class. With `willTransitionToTraitCollection(_, withTransitionCoordinator:)` and `viewWillTransitionToSize(_, withTransitionCoordinator:)` you can provide an animation block that will be executed alongside with system animations.

Before you move on, there are couple important things to remember:
1. Do not call `layoutIfNeeded()` while transitioning because the system will do that for you. Try using `setNeedsLayout()` instead.
2. Transitioning is time-boxed by the operating system. You need to do as little work as possible to provide a smooth transition. Use the completion block for longer, time consuming tasks.

The following diagram shows how different pieces connect to each other in a size change transition.

![width=50%](images/mt08.png)

### Adapt to size

It's time to put your knowledge into practice now. Open __SplitViewController.swift__. This is a subclass of `UISplitViewController` and overrides `viewDidLayoutSubviews()` to update the maximum width of primary column by calling a helper method, `updateMaximumPrimaryColumnWidth()`. In the implementation of `updateMaximumPrimaryColumnWidth()`, the code checks for status bar orientation to determine the maximum width. Clearly this approach doesn't work anymore, because the app can now have a narrow window even though it's in landscape orientation.

Remove the implementation of both `viewDidLayoutSubviews()` and `updateMaximumPrimaryColumnWidth()`, then update `SplitViewController` with the following methods instead:

```swift
// 1
func updateMaximumPrimaryColumnWidthBasedOnSize(size: CGSize) {
  let width = size.width
  if width < CGRectGetWidth(UIScreen.mainScreen().bounds) {
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

Here you add a new helper method, `updateMaximumPrimaryColumnWidthBasedOnSize(_)` that takes in a `size` parameter and updates the `maximumPrimaryColumnWidth` property of split view controller based on the overall size of the split view itself. You do the update once the split view is initially loaded and once when its size is changed.

Build and run. Verify that when you pin the Slide Over in landscape orientation, it nicely changes the width of the master view to give more room to the detail view.

![bordered width=90% ipad](images/mt09.png)

## Keyboard

Dealing with keyboard presentation has always been an interesting topic in iOS. You probably have the experience of adjusting your view layout when a keyboard is presented to give user some room or move some UI elements to the visible rect.

In a multitasking environment, you'll continue doing that with a new requirement: you are not the only person who will present the keyboard anymore!

Other apps running side by side next to your app may present the keyboard and you need to adjust your layout so that the user can continue using your app -- or they may leave you bad reviews in the App Store! :]

In Travelog, the only time you display a keyboard is when user edits a text log, which is presented modally in full screen view. So the rest of the app didn't use to make any adjustment for keyboard presentation. This is about to change. Open __LogsViewController.swift__ and update implementation of `viewDidLoad()` as follows:

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

## Camera

Another area that you have to think about in a multitasking environment is availability of limited resources. Camera is a limited resource that can't be shared among multiple apps at the same time. If your app uses `UIImagePickerController` you are in better shape because `UIImagePickerController` knows how to behave in a multitasking environment. It pauses providing live preview and disables capture button. To see it in action, run __Travelog__ on an iPad Air 2 device. Make sure you are in multitasking mode by sliding over another app and pin it on top of Travelog. Now add a new multimedia log by tapping the camera button and select __PHOTO__ mode:

![width=90% ipad](images/mt12.png)

You will be presented with a full screen camera controller:

![width=90% ipad](images/mt13.png)

Now if you bring up another app in the Slide Over that uses the camera, the camera view for PHOTO mode becomes blocked:

![width=90% ipad](images/mt15.png)

> **Note:** An app the you can use in the Slide Over to test the above mentioned scenario is Contacts app. Select a contact from your contacts, tap __Edit > Add Photo > Take Photo__.

Now dismiss the camera in the Slide Over, and switch to __VIDEO__ in __Travelog__. You'll see that the camera view is now blocked:

![width=90% ipad](images/mt14.png)


If your app uses `AVCaptureSession`, you may need to do some additional work and beef up your code to better cover cases where the camera feed is suspended while the app is running. There are two important `NSNotification` that you want to listen to: `AVCaptureSessionWasInterruptedNotification` and `AVCaptureSessionInterruptionEndedNotification`. In the `userInfo` of the notification you'll receive a key named `AVCaptureSessionInterruptionReasonKey` with a value that explains why camera feed is interrupted. In the multitasking mode the value is `AVCaptureSessionInterruptionReasonVideoDeviceNotAvailableWithMultipleForegroundApps`.

## System snapshot

You are probably familiar with iOS system snapshots. When your app becomes inactive and enters background, the OS takes a snapshot of the app's window. The OS uses that snapshot later on when user activates App Switcher by double tapping the Home button:

![width=90% ipad](images/mt16.png)

System snapshots happen automatically, and historically all you had to do was either obscuring your view if you were displaying some sensitive data or  do nothing! New in a multitasking environment, the OS now changes your view sizes and takes multiple snapshots. To see this in action, open __SplitViewController.swift__ and update implementation of `viewWillTransitionToSize(_, withTransitionCoordinator:)` as follows:

```swift
override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
  if UIApplication.sharedApplication().applicationState == UIApplicationState.Background {
    print(__FUNCTION__ + "\(size)")
  }
  // ... some code ...
}
```

Build and run. Make sure the Debugger Console is open. Once the app is launched, activate multitasking mode by sliding over another app and pin it. Then while the app is still in that split view mode, press the __Home__ button (or __CMD+H__ in simulator). You will see the following logs:

```bash
viewWillTransitionToSize(_:withTransitionCoordinator:)(768.0, 1024.0)
viewWillTransitionToSize(_:withTransitionCoordinator:)(1024.0, 768.0)
viewWillTransitionToSize(_:withTransitionCoordinator:)(694.0, 768.0)
```

If you exactly follow the above mentioned steps, then the three lines in the console log refer to the time you pressed the Home button. It happened when the system changed your app's window size while in the background to take different snapshots. This becomes tricky when your app has a complicated layout. Be sure to keep this in mind when you write your multitasking-ready app and avoid making jarring changes or losing user's selection.

## Good memory citizen

Memory is another limited resource. You've always been told to be a good memory citizen. In a multitasking enabled iPad, you can potentially have up to 3 apps running at full speed at the same time: the primary app, the secondary app and Picture in Picture. It's important to understand how these apps interact and how they affect available memory.

When your app is launched, some memory is already allocated by the operating system. Your app claims some of the available memory. There is still some free memory left and everybody's happy!

Then the secondary app comes along and user may also launch a video in Picture in Picture mode. That's when the iPad starts running low on memory.

![width=90%](images/mt18.png)

You may have heard of __Springboard__. It's the built-in system application that manages display of icons and user's home screen. Springboard is a `UIApplication` object and a multitasking app in its own right. Springboard always runs in the foreground. When system is under memory pressure, primary app and the secondary app are the first apps to be ditched. That's because the system wants to reclaim some memory to make its Springboard stable. Picture in Picture is considered a background task of the Springboard.

You can use the following strategies to reduce your app's memory footprint and optimize its memory use for multitasking environment:
* __Fix leaks, retain cycles and algorithms__: Check your app for memory leaks, remove retain cycles and unbounded memory growth, and fix inefficient algorithms. Manage CPU time better and do as little work as possible on the main thread. Keep in mind that main thread’s main responsibility is responding to user interactions. Perform any other tasks in the background with appropriate Quality of Service (QoS) priority.

> **Note:** `NSOperation` and `NSOperationQueue` are your friends. Make sure you check out their documentation for the latest updates. There is a great talk in WWDC 2015, Session 226: Advanced NSOperations that you can check out for practical examples.

* __Working set__: It refers to critical objects and resources that you need right now. Listen to memory warnings and free up anything that is not in your working set.
* __NSCache__: Take advantage of `NSCache`. It's a collection-like container similar to the `NSDictionary` class that incorporates various auto-removal policies. The system automatically carries out these policies if memory is needed by other applications. You can add, remove, and query items in a `NSCache` object from different threads without having to lock the cache yourself. Unlike an `NSMutableDictionary` object, a cache does not copy the key objects. It's a great tool for objects that can be regenerated on demand.
* __Test__: Test your app in different multitasking modes and run memory intensive apps alongside it. The Maps app Flyover mode is a great candidate for testing memory pressure in a multitasking environment.
* __Instruments__: Use Instruments to profile your app and monitor both its memory and VM footprint. Look out for virtual memory misuses because abuse of VM causes in fragmentation and eventually results in termination too!

## Best Practices
Before you go, consider these few thoughts on multitasking best practices.
* __User control's your app size__: You can't prevent or cause size changes. User can change the size of the window your app is displayed in it at any time. The system may change the app’s window size to take a snapshot. Make your app flexible!
* __Keep the user oriented__: With size changes, it's easy to confuse user. Make sure you keep your users oriented and avoid abrupt changes. You need to be smart in new ways.
* __Consider size and Size Class instead of orientation__: Think about how to respond to transition from one size to another, instead of device orientation. Make your app universal and use adaptive presentations. Make sure you check out `UIAdaptivePresentationControllerDelegate` protocol, and its two helpful delegate callback methods, `adaptivePresentationStyleForPresentationController(_:)` and `presentationController(_:,
viewControllerForAdaptivePresentationStyle:)`.

## Where to go from here
In this chapter you learned about basics of Multitasking. Multitasking completely changes the way users use their iPads. Here are a number of resources that you can bookmark for future reference:
* [Adopting Multitasking Enhancements on iPad](https://developer.apple.com/library/prerelease/ios/documentation/WindowsViews/Conceptual/AdoptingMultitaskingOniPad/index.html)
* [Getting Started with Multitasking on iPad in iOS 9 (Session 205)](https://developer.apple.com/videos/wwdc/2015/?id=205)
* [Multitasking Essentials for Media-Based Apps on iPad in iOS 9 (session 211)](https://developer.apple.com/videos/wwdc/2015/?id=211)
* [Optimizing Your App for Multitasking on iPad in iOS 9 (Session 212)](https://developer.apple.com/videos/wwdc/2015/?id=212)
