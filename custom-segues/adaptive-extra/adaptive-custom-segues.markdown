With multitasking on the iPad when your app is used in split screen, you will be wanting your app's presented controllers to adapt to their correct state fluidly. Because segues are now retained in memory they can now act as controller for the adapted state.

## Segues are adaptive too

You want to be taking advantage of multitasking on the iPad, and your users could be changing the size of your app at any time. This means that popovers which are generally used for a regular size class could be switching to full screen in a compact size class. The problem is that the user can tap outside a popover to dismiss it, but needs to have a button to dismiss a full screen. You have to present a different view controller depending on the size class.

Because the segue is retained during a popover presentation, the segue can take responsibility for this adaptivity and can substitute the correct view controller for the current size class.

You'll now hook up the Vet Information button on the Animal Detail scene to a popover.

In **Main.storyboard** in the **Animal Detail View Controller** scene ctrl-drag from the **Vet Information button** to the small **Vet Information** Scene. Choose **popover presentation** from the popup menu. 

Run the application on the iPad Air 2 simulator in landscape so that you can test size class changes. 

![bordered width=90%](images/PopoverCompare.png)

Click on the Vet Information button, and you will see a popover. Go into split screen mode with your app taking up half the screen, and the popover will adapt into full screen. This functionality is automatic.

However the popover in the compact split screen turns into a full screen and the user has no way to dismiss it. You'll need to embed the popover in a Navigation Controller for this.

Create a new file called **VetSegue.swift** and subclass UIStoryboardSegue.

Override perform() just as you did for transition animations.

```swift
  override func perform() {
    destinationViewController.presentationController?.delegate = self
    super.perform()
  }
```

Here you set the segue's destinationViewController to look at the segue when the presentation size class changes.

Create an extension in **VetSegue.swift** for the Presentation Controller protocol:

```swift
extension VetSegue: UIAdaptivePresentationControllerDelegate {
}
```

When the size class changes to compact, instead of the segue transtioning directly to the Vet Information screen, you want it to transition to a Navigation Controller. A Navigation Controller has already been created for you on the storyboard, with a name of VetNavigationController.

In the extension create the delegate method that will be called when the size class changes to compact:

```swift
  func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewControllerWithIdentifier("VetNavigationController")
  }
```

The Navigation Controller VetNavigationController, which has the Vet Information Scene embedded, will now be called when the size class changes to compact.

In **Main.storyboard** select the segue between the **Vet Information** button and **Vet Information**. In the **Attributes Inspector** name the Identifier **VetDetail**. Set Segue Class to **VetSegue**.

![bordered height=20%](images/VetSegue.png)

> **Note**: When you click on the Vet Segue in the Storyboard, you will notice that Vet Information does not have a navigation bar. Click on the Navigation Controller to the left of Vet Information and the Navigation Bar and Done button will appear on the Vet Information Scene. The bar is simulated in the storyboard so that you can change the title and other details, but only shows when the view is embedded in the Navigation Controller.

Once you have the Navigation Bar showing on the Vet Information Scene, create the unwind segue from the Done button to Animal Detail View Controller.

In the Document Outline, ctrl-drag from the **Done** button to **Exit** just below the Done button. Select `unwindToAnimalDetailViewController:` from the popup. This method is the unwind place marker you created earlier.

Run the app and try it out, switching between regular and compact sizes. When the app is shown full screen on the iPad, the popover will show, but when you resize the app to half the screen, the navigation controller will show, so that the user has a button to dismiss the Vet Information.

This is really useful that you can switch between different view controllers so easily, but in this app, the information is so small that you could actually show it as a popover on a compact size class as well.

In **VetSegue.swift** comment out the whole `presentationController(_: viewControllerForAdaptivePresentationStyle:)` method you just created as you won't be using it any more.

There's a method available in UIAdaptivePresentationControllerDelate to specify what presentation style to use. Add this to your **VetSegue** extension:

```swift
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    return .None
  }
```

Returning `UIModalPresentationStyle.None` tells the system that for any size device you want it to show a nonmodal presentation style.

Run the application on an iPhone, and see your popover.  In fish terms, that was reely easy!
