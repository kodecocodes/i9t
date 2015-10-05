```metadata
author: "By James Frost"
number: "6"
title: "Chapter 6: 3D Touch"
```

# Chapter 6: 3D Touch

With the release of the iPhone 6s and 6s Plus, Apple surprised everybody with the addition of a feature that could very well redefine the way users interact with their devices: 3D Touch.

An extension of the Force Touch technology, 3D Touch builds on the same theme as Apple Watch and the sleek new MacBook trackpads. It's such an elegant, simple interface that you almost have to wonder what took so long. 

How it works: When you're using an iPhone 6s or 6s Plus, you simply press "deeper" into the display to trigger a range of extra functionality. It's more than clever coding though. At the hardware level, advanced sensors detect the _microscopic_ changes in distance between the iPhone's cover glass and its backlight.

3D Touch enables new ways to quickly preview content, smooth access to multitasking, and it can even be used to turn your iPhone's keyboard into a trackpad!

You're probably used to Apple dangling sweet new features in front of you without letting you play, almost as if to tease you. 3D Touch is different though—third-party developers get to utilize it at launch-time through a set of three APIs:

+ `UITouch` now has a `force` property that tells you how hard the user is pressing.
+ `UIViewController` has been extended with a set of APIs that allow you to present a preview of a new view controller — a **peek** — when the user presses on a specified view, and then **pop** it open to display the full monty after a deeper press.
+ `UIApplicationShortcutItem` is a new class you can use to add quick actions to your application's home screen icon.

You'll implement each of these APIs in turn to add an extra dimension to a sample app. Strap in, it's going to be a multi-dimensional ride!

> **Note:** Although Apple released this set of APIs, it _hasn't yet_ provided any way of testing them in the simulator. Unfortunately, unless you're lucky enough to own or have access to an iPhone 6s or 6s Plus, you won't be able to experience the functionality for yourself. But who can resist the temptation of a new device? You now have the perfect excuse to go get a shiny new iPhone! Don't worry, we'll wait right here. :]

## Getting started

In this chapter, you'll add 3D Touch to a cool little sketching app called Doodles that lets you draw, save and share simple sketches.

Find the starter files for this chapter and open up **Doodles.xcodeproj**. Build and run to see it in action.

![width=100%](images/01-doodles.png)

The first screen shows a list of saved doodles. The app comes with a few sample doodles, showcasing some incredible artistic skills – yeah, yeah, don't give up my day job, I know. 

Tap on any row to see the full sketch in all its glory. When you're viewing a doodle, you can tap the share button to bring up the share sheet.

Head back to the list view, and tap the **+** button in the top right to create masterpieces of your own. Simply sketch in the blank area and tap **Save** when you're done. 

Because this app is just a demo and not intended to be your new sketchpad, the sample app won't save your doodles between launches. So go ahead, draw _anything_ you want.

The code behind the app is pretty straightforward. Take a look at the project in Xcode to familiarize yourself.

![bordered height=30%](images/02-project-structure.png)

Here are the highlights:

+ **Doodle.swift** contains the model for a doodle, including the sample content. 
+ **Canvas.swift** contains the custom `UIView` that allows you to draw your doodle on the screen.
+ **DoodlesViewController.swift** contains the view controller that displays a list of all of your doodles.
+ **DoodleDetailViewController.swift**  contains the view controller that displays a single doodle.
+ **NewDoodleViewController.swift** contains the view controller in which you create a new doodle.

## UITouch force

It'd be great if you could add some more artistic flair to your drawings, and 3D Touch opens up a range of possibilities to satisfy your inner Van Gogh. 

`UITouch` has a new `force` property. It's a `CGFloat` ranging from 0 to the value of `UITouch`'s other new property `maximumPossibleForce`. A value of 1.0 represents the force of an average touch, and `maximumPossibleForce` has a value that ensures that the `force` property has a wide dynamic range.

You'll use the force — of the user's touch, that is — to make your sketches pressure sensitive. The harder you press, the thicker the line will be!

In Xcode, open up **Canvas.swift**. Find `addLineFromPoint(_:toPoint:)`. This method adds a line to the drawing based on the points passed into it. 

Change the method definition to:

```swift
private func addLineFromPoint(from: CGPoint, 
  toPoint: CGPoint, withForce force: CGFloat = 1) {
```

Here you're adding a `force` parameter with a default value of 1. In the body of this method, find the following line:

    CGContextSetLineWidth(cxt, strokeWidth)

And replace it with:

    CGContextSetLineWidth(cxt, force * strokeWidth)

Now the `force` parameter is multiplied by `strokeWidth` to make the line thicker or thinner depending on the force. At the moment a default of 1 is all that's being passed, so you need to change that. 

Find `touchesMoved(_:withEvent:)`, and replace the call to `addLineFromPoint(_:toPoint:)` with the following code:

```swift
if traitCollection.forceTouchCapability == .Available {
  addLineFromPoint(touch.previousLocationInView(self),
    toPoint: touch.locationInView(self), withForce: touch.force)
} else {
  addLineFromPoint(touch.previousLocationInView(self),
    toPoint: touch.locationInView(self))
}
```

Here you're checking to see if force touch is available, and if so, passing the touch's force into the method you just modified. If force touch is unavailable, the value of the `force` property is `0`, rather than the `1` you might expect.

Build and run the app on a device that supports 3D Touch. Tap the **+** button in the top right, and start sketching! You should see the width of the line change as you vary the pressure you apply to the screen.

![iPhone bordered](images/03-touch-force.png)

## Peeking and popping

Next up, it's time to take a _peek_ at the new `UIViewController` preview APIs. 

On a 3D Touch enabled device, your view controllers can now respond to different touch pressures. From the users' perspective, a couple of things happen as they press more deeply:

1. First, if the view they're pressing has a preview available, it'll stay in focus while the rest of the view controller's views begin to blur.
2. Then, as the user presses deeper, a preview of the selected content pops up in the center of the screen. This is called a '_peek_'. If the user lifts their finger now, the peek will be dismissed. Alternatively, if the user swipes upwards, the preview can present a number of preview actions – typically actions like delete or share. Finally, if the user presses even more deeply, then...
3. **Pop!** The preview will open and the user will be navigated to the full content. 

Here's an example of each of these stages in the built-in Mail app:

![width=100%](images/04-peek-and-pop.png)

You'll use the peek and pop APIs to let users preview doodles from the list. By the time you're finished, the user will be able to lightly press a drawing in the doodles list to see a preview, and then press deeper to pop it open.

Open up **DoodlesViewController.swift** and add the following to the end of `viewDidLoad()`:

```swift
if traitCollection.forceTouchCapability == .Available {
  registerForPreviewingWithDelegate(self, sourceView: view)
}
```
 
Just as you did when using `force` from  `UITouch`, you first check whether 3D Touch is actually available for use on this device. Then you call the new `registerForPreviewingWithDelegate(_:sourceView:)` method on the `UIViewController` subclass. `sourceView` is the view that will respond to 3D Touch events, so you set it to the view controller's entire view.

But there's one problem — this view controller doesn't implement `UIViewControllerPreviewingDelegate`. So, you need to add an extension to the end of **DoodlesViewController.swift** to make `DoodlesViewController` conform with the protocol:

```swift
extension DoodlesViewController:
  UIViewControllerPreviewingDelegate {
  
  func previewingContext(
    previewingContext: UIViewControllerPreviewing, 
  	viewControllerForLocation location: CGPoint)
    -> UIViewController? {
    
    // peek!
    return nil
  }
  
  func previewingContext(
    previewingContext: UIViewControllerPreviewing, 
  	commitViewController viewControllerToCommit:
    UIViewController) {
    
    // pop!
  }
}
```

A `UIViewControllerPreviewingDelegate` must implement both of these methods. 

The first, `previewingContext(_:viewControllerForLocation:)` is called when the user initiates a _peek_ action, and it gives the delegate an opportunity to return a view controller that contains a preview of relevant content. 

This method has two parameters: 

+ `location` is the location within the view where the 3D Touch is occurring. You might want to use this to determine which part of a view is being touched.
+ `previewingContext` is an instance of `UIViewControllerPreviewing`, which has properties for `sourceView` and `sourceRect`. The `sourceView` is the same one you passed into `registerForPreviewingWithDelegate(_:sourceView:)` earlier, while `sourceRect` defines the area within the source view that stays focus during the initial phase of the peek. 

The second method, `previewingContext(_:commitViewController:)`, is called when the user presses even deeper and initiates a _pop_ action. Here the delegate should present the full content of the popped item. 

The `viewControllerToCommit` parameter that's passed in is the preview view controller that was previously returned from `previewingContext(_:	viewControllerForLocation:)`. Usually, you'd simply present this same view controller modally or by pushing it onto a navigation controller.

To add peek functionality to Doodles, replace the stub implementation for `previewingContext(_:	viewControllerForLocation:)` with the following:

```swift
func previewingContext(
  previewingContext: UIViewControllerPreviewing, 
  viewControllerForLocation location: CGPoint)
  -> UIViewController? {
  
  // 1
  guard let indexPath =
    tableView.indexPathForRowAtPoint(location),
    cell = tableView
      .cellForRowAtIndexPath(indexPath) as? DoodleCell 
    else { return nil }

  // 2    
  let identifier = "DoodleDetailViewController"
  guard let detailVC = storyboard?
    .instantiateViewControllerWithIdentifier(identifier) 
    as? DoodleDetailViewController else { return nil }

  detailVC.doodle = cell.doodle

  // 3
  previewingContext.sourceRect = cell.frame

  // 4
  return detailVC
}
```
    
 Let's take this line by line:
    
1. You want to show a preview for a specific table row when the user presses on it. So, first you use `location` to check whether there's a row at that position. If there is, then you get the associated cell from the table view.
2. You then instantiate a `DoodleDetailViewController` and set it to display the doodle for the selected cell.
3. You set `sourceRect` to the frame of the selected cell, so that the cell will stay in focus and the rest of the table view will blur.
4. Finally, you return the `DoodleDetailViewController` that represents the peeked content.

> **Note:** The preview view controller will display at a default size, but if you want to display it at a different size in your own app, simply override `preferredContentSize` for the preview view controller.

That's all it takes to implement a peek! When the user lightly presses on a row in **DoodlesViewController**, the content except for the pressed row will blur out, indicating that a peek is available. If the user presses a little deeper, an instance of **DoodleDetailViewController** will present as a preview and show the selected doodle.

When the user presses even deeper, you'll want that preview to pop into the full display. So, still in **DoodlesViewController.swift**, replace the stub implementation of `previewingContext(_:commitViewController:)` with the following:

```swift
func previewingContext(
  previewingContext: UIViewControllerPreviewing, 
  commitViewController 
  viewControllerToCommit: UIViewController) {
  
  showViewController(viewControllerToCommit, sender: self)
}
```
 
Wow, simple huh? This method is called when the system wants to pop open, or _commit_, a preview. It hands you the `previewingContext` that you had access to in `previewingContext(_:	viewControllerForLocation:)`, as well as the view controller that you returned from it.
 
In this situation, you simply want to push the **DoodleDetailViewController** onto the navigation stack, so you can just call `showViewController(_:sender:)` to display it.

Build and run the app on your device. Press lightly on a row in the list of doodles, and then slowly press more deeply.

![width=100%](images/05-doodle-peek.png)

Peek.... pop!

> **Note:** In addition to being able to implement peek and pop in your own view controllers, `UIWebView` and `WKWebView` have some automatic peek and pop behaviour built in that you can take advantage of in your own apps. All you need to do is set their new `allowsLinkPreview` property to `true`, and you'll be able to peek into links.
>
> Even better: iOS 9's new `SFSafariViewController` supports peek and pop by default. No configuration required!


### Preview actions

You've just implemented some awesome functionality with barely any coding, but the fun doesn't stop here! A view controller can also present some useful quick actions while in the peek state. 

Open up **DoodleDetailViewController.swift** and add a property at the top of the class to store a reference to `DoodlesViewController`:

    weak var doodlesViewController: DoodlesViewController?

Then add the following method to the bottom of the class, below `presentActivityViewController()`:

```swift
override func previewActionItems() -> [UIPreviewActionItem] {
  // 1
  let shareAction = UIPreviewAction(title: "Share", 
    style: .Default) { 
    (previewAction, viewController) in
    if let doodlesVC = self.doodlesViewController,
      activityViewController = self.activityViewController {
        
      doodlesVC.presentViewController(activityViewController, 
        animated: true, completion: nil)
    }
  }

  // 2
  let deleteAction = UIPreviewAction(title: "Delete", 
    style: .Destructive) { 
    (previewAction, viewController) in
    guard let doodle = self.doodle else { return }
    Doodle.deleteDoodle(doodle)
  
    if let doodlesViewController = self.doodlesViewController {
      doodlesViewController.tableView.reloadData()
    }
  }

  return [shareAction, deleteAction]
}
```
  
This method is called when a view controller is peeked, and it gives the controller an opportunity to present some quick actions. Here, you're creating two types of `UIPreviewAction`:

1. A **share** action, which will present a `UIActivityViewController` that allows the user to share a doodle using the standard iOS share sheet. There's no way to present another view controller directly from the peeked view controller itself, because it's dismissed as soon as you select an action. Instead, you use the `doodlesViewController` property you created earlier and tell _it_ to present the share sheet instead.
2. A **delete** action, which simply deletes the peeked doodle and tells `doodlesViewController` to reload its data.

`UIPreviewAction` is very much like the `UIAlertAction`s you use with `UIAlertController`; it's initialized with a `title`, a `style` (like `.Default`, `.Destructive` or `.Selected`), and a `handler` closure. You can also group `UIPreviewAction`s together using `UIPreviewActionGroup`. 

A group is displayed the same way as a regular action, but it can contain multiple actions. When the user taps on a group, a submenu is opened revealing its child actions.

Finally, open **DoodlesViewController.swift** and find the `previewingContext(_:viewControllerForLocation:)`  you defined earlier. Locate this line:

    detailVC.doodle = cell.doodle
    
And add the following line below it:

    detailVC.doodlesViewController = self
    
This hooks up the `doodlesViewController` property you just created.

Build and run the app. Initiate a peek on one of the doodles, and then slide it upwards to reveal your quick actions. Tap on **Share** to display the share sheet, then cancel out of it. Peek at a doodle once more, slide it upward, and tap **Delete**. Whoosh, the doodle is gone!

![iPhone bordered](images/06-peek-actions.png)

## Home screen quick actions

The final API that 3D Touch introduces is for adding home screen quick actions. These allow you to add some shortcuts to your app's home screen icon. 

When the user presses deeply on your app's icon, a menu will pop up showing any shortcuts that you've defined. Here's an example of Safari and Mail's shortcut menus in iOS 9:

![width=80%](images/07-home-shortcut-examples.png)

Home screen quick actions provide a great way for users to jump straight into a specific activity within your app, and they're super-easy to implement. Each app can display up to four shortcut items, and there are two types of shortcuts you can add:

+ **Static shortcuts:** Static shortcuts are declared in your app's **Info.plist** file, and are available for use as soon as your app has been installed.
+ **Dynamic shortcuts:** Dynamic shortcuts are configured at runtime, and can be added, removed and changed whenever you like. Because they're updated at runtime, users won't see your dynamic shortcuts until your app has run for the first time. 

iOS will display your static shortcuts first, followed by your dynamic shortcuts, provided you have fewer than four static ones.

### Adding a static shortcut

First, you'll add a static shortcut to take users straight to creating a new doodle. In Xcode, click the **Doodles Project** in the **project navigator**, then select the **Doodles target** and click the **Info** tab:

![width=100% bordered](images/08-selecting-info.png)

Add a new **Array** entry to the table, with a key of **UIApplicationShortcutItems**. Add a **Dictionary** to the array, and then add three **Strings** to the dictionary with the following keys and values:

+ **UIApplicationShortcutItemTitle**: New Doodle
+ **UIApplicationShortcutItemType**: com.razeware.Doodles.new
+ **UIApplicationShortcutItemIconType**: UIApplicationShortcutIconTypeAdd

When you've finished, the entry should look like this:

![width=100% bordered](images/09-plist-entry.png)

Each dictionary within the `UIApplicationShortcutItems` array contains the definition for a shortcut item. The one you've just defined has three properties. `UIApplicationShortcutItemTitle`, as you'd expect, declares the title of the item. This one will say "New Doodle". `UIApplicationShortcutItemType` is a unique identifier (typically in reverse-DNS notation) that you'll use to identity the shortcut item in code. Finally, `UIApplicationShortcutItemIconType` declares the built-in icon to use for this entry. You're using the `UIApplicationShortcutIconTypeAdd` icon, which displays a **+** image.


There are a couple of other keys available that you haven't used here:

+ **UIApplicationShortcutItemSubtitle** defines a subtitle to display below the main title.
+ **UIApplicationShortcutItemIconFile** is used to provide a custom icon image.
+ **UIApplicationShortcutItemUserInfo** allows you to provide a custom dictionary containing whatever data you may need.

See the `UIApplicationShortcutItems` documentation ([apple.co/1KX35t4](http://apple.co/1KX35t4)) for full details, including a list of built-in icon types.

Now that you've declared your shortcut item, what happens when somebody taps it? iOS 9 introduces a new `UIApplicationDelegate` method to do just this. 

Open **AppDelegate.swift**, and add the following method below `application(_:didFinishLaunchingWithOptions:)`:

```swift
func application(application: UIApplication, 
  performActionForShortcutItem
  shortcutItem: UIApplicationShortcutItem, 
  completionHandler: (Bool) -> Void) {

  handleShortcutItem(shortcutItem)
  completionHandler(true)
}
```
 
This method gets called when a user selects one of your application shortcuts. Here you're calling `handleShortcutItem(_:)` (which you'll implement in a moment) and then calling `completionHandler`, passing it `true` because you've handled the shortcut item. If for some reason you don't or can't handle a particular shortcut item, you should pass `false` to `completionHandler`.

Now, add this method below the previous one:

```swift 
func handleShortcutItem(
  shortcutItem: UIApplicationShortcutItem) {

  switch shortcutItem.type {
  case "com.razeware.Doodles.new":
    presentNewDoodleViewController()
  default: break
  }
}
```

This code switches on the `type` property of `shortcutItem` that you defined earlier in **Info.plist**. If the type matches the New Doodle shortcut type, then you call `presentNewDoodleViewController()`. Add this method now below `handleShortcutItem(_:)`:

```swift
func presentNewDoodleViewController() {
  let identifier = "NewDoodleNavigationController"
  let doodleViewController = UIStoryboard.mainStoryboard
    .instantiateViewControllerWithIdentifier(identifier)

  window?.rootViewController?
    .presentViewController(doodleViewController, animated: true, 
    completion: nil)
}
```

First you instantiate a view controller from the main storyboard with the identifier `NewDoodleNavigationController` — it's a navigation controller that has a `NewDoodleViewController` as its root view controller. Then you present it from the `rootViewController` on the `window`. This will let the user create a new doodle.
    
Time to test it out! Build and run, and then press firmly on the Doodles app icon on your device's home screen. You'll see your "New Doodle" application shortcut appear. Tap it, and you should land right in a new doodle screen.

![width=45%](images/10-static-shortcut.png)

> **Note:** When an app _launches_ after the user taps a shortcut, as opposed to being opened from the background, the `launchOptions` dictionary of `application(_:didFinishLaunchingWithOptions:)` will contain the `UIApplicationShortcutItem` in question as the value for the key `UIApplicationLaunchOptionsShortcutItemKey`. There are a few caveats to bear in mind when handling your shortcut items in this method, so be sure to check out the full documentation for more information: ([apple.co/1P04D7q](http://apple.co/1P04D7q)).

### Adding a dynamic shortcut

You've just seen how to add a static shortcut to your **Info.plist**. Now you'll add a _dynamic_ shortcut at runtime, which will allow the user to share their latest doodle right from the home screen. 

Open **Doodle.swift** and add this static method to the end of the struct:

```swift
static func configureDynamicShortcuts() {
  if let mostRecentDoodle = Doodle.sortedDoodles.first {
    let shortcutType = "com.razeware.Doodles.share"
    let shortcutItem = UIApplicationShortcutItem(
      type: shortcutType,
      localizedTitle: "Share Latest Doodle",
      localizedSubtitle: mostRecentDoodle.name,
      icon: UIApplicationShortcutIcon(type: .Share),
      userInfo: nil)
    UIApplication.sharedApplication().shortcutItems =
      [ shortcutItem ]
  } else {
    UIApplication.sharedApplication().shortcutItems = []
  }
}
```

Just like you created a `UIApplicationShortcutItem` definition in Info.plist, here you're creating a `UIApplicationShortcutItem` in code. 

The above properties and settings should look quite familiar: you set a `type` to a unique reverse-DNS string, a title and a subtitle, and a built-in icon. You've set the subtitle to the most recent doodle's name, so it'll display right in the shortcut menu.

To use programmatically-created shortcut items, you simply add them to the `UIApplication`'s `shortcutItems` property. You can update this collection at any time to ensure that your app presents useful shortcut items, depending on its current state.

Still in **Doodle.swift**, add the following line to the end of `addDoodle(_:)` ***and*** `deleteDoodle(_:)`:

    Doodle.configureDynamicShortcuts()

Whenever a doodle is added or removed, this will update your dynamic shortcut item, so that the subtitle always reflects the most recent doodle.

Open **AppDelegate.swift**, and add the same line to `application(_:didFinishLaunchingWithOptions:)`, just above `return true`:

    Doodle.configureDynamicShortcuts() 
    
Next, replace `handleShortcutItem(_:)` with the following implementation:

```swift
func handleShortcutItem(
  shortcutItem: UIApplicationShortcutItem) {

  switch shortcutItem.type {
  case "com.razeware.Doodles.new":
    presentNewDoodleViewController()
  case "com.razeware.Doodles.share":
    shareMostRecentDoodle()
  default: break
  }
}
```

This adds an extra case to handle the new shortcut item type, and calls `shareMostRecentDoodle()`. Add an implementation for that method now, below `presentNewDoodleViewController()`:

```swift
func shareMostRecentDoodle() {
  guard let mostRecentDoodle = Doodle.sortedDoodles.first,
    navigationController = window?.rootViewController as?
    UINavigationController
    else { return }
  let identifier = "DoodleDetailViewController"
  let doodleViewController = UIStoryboard.mainStoryboard
    .instantiateViewControllerWithIdentifier(identifier) as!
    DoodleDetailViewController
                
  doodleViewController.doodle = mostRecentDoodle
  doodleViewController.shareDoodle = true
  navigationController
    .pushViewController(doodleViewController, animated: true)
}
```

This method instantiates a new `DoodleDetailViewController` to display the most recent doodle, sets its `doodle` property and tells it to display a share sheet. Finally, it pushes it onto the navigation stack.

Build and run the app, and then return to the home screen. Press deeply on the app's icon to bring up the quick actions menu again. 

This time, you should see two items: _New Doodle_, and _Share Latest Doodle_. Tap **Share Latest Doodle**, and you should be taken into the app. The most recent doodle, in this case House, will display and then the system share sheet will appear. 

Cancel out of the share sheet, tap **Doodles** in the top left to return to the list of doodles, and then tap **+** in the top right to create a new doodle. Draw a picture of a tree and tap **Save**. Name your new drawing _Tree_. 

Press the home button to return to the home screen, and once again press deeply on the app icon to show the quick actions menu. You should see that the **Share Latest Doodle** now has the subtitle _Tree_, because it's the most recent doodle. Tap it, and you'll be able to share your latest masterpiece with the world.

![width=45%](images/11-dynamic-shortcut.png)

## Where to go from here?

Congratulations! You've reached the end of this chapter, and you've added some really cool features to the Doodles app. 3D Touch is an incredible new interaction method. With the powerful new `force` property in `UITouch`, UI candy in the form of peeks and pops, _and_ home screen quick actions, you have a multitude of ways to put it to use in your own apps. 

May the Force (Touch) be with you!

One of the most important things to note is that 3D touch isn't available to all users, and it isn't as discoverable as icons and labels. 

Hence, you can't have parts of your app that are only accessible via 3D touch, and shortcuts from the app icon aren't a substitute for sensible in-app navigation! 

If you want to read more about 3D Touch, you should definitely check out Apple's "Adopting 3D Touch on iPhone" ([apple.co/1JxalGK](http://apple.co/1JxalGK)) documentation. It's a great resource for the API and it contains a top-level overview, links to detailed documentation, and sample code.
