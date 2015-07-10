# Multitasking

By Soheil Azarpour

Apple introduced a game changing feature for iPad in iOS 9 called __multitasking__. Multitasking completely changes the way a lot of users use their iPads. Users can now consider the iPad as a serious computer replacement.

There are three different aspects to multitasking on the iPad: Slide Over, Split View, and Picture in Picture. You activate Slide Over by swiping from the right edge of the screen (or the left edge if you have changed your iPad locale to a region with right-to-left language). You will see a list of multitasking-ready apps on your iPad in that list, from which you can tap and launch an app. If your app is not multitasking-ready, it won't show up in this list!

You can then pin the Slide Over and activate Split View. In Split View the screen is divided between the two apps. You can use both apps independently and both are fully functional.

The Picture in Picture multitasking feature works similarly to the picture-in-picture function on televisions. When watching a video or participating in a FaceTime call, the video window can be minimized to one corner of the iPad so you can continue to use other apps while you watch or chat.

In this chapter your will learn how to update an existing app so that it plays nicely in a split view along with other apps.

## Getting started

Slide-Over supported hardware: app iPads
PIP supported hardware: iPad Air, iPad Air 2, iPad Mini 2, iPad Mini 3.

Change Multitasking behavior under Settings > General > Multitasking:
- Allow multiple apps (on/off)
- Persistent video overlay (on/off)
Provide adaptive video stream.

Why adopt it?
  user is in control

How to adopt it?
  make your app universal
  design for adaptivity
  in iOS 8 you learned about size classes
  iPhone portrait = compact horizontal size class
  iPhone landscape = compact horizontal size class
    except for iPhone 6 Plus which is regular
  iPad portrait = regular horizongtal size class
  iPad landscape = regular horizongtal size class

  Slide over
  - the app on the right starts with compact horizontal size class; user starts with iPhone experience
  - when the right-side app takes over, it becomes regular horizontal size class; this is iPad traditional user experience

  when user slides over, user wants to see your app in the list!
  let users get into your app more and spend more time in your app while using your app alongside / in concert with other apps.

  if you start a new project with Xcode 7, it's automatically set for multitasking.

  HOW TO MAKE YOUR EXISITING APP MULTITASKING
  (1) universal app
  (2) build the app with iOS 9 SDK
  (3) support all orientations (in the build settings)
  (4) use launch storyboard

  Think about orientation as bound size changes!
  User is in control what orientation they look at the iPad.

  IF YOU REALLY REALLY WANT FULLSCREEN, no multitasking you can opt out: UIRequiresFullscreen key in Info.plist




* Learn about slide over, pin, drag, take over
* A brief introduction to PIP
* Supported hardware for multitasking and PIP
* How to enable / disable multitasking & PIP in the device Settings
* How to opt out of iOS 9 Multitasking


## Tutorial
All new apps created with Xcode 7 will automatically be multi-tasking enabled. [Theory]
In this tutorial you will learn how to adopt iOS 9 Multitasking in an old app. [Theory & Instruction]
Here is what you need: [Theory & Instruction]
(1) universal app
(2) build the app with iOS 9 SDK
(3) support all orientations (in the build settings)
(4) use launch storyboard
A brief about changes in UIKit for better adoption: [Reference]
(1) UIScreen, UIWindow, UIView.readableContentGuide, UITableView.cellLayoutMArginsFollowReadableWidth
(2) Refer reader to learn more about it in Auto Layout, Size Classes, etc.
Before Dive into the code, here are strategies you can take: [Theory & Instruction]
(1) Be flexible
(2) Use Auto Layout
(3) Use Size classes
(4) UIAdaptivePresentationControllerDelegate
(5) UISplitViewController
You will use some of these strategies in the tutorial.
Deal with keyboard even though it's not your app presenting it. [Instruction]
Deal with camera since it's a resource that may not be available to your app in multitasking [Theory & Instruction]
Oops! Fix that UIAlertView :] [Instruction]
Be prepared for size changes during system snapshots [Theory]
Be a good citizen [Theory]
testing alongside a resource intensive app: e.g. run the app alongside with Maps.app flyover.
sharing CPU / memory
some useful strategies (e.g. NSCache)
Best practices
User control's your app size.
Apps cannot prevent or cause size changes
Size changes can happen at any time
Keep the user orientated.
Don’t make abrupt changes
Be smart in new ways
The system may change the app’s size to take a snapshot.
Optimize your app (Memory managemnet) for multitasking

- Getting started
	What is it?
		slide from left to right = sldie over
		tap the divider to pin it side by side = split view
		user can tap the divider and change it to 50-50
		then user can move all the way to the left to take over
		then can bring in another view from right

		concept of PRIMARY app vs. SECONDARY app.
		primary app is always on the left (unless device is set to right-to-left, e.g. Arabic)

		You can have up to 3 apps on screen at the same time:
		Before: fullscreen
		After: Slide over, split view, picture in picture.





	2. Changes in UIKit for better adoption
		UIScreen.bounds = visible bounds of the entire display. This is still true even though your app may not be full screen.
		UIWindow.bounds is not necessarily the same as UIScreen size.
		UIWindow origin is ALWAYS 0,0. Focus only on your own experience.

		EXAMPLE:
		App start as slide over in compact horizontal size class.
		Then it becomes regular horizontal size class (50-50). Use size class transition.
		Not all size changes triggers a size class change.
		UIView.readableContentGuide
		UITableView.cellLayoutMArginsFollowReadableWidth = YES / NO
		cell content view is laid out to maintain legibility

		DO NOT USE ORIENTATION
		when iPad is in landscape but your app is in multitasking and iPhone size, it's better to provide portrait experience!

		if view.bounds.size.width > view.bounds.size.height { ... }
		if traitCollection.horizontalSizeClass ==.Regular { ... }

		- willTransitionToTraitCollection
		- viewWillTransitionToSize

		Rotation
		1. willTransitionToTraitCollection - setup
		2. viewWillTransitionToSize - setup
		3. traitCollectionDidChange - with transition coordinator
		4. animateAlongsideTranstion - create animation

// IF THE FIRST 2 STEP take too long, the app is terminated!
// DO NOT ASSUME that if Trait is changed, size is changed too.

[[UIWindow alloc] init] Don’t pass frame.

UIPresentationController
to provide custom presentaitons: A look inside presentation controller (WWDC 2014)

Popover presentation becomes modal presentation or may become form sheet

UIAdaptivePresentationControllerDelegate
- adaptivePresentationStyleForPresentationController
- willPresentWithAdaptiveStyle

To maintain the pointing arrow of the popover to the correct location:
popoverPresentationController.barButtonItem = sender OR
popoverPresentationController.sourceView = button
popoverPresentationController.sourceRect = button.bounds

Keyboard
keyboard appears on both apps. Use UIScrollViewContentInset It may not be your app that is displaying keyboard.

UIKeyboard WillShow / DidShow / WillHide / DidHide / WillChangeFrame / DidChangeFrame Notification

Best practices:
1. Consider size and Size Class instead of orientation
2. Think about how to respond to transition
3. Use adaptive presentations

Making the most out of Multitasking
1. Make your app universal
2. Design user experiences for Compact and Regular widths
3. Use adaptivity to change between them

Strategies
1: Be flexible. Don’t hard code size. Don’t make assumptions. React to changes in size. Try all multitasking sizes and take notes of what works or not. Don't worry about animations:

slide over
resize bigger
make it bigger again
slide over another app
pin the slider
rotate device : size class change but no size change [?]
concentrate on layout - NOT animation, etc.
USE AUTO LAYOUT
Margines and guides
Use asset catalogs
Change view attributes
change font

2: Auto Layout
let label = UILabel()
let readableContentGuide = self.view.readableContentGuide
let constraints =  [label.leadingAnchor.constraintEqualToAnchor(readableContentGuide.leadingAnchor), label.trailingAnchor.contraintEqualToAnchor(readableContentGuide.trailingAnchor)]
NSLayoutConstraint.activateConstraints(constraints)

3: Take advantage of Size classes in Xcode (storyboard)
You can preview in storyboard

// want to present different UI for different size classes
willTransitonToTraitCollection
super…
switch
.compact
.regular
.unspecified // don't do anything

// provide a block of animation
let animation = { (context: UIViewControllerTranstionCoordinatorContext) -> Void in
	// change your UI here. it will animate from the old to the new.
 }
coordinator.animateAlongsideTransition(animation, completion: nil)

5: High-level APIs
Adaptive presentation controller
UITableView, UICollectionView, UIStackView


6: UISplitViewController - the root view controller
PrimaryViewController
SecondaryViewController


Adaptive Photo sample App


Guidelines:
User control's your app size
Apps cannot and should not prevent size changes
Apps cannot cause size changes
Size changes can happen at any time
Keep the user orientated.
Don’t make abrupt changes
Be smart in new ways
The system may change the app’s size to take a snapshot and then re-resize it.
When the app is deactivated, remember the size and location for as long as the app is inactive maintain that state!
On size change --> if inactive && newSize == originalSize { apply remembered state }

in case of multi screen only the primary app gets the second screen
use completion blocks for slow actions

When the size changes, do as little work as possible.
Use completion blocks for slow work

Camera is available only to one app at a time.
UIImagePicker:
if single app then (1) camera preview, (2) photo capture, (3) video capture.
if multiple app then (1) camera preview, (2) photo capture. There is no video capture.
UIImagePickerController.startVideoCapture() returns false!

AVCaptureSession
only availabe when fullscreen. ACVsession can be intruppted otherwise.
AVCaptureSessionWasInterruptedNotification
Check interruption reason: AVCaptureSessionInterruptionReasonKey
-VideoDeviceNotAvailableWithMultipleForegroundApps
Update UI.
AVCaptureSession automatically restores.
AVCaptureSessionInterruptionEndedNotification


DO NOT call **layoutIfNeeded** while transitioning (or in animation blocks). Use setNeedsLayout



Optimization

iPad multitasking
your app is no more full screen
your app doesn’t have full access to resources, e.g. CPU, memory, etc.
[	system	][	your app	][	free	]
[	system	][	your app	][	second app	][	free  ]
[	system	][	your app	][ 	second app	][	PIP	]

Springboard is a UIApplication. It’s a multitasking app. It’s always running in the foreground.
Fix memory leaks
Fix retain cycles and unbounded memory growth
Fix inefficient algorithms
Great performance has trade offs

Working set
critical objects are resources you need NOW!
keep it small
don’t let it grow unbounded
it might change based on context
manage CPU time better. do as little work as possible on the main thread
main thread’s main responsibility is responding to user interactions

QoS override
lower priority queues can be temporarily boosted when a high priority queue is waiting for it
dispatch_sync
dispatch_sync_wait

Listen to memory warnings
System is under memory pressure
remove anything that is not in your working set
NSCache great for objects that can be regenerated on demand

Run your app in multitasking with Maps Flyover. If it runs smoothly, you are in good shape.
Dirty, pursuable, clean
pursuable can be reclaimed by the OS.

NSPurgeableData : NSMutableData
beginContentAccess
endContentAccess
isContentDiscarded

Cache some data to file

Memory backed by a file on disk is considered clean
Memory and file contents must match exactly
Good for data that’s static and doesn’t change
Data in memory is evicted and reloaded on your behalf

NSData.initWithcontentFoFiles Optons… error

Not appropriate for small chunks of data
Virtual memory misuses: fragmentation and exhaustion
Abuse of VM results in termination too!


## Where to go from here
Adopting Multitasking Enhancements on iPad [https://developer.apple.com/library/prerelease/ios/documentation/WindowsViews/Conceptual/AdoptingMultitaskingOniPad/index.html]
Getting Started with Multitasking on iPad in iOS 9 (Session 205) [https://developer.apple.com/videos/wwdc/2015/?id=205]
Multitasking Essentials for Media-Based Apps on iPad in iOS 9 (session 211) [https://developer.apple.com/videos/wwdc/2015/?id=211]
Optimizing Your App for Multitasking on iPad in iOS 9 (Session 212) [https://developer.apple.com/videos/wwdc/2015/?id=212]
