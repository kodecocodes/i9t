```metadata
author: James Frost
number: 15
title: 3D Touch
```

# Chapter X: 3D Touch

With the release of the iPhone 6s and 6s Plus, Apple added a surprise new feature that looks set to redefine the way users interact with their devices: 3D Touch.

3D Touch is an extension of the Force Touch technology that Apple introduced in the Apple Watch and MacBook trackpads. When you're using an iPhone 6s or 6s Plus, you can simply press 'deeper' into the display to trigger a range of extra functionality in iOS. At the hardware level, advanced sensors detect the microscopic changes in distance between the iPhone's cover glass and its backlight. Pretty impressive!

3D Touch enables new ways of quickly previewing content, smoother access to multitasking, and can even be used to turn your iPhone's keyboard into a trackpad!

And the best thing is that Apple are opening 3D Touch up to third party developers through a set of three APIs:

+ `UITouch` now has a `force` property which tells you how hard the user is pressing.
+ `UIViewController` now has a set of 'previewing APIs', allowing you to present a preview (a 'peek') to the user and then 'pop' it open when they press deeper.
+ `UIApplicationShortcutItem` can be used to add quick actions to your application's home screen icon.

You'll be implementing all of these APIs in this tutorial. So hold tight, it's going to be a wild ride!

> **Note:** Whilst Apple released this great set of APIs, they _didn't_ provide any way of testing them in the Simulator. Unfortunately, unless you're lucky enough to own or have access to an iPhone 6s or 6s Plus, you won't be able to try out the functionality you'll be implementing.

## Getting started

In this tutorial, you'll be adding 3D Touch to a neat little sketching app called Doodles. Doodles lets you draw simple sketches, save them, and share them with your friends.

Find the starter files for this chapter, and open up **Doodles.xcodeproj**. Build and run the app to see it in action.

![iPhone bordered](images/01-doodles.png)

The first screen shows a list of saved doodles. The app comes a few sample doodles, showcasing some incredible artistic skills. Tap on any row to see the full sketch in all its glory. When you're viewing a doodle, you can tap the share button to bring up the system share sheet.

Head back to the list view, and tap on the **+** button in the top right. This is where you can create masterpieces of your own! Simply sketch in the blank area and tap **Save** when you're done.

The code behind the app is pretty straightforward. Take a look at the project in Xcode to familiarize yourself.

+ **Doodle.swift** contains the model for a doodle, including the sample content. The app doesn't persist any changes you make between launches.
+ **DoodlesViewController.swift** contains the view controller that displays a list of all of your doodles.
+ **DoodleViewController.swift**  contains the view controller that displays a single doodle.
+ **AddDoodleViewController.swift**  contains the view controller in which you create a new doodle.
+ Finally, **Canvas.swift** contains the custom `UIView` that allows you to sketch on the screen and draws a line wherever you touch.

## UITouch force

The doodles you can create in the app currently are very nice, but it'd be great if you could add some more artistic flair to them. In this section, you'll use UITouch's new `force` property to make your sketches pressure sensitive. The harder you press, the thicker the line will be!

In Xcode, open up **Canvas.swift**. Find `addLineFromPoint(_:toPoint:)`. This method adds a line to the drawing based on the points passed into it. Change the method definition to:

    private func addLineFromPoint(from: CGPoint, toPoint: CGPoint, 
      withForce force: CGFloat = 1) {

Here you've added a `force` parameter with a default value of 1. Now, in the body of this method, find the following line:

    CGContextSetLineWidth(cxt, strokeWidth)

And replace it with:

    if traitCollection.forceTouchCapability == .Available {
      let magnitude = max(force, strokeWidth)
      CGContextSetLineWidth(cxt, magnitude)
    } else {
      CGContextSetLineWidth(cxt, strokeWidth)
    }

The code above first checks the canvas view's `traitCollection`'s `forceTouchCapability` to see whether 3D Touch is available for use on this device. If it is, then the value of the `force` parameter is used as the line's width, up to a maximum of `strokeWidth`. If 3D Touch isn't available, then the `strokeWidth` is used unmodified.

Finally, near the top of the file, find `touchesMoved(_:withEvent:)`, and replace the call to `addLineFromPoint(_:toPoint:withForce:)`:

    addLineFromPoint(touch.previousLocationInView(self), 
      toPoint: touch.locationInView(self), withForce: touch.force)

`UITouch` now has a `force` property, which HOW DOES THIS WORK. Here, you're passing into the method you just modified so that it's used to calculate the width of the lines in a doodle.

Build and run the app onto a device that supports 3D Touch. Tap the '+' button, and then start sketching! You should see the width of the line change as you vary the pressure you apply to the screen.

![iPhone bordered](images/02-touch-force.png)

## Peeking and popping

/// THIS IS TAKEN FROM APPLE'S DOCUMENTATION, WILL WORK IT IN SOMEWHERE:

As the user presses more deeply, interaction proceeds through three phases:

Indication that content preview is available
Display of the preview—known as a peek—with options to act on it directly—known as peek quick actions
Optional navigation to the view shown in the preview—known as a pop
When you employ peek and pop, the system determines the pressures at which one phase transitions to the next. 

/// 

Next up, it's time to take a _peek_ at the new UIViewController preview APIs. You'll _pop_ with excitement! TODO: this is a bit shit

Next up, you'll allow users to preview doodles using the new _peek_ and _pop_ APIs that `UIViewController` provides. When you've finished, the user will be able to lightly press a doodle in the doodles list to see a preview (a _peek_), and then press deeper to "_pop_" it open.

Open up **DoodlesViewController.swift** and add the following code to the end of `viewDidLoad()`:

    if traitCollection.forceTouchCapability != .Available {
      registerForPreviewingWithDelegate(self, sourceView: view)
    }
 
First, as you did when using `UITouch`'s `force` property, you check whether 3D Touch is actually available for use on this device. Then you call the new `registerForPreviewingWithDelegate(_:sourceView:)` method on `UIViewController`.  TODO: explanation of this method

But there's one problem – this view controller isn't doesn't implement `UIViewControllerPreviewingDelegate`! Time to fix that. Add an extension to the end of **DoodlesViewController.swift** to make `DoodlesViewController` conform to the protocol:

    extension DoodlesViewController: UIViewControllerPreviewingDelegate {
      func previewingContext(previewingContext: UIViewControllerPreviewing, 
      	viewControllerForLocation location: CGPoint) -> UIViewController? {
        // peek!
        return nil
      }
      
      func previewingContext(previewingContext: UIViewControllerPreviewing, 
      	commitViewController viewControllerToCommit: UIViewController) {
        // pop!
      }
    }

A `UIViewControllerPreviewingDelegate` must implement both of these methods. 

The first, `previewingContext(_:viewControllerForLocation:)` is called when the user initiates a _peek_ action. The `previewingContext` that's passed into this method contains a `sourceView` and a `sourceRect`, which represent the view that the user is pressing on to try and peek. If the view is 'peekable', then the delegate should return a view controller from this method which represents a preview of the peeked item.

The second method, `previewingContext(_:commitViewController:)` is called when the user presses deeper and initiates a _pop_ action. In this method, the delegate should present the full content of the popped item. 

The `viewControllerToCommit` parameter that's passed in is the view controller that was used for peeking (that was previously returned from `previewingContext(_:	viewControllerForLocation:)`). Usually, you'll simply want to present this same view controller modally or by pushing it onto a navigation controller.

To add peek functionality, replace the stub implementation for `previewingContext(_:	viewControllerForLocation:)`  with the following:

    func previewingContext(previewingContext: UIViewControllerPreviewing, 
      viewControllerForLocation location: CGPoint) -> UIViewController? {
        // 1
        guard let indexPath = tableView.indexPathForRowAtPoint(location),
          cell = tableView.cellForRowAtIndexPath(indexPath) as? DoodleCell 
          else {
            return nil
          }
      
         // 2
        guard let detailViewController = storyboard?
          .instantiateViewControllerWithIdentifier("DoodleViewController") 
          as? DoodleViewController else { return nil }
        detailViewController.doodle = cell.doodle

        // 3
        previewingContext.sourceRect = cell.frame
      
        // 4
        return detailViewController
    }
    
 Let's take this line by line:
    
   1. You want to show a peek for a specific table row when the user presses on it. So first you use the passed in `location` value and check whether there's a row at that position. If there is, you get the associated cell from the table view.
   2. You then instantiate a `DoodleViewController` and set it to display the doodle for the selected cell.
   3. The `previewingContext` contains a `sourceRect` property, which can be used to specify a preview indication area. The rectangle will remain sharp whilst the user presses, whilst the rest of the the `sourceView` will be blurred out. Here you set `sourceRect` to the frame of the selected cell.
   4. Finally, you return the `DoodleViewController` that represents the peek.

> **Note:** The peeked view controller will be displayed at a default size. If you want to display it at a different size in your own app, you can simply override `preferredContentSize` in your view controller.

So that's peek done. When the user lightly presses on a row in **DoodlesViewController** the rest of the content will blur out (except for the pressed row) indicating that a peek is available. If the user presses a little deeper, an instance of **DoodleViewController** will be presented as a peek, showing the selected Doodle.

If the user presses even deeper, you'll want that preview to **pop** open into the full display. So, still in **DoodlesViewController.swift**, replace the stub implementation of `previewingContext(_:commitViewController:)` with the following:

    func previewingContext(previewingContext: UIViewControllerPreviewing, 
      commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
  }
 
Wow, simple huh? This method is called when the system wants to pop open a peek preview. It hands you the `previewingContext` that you had access to in `previewingContext(_:	viewControllerForLocation:)`, as well as the view controller that you returned from it.
 
In this situation, you simply want to push the **DoodleViewController** onto the navigation stack, so you can just call `showViewController(_:sender:)` to display it.

Build and run the app on your device. Press lightly on a row in the list of doodles, and then slowly press harder and harder.

![width=100%](images/03-peek-and-pop.png)

Peek.... pop!

> **Note:** In addition to being able to implement peek and pop in your own view controllers, `UIWebView` and `WKWebView` have some automatic peek and pop behaviour built in that you can take advantage of in your own apps. All you need to do is set their new `allowsLinkPreview` property to `true`, and you'll be able to peek into links. Cool stuff!

### Preview actions

You've just implemented some crazy awesome functionality with very little code. But it doesn't stop there – a view controller can also present some useful quick actions whilst it's being peeked. 

Open up **DoodleViewController.swift** and add a property at the top of the class to store a reference to `doodlesViewController`:

    weak var doodlesViewController: DoodlesViewController?

Then add the following method to the bottom of the class, below `viewDidAppear(_:)`:

    override func previewActionItems() -> [UIPreviewActionItem] {
      // 1
      let shareAction = UIPreviewAction(title: "Share", style: .Default) { (previewAction, viewController) in
        if let doodlesViewController = self.doodlesViewController,
          activityViewController = self.activityViewController {
            doodlesViewController.presentViewController(activityViewController, animated: true, completion: nil)
        }
      }
    
       // 2
      let deleteAction = UIPreviewAction(title: "Delete", style: .Destructive) { (previewAction, viewController) in
        guard let doodle = self.doodle else { return }
        Doodle.deleteDoodle(doodle)
      
        if let doodlesViewController = self.doodlesViewController {
          doodlesViewController.tableView.reloadData()
        }
      }
    
    return [shareAction, deleteAction]
  }
  
This method is called when a view controller is peeked, and gives it an opportunity to present some quick actions. Here, you're creating two of these `UIPreviewAction`s:

1. A **share** action, which will present a `UIActivityViewController` allowing the user to share a doodle using the standard iOS share sheet. There's no way to present another view controller directly from the peeked view controller itself, as it's dismissed as soon as you select an action. Instead, you use the `doodlesViewController` property you created earlier to tell _it_ to present the share sheet instead.
2. A **delete** action, which simply deletes the peeked doodle and tells `doodlesViewController` to reload its data.

`UIPreviewAction` is very much like a `UIAlertController`'s `UIAlertAction`s; it's initialized with a `title`, a `style` (`.Default`, `.Destructive`, and `.Selected`), and a `handler` closure. You can also group `UIPreviewAction`s together using `UIPreviewActionGroup`. A group is displayed just the same as a regular action, but it can itself contain multiple actions. When the user taps on a group, a submenu is opened revealing its child actions.

Finally, open **DoodlesViewController.swift** and find `previewingContext(_:viewControllerForLocation:)` which you defined earlier. Find this line:

    detailViewController.doodle = cell.doodle
    
And add the following line below it:

    detailViewController.doodlesViewController = self
    
This hooks up the `doodlesViewController` property you just created.

Build and run the app. Initiate a peek on one of the doodles, and then slide it upwards to reveal your quick actions. Tap on **Share** to display the share sheet, then cancel out of it. Peek at a doodle once more, slide it upward, and tap **Delete**. Bam, the doodle is gone!

![iPhone bordered](images/04-peek-actions.png)

## Home Screen Quick Actions

The final API that 3D Touch introduces is for adding "home screen quick actions". These allow you to add some quick shortcuts to your app's home screen icon. When the user presses deeply on your app's icon, a menu will pop up showing any shortcuts that you've defined. Here's an example of Safari and Mail's shortcut menus in iOS 9:

![width=80%](images/05-home-shortcut-examples.png)

Home screen quick actions provide a great way for users to jump straight into a specific activity within your app, and they're super easy to implement. Each app can display up to four shortcut items, and there are two types of shortcut that you can add:

+ **Static shortcuts:** Static shortcuts are declared in your app's **Info.plist** file, and are available for use as soon as your app has been installed.
+ **Dynamic shortcuts:** Dynamic shortcuts are configured at runtime, and can be added, removed, and changed whenever you like. Because they're updated at runtime, users won't see your dynamic shortcuts until your app has been run for the first time. 

iOS will display your static shortcuts first, followed by your dynamic shortcuts – as long as you have less than four static ones.

### Adding a static shortcut

First, you'll add a static shortcut to quickly start a new doodle. In Xcode, click the **Doodles Project** in the **project navigator**, then select the **Doodles target** and click the **Info** tab:

![width=95% bordered](images/06-selecting-info.png)

Add a new **array** entry to the table, with a key of **UIApplicationShortcutItems**. Add a **dictionary** to the array, and then add three **string**s to the dictionary with the following keys and values:

+ **UIApplicationShortcutItemTitle**: New Doodle
+ **UIApplicationShortcutItemType**: com.razeware.Doodles.new
+ **UIApplicationShortcutItemIconType**: UIApplicationShortcutIconTypeAdd

When you've finished, the entry should look like this:

![width=90% bordered](images/07-plist-entry.png)

Each dictionary within the `UIApplicationShortcutItems` array contains the definition for a shortcut item. The one you've just defined has three properties. `UIApplicationShortcutItemTitle`, as you'd expect, declares the title of the item. This one will say "New Doodle". `UIApplicationShortcutItemType` is a unique identifier (typically in reverse-dns notation) that's you'll use to identity the shortcut item in code. Finally, `UIApplicationShortcutItemIconType` declares the built-in icon to use for this entry. Here you've used the "Add" icon, which displays a **+** image.

There are a couple of other keys available which you haven't used here:

+ **UIApplicationShortcutItemSubtitle** defines a subtitle to display below the main title.
+ **UIApplicationShortcutItemIconFile** is used to provide a custom icon image.
+ **UIApplicationShortcutItemUserInfo** allows you to provide a custom dictionary containing whatever data you need.

See the [`UIApplicationShortcutItems` documentation (http://apple.co/1KX35t4)](http://apple.co/1KX35t4) for full details, including a list of the built in icon types.

Now that you've declared your shortcut item, what happens when somebody taps it? iOS 9 introduces a new `UIApplicationDelegate` method, which you'll implement now. Open **AppDelegate.swift**, and add the following method below `application(_:didFinishLaunchingWithOptions:)`:

    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, 
      completionHandler: (Bool) -> Void) {
        handleShortcutItem(shortcutItem)
        completionHandler(true)
    }
 
This method gets called if your app is in the background and a user selects one of your application shortcuts. Here you're calling `handleShortcutItem(_:)` (which you'll implement in a moment) and then calling `completionHandler`, passing it `true` because you've handled the shortcut item.

Now, add this method below the previous one:
 
    func handleShortcutItem(shortcutItem: UIApplicationShortcutItem) {
      switch shortcutItem.type {
        case "com.razeware.Doodles.new":
          presentNewDoodleViewController()
        default: break
      }
    }

This code switches on the `shortcutItem`'s `type` property, which you defined earlier in **Info.plist**. If the type matches the "New Doodle" shortcut type, then you call `presentNewDoodleViewController()`. Now, add this method below `handleShortcutItem(_:)`:

    func presentNewDoodleViewController() {
      let doodleViewController = UIStoryboard.mainStoryboard.instantiateViewControllerWithIdentifier("NewDoodleNavigationController")

      window?.rootViewController?.presentViewController(doodleViewController, animated: true, completion: nil)
    }

First you instantiate a new `NewDoodleNavigationController` from the main storyboard, and then you present it from the `window`'s `rootViewController`. This will let the user create their new doodle.
    
Time to test it out! Build and run, and then press firmly on the Doodles app icon on the home screen. You'll see your "New Doodle" application shortcut appear. Tap it, and you should be launched straight into the new doodle screen.

![width=45%](images/08-static-shortcut.png)

> **Note:** When an app is _launched_ due to a shortcut item being tapped (instead of a backgrounded app being _activated_), the `launchOptions` dictionary of `application(_:didFinishLaunchingWithOptions:)` will contain the `UIApplicationShortcutItem` in question as the value for the key `UIApplicationLaunchOptionsShortcutItemKey`. You don't have to handle ... . TODO: Finish this, return false etc

### Adding a dynamic shortcut

You've just seen how to add a static shortcut to your **Info.plist**. Now you'll add a _dynamic_ shortcut at runtime, which will allow the user to share their latest doodle right from the home screen. 

Open **Doodle.swift** and add this static method to the end of the struct:

    static func configureDynamicShortcuts() {
      if let mostRecentDoodle = Doodle.sortedDoodles.first {
        let shortcutItem = UIApplicationShortcutItem(type: "com.razeware.Doodles.share",
          localizedTitle: "Share Latest Doodle",
          localizedSubtitle: mostRecentDoodle.name,
          icon: UIApplicationShortcutIcon(type: .Share),
          userInfo: nil)
        UIApplication.sharedApplication().shortcutItems = [ shortcutItem ]
      } else {
        UIApplication.sharedApplication().shortcutItems = []
    }

Just like you created a `UIApplicationShortcutItem` definition in your **Info.plist**, here you're creating a `UIApplicationShortcutItem` in code. The properties you're setting should look quite familiar: you set a `type` to a unique reverse-DNS string, a title and a subtitle, and a built-in icon. You've set the subtitle to the most recent doodle's name, so it'll be displayed right in the shortcut menu.

To use programmatically-created shortcut items, you simply add them to the `UIApplication`'s `shortcutItems` property. You can update this collection at any time, to ensure that your app's presenting useful shortcut items depending on its current state.

Still in **Doodle.swift**, add the following line to the end of `addDoodle(_:)` **and** `deleteDoodle(_:)`:

    Doodle.configureDynamicShortcuts()

Whenever a doodle is added or removed, this will update your dynamic shortcut item, so that the subtitle always reflects the most recent doodle.

Open **AppDelegate.swift** and add the same line to `application(_:didFinishLaunchingWithOptions:)`, just above `return true`:

    Doodle.configureDynamicShortcuts() 
    
Next, replace `handleShortcutItem(_:)` with the following implementation:

    func handleShortcutItem(shortcutItem: UIApplicationShortcutItem) {
      switch shortcutItem.type {
        case "com.razeware.Doodles.new:
          presentNewDoodleViewController()
        case "com.razeware.Doodles.share":
          shareMostRecentDoodle()
        default: break
      }
    }

This adds an extra case to handle the new shortcut item type, and calls `shareMostRecentDoodle()`. Add an implementation for that method now, below `presentNewDoodleViewController()`:

    func shareMostRecentDoodle() {
      if let mostRecentDoodle = Doodle.sortedDoodles.first,
        navigationController = window?.rootViewController as? UINavigationController {
          let doodleViewController = UIStoryboard.mainStoryboard.instantiateViewControllerWithIdentifier("DoodleViewController") as! DoodleViewController
          
          doodleViewController.doodle = mostRecentDoodle
          doodleViewController.shareDoodle = true
          
          navigationController.pushViewController(doodleViewController, animated: true)
      }
    }

This method instantiates a new `DoodleViewController` to display the most recent doodle, sets its `doodle` property and tells it to display a share sheet. Finally, it pushes it onto the navigation stack.

Build and run the app, and then return to the home screen. Press deeply on the app's icon to bring up the application shortcuts menu again. This time, you should see two items: New Doodle, and Share Latest Doodle. Tap **Share Latest Doodle**, and you should be taken into the app. The most recent doodle, House, will be displayed and then the system share sheet will appear. 

Cancel out of the share sheet, tap **Doodles** in the top left to return to the list of doodles, and then tap **+** in the top right to create a new doodle. Draw a picture of a tree and tap **Save**. Name your new drawing 'Tree'. Press the home button to return to the home screen, and once again press deeply on the app icon to show the quick actions menu. You should now see that the Share Latest Doodle item now has the subtitle "Tree". Tap it, and you'll be able to share your latest masterpiece with the world.

![width=45%](images/09-dynamic-shortcut.png)

## Where to go from here?

WHERE INDEED.

Here are some useful resources:

* Apple's programming guide and sample code for 3D Touch
* Some other stuff
* This and that
* 