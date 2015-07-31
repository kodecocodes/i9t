# Chapter 6: Custom Segues

Ever since Apple introduced storyboards in iOS 5, you've been using segues to transition between scenes. In iOS 7 you could animate these transitions using custom view controller transitions. Now in iOS 9 you can completely separate out your transition animation from your view controller code. 

In a small but important change, segues are now retained during modal or popover presentation of a scene. In other words, segues are created at the start of presenting a new scene and held in memory until the presented scene view controller is dismissed.

In effect, this means that you can move all transition animation and adaptivity code into a segue class. This segue can then be reused in any storyboard. When the modal scene is dismissed the unwind transition will use the current segue transition.

If you decide to change the appearance of the segue transition, you just change the segue in the storyboard to another one in your segue repertoire. This will immediately change the presenting and unwinding transition animations.

There's another benefit too. With multitasking on the iPad when your app is used in split screen, you will be wanting your app's presented controllers to adapt to their correct state fluidly. Because segues are now retained in memory they can now act as controller for the adapted state.

In this chapter you will discover how to create your own library of custom segues. You'll find out how to:

* Create a segue
* Animate the segue
* Make your segue reusable within navigation and tab controllers
* Adapt between different size classes

## Getting Started

The app you will be updating today is a pet minding app called **PamperedPets**. It's a very simple app so far, with just a list of pets to be minded and details about each one. 


![iPhone](images/PamperedPets.png)

Explore your starter project and see how it works. When you run the app, you will see a single scene which shows the photo, address and feeding instructions for a single pet, a goldfish. There is also a button for Vet information that currently doesn't work. You'll be creating a popover for that later on.

Have a look at **Main.storyboard**. There are a number of scenes that have been created for you, but initially the Animal Detail scene and the Animal Photo scene are the scenes that you'll be working with. 

When you've finished this chapter, your app will show a list of pets to be minded. You will be able to select a pet and that pet's details will be displayed.

![bordered width=90%](images/Storyboard.png)

The app is very simple, but the animated transitions that you will create will raise your app from lackluster to rock-star!

And to get you hooked there may be some subtle fish jokes before you fin-ish :].

## What are Segues?

As you have learned from What's New in Storyboards in the previous chapter, segues describe transitions between scenes and are indicated by arrows between the view controller scenes. Segue types can be:

* **Show** - this segue presents into a master view controller, such as a navigation controller.
* **Show Detail** - presents into the detail, such as in a split view.
* **Present Modally** - presents a scene on top of the current scene.
* **Popover** - presents as a popover on the iPad or full screen on the iPhone.

> **Note**: Relationships between, for example, a navigation controller and its embedded view controller, are also shown on the storyboard as arrows but these are not segues that can be customized.

Custom segues have been around for a while, but previously, a segue was *either* modal/popover *or* custom. Now you can use the underlying segue type instead of having to define the segue from scratch.

In this chapter you will be customizing only Modal and Popover transitions. 

## A Simple Segue

You will now create the basic modal segue which you will later customize. When the user taps the photo in the AnimalDetailViewController scene, the AnimalPhotoViewController scene will be presented as a modal controller, showing a larger photo. 

There are two main parts of a segue.

1. Setting up the segue. `prepareForSegue(_:sender:)` is performed when the segue is activated. This is where you set up the destination view controller with the necessary data.
2. Performing the destination controller's transition animation. Initially you will use the default transition, but shortly you will customize that.

First in **Main.storyboard**, select the **Animal Detail View Controller** scene. Drag a **Tap Gesture Recognizer** from the Object Library onto the **Image View** photo of Bubbles the fish. This will hook up the tap gesture with that image view.

In the Document Outline ctrl-drag from this **Tap Gesture Recognizer** to **Animal Photo View Controller**. Choose **present modally** from the popup menu. 

That's all it takes to define a segue. Now you will name the segue and set up AnimalPhotoViewController so that it shows the correct photo.

Select the segue arrow between the two scenes **Animal Detail View Controller** and **Animal Photo View Controller**, and in the **Attributes Inspector** give the segue the Identifier **PhotoDetail**. 

![bordered height=20%](images/PhotoDetailSegue.png)

In **AnimalDetailViewController.swift** create `prepareForSegue(_:sender:)` to set up the destination controller data:

```swift
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "PhotoDetail" {
      let controller = segue.destinationViewController as! AnimalPhotoViewController
      controller.image = imageView.image
    }
  }
```

Here you give the destination controller, in this case AnimalPhotoViewController, the image that it will display.

Run the app and tap the photo. The larger image will slide up the screen. There is currently no way for the user to close this screen. So you will now create an unwind segue.

In **AnimalDetailViewController.swift** add this method:

```swift
  @IBAction func unwindToAnimalDetailViewController(segue:UIStoryboardSegue) {
	//placeholder for unwind segue
  }
```

This method won't contain any code. Any method with a signature of `@IBAction func methodName(segue:UIStoryboardSegue)` is considered by the system to be a marker for a Storyboard segue to unwind to.

In **Main.storyboard** select the **Animal Photo View Controller** scene. Drag a **Tap Gesture Recognizer** from the Object Library onto **Animal Photo View**. 

In the Document Outline ctrl-drag from this new **Tap Gesture Recognizer** to **Exit** (just above the Tap Gesture Recognizer). Select **unwindToAnimalDetailViewController** from the popup menu.

Run the app again, and tap the photo. The larger photo will transition in by sliding up the screen, and then you can tap the larger photo to unwind back to the first screen.

Let's dissect what's happened here. When you tap the photo the tap gesture recognizer initiates a Modal segue from AnimalDetailViewController to AnimalPhotoViewController. AnimalDetailViewController is the **source view controller**. AnimalPhotoViewController is the **destination view controller**. The segue holds a reference to both the source view controller and the destination view controller. 

Behind the scenes the segue sets the transitioning delegate of the destination view controller to the transition of choice. In this case the default transition - Cover Vertical. 

The source view controller in `prepareForSegue(_:sender:)` sets up the data for the destination view controller.

Control is turned over to the destination controller. The destination controller invokes its transition delegate, so the Cover Vertical transition animation happens.

That's the basics of what happens during a segue. Now that your segue is working correctly you are now going to customize it in a segue subclass.

## Segues from your Custom Segue Library

Because the segue is now retained throughout the entire duration of a modal or popover presentation, it's really easy to change segues from your library without having to touch your UIViewController code. The unwind segue for dismissing can be also set by the segue.

The starter app contains a pre-made custom segue called DropSegue so that you can see how easy it is to change segues. In **Main.storyboard** select the **PhotoDetail** segue. Change **Segue Class** to **DropSegue**. 

![bordered height=20%](images/DropSegue.png)

Run the app and tap the photo. Both the segue transition animation and the unwind transition animation have completely changed and you didn't have to change a single line of code. There's also a FadeSegue included in the starter project, so you can try this one as well if you like.

Once you have built up your own library of custom segues, all you will have to do is select the relevant segue in the storyboard and your transition animation work is done!

## Create a Custom Segue

You'll now create your own custom segue to replace that Drop segue. You'll create a Scale transition animation, where the fish photo will scale in on presentation. *Fish - scale - :]!*

The hard part about all this is the terminology. You will be using protocols with very long names, which can be quite daunting. 

These are the protocols that you will be encountering. 

**UIViewControllerTransitioningDelegate** - the custom segue will conform to this protocol to specify the animator objects to be performed on presentation and on dismissal.

**UIViewControllerAnimatedTransitioning** - the animator objects will conform to this to describe the animations.

**UIViewControllerContextTransitioning** - the animator objects will be passed a context object for the transition. This context holds details about the presenting and presented controllers and views.

If you're floundering, don't worry if you don't understand them just yet - when you have used them a few times they will become clear. 

Before creating your segue, here's an overview of the code that you will be writing in this section. In general terms these are the steps you will do to create every animated segue:

1. Subclass `UIStoryboardSegue` and set the segue as the destination controller's transitioning delegate in perform()
2. Create the presenting and dismissing animator classes conforming to `UIViewControllerAnimatedTransitioning`
3. Define the duration and animation in the animators.
4. Tell the segue what animator class to use for presenting and dismissal
5. Use the segue in the storyboard

Each of these steps will be further explained as you do them.

### 1 - Subclass `UIStoryboardSegue`

You will set the destination controller's transition delegate to your segue subclass so that you can use your scale animation instead of the default Vertical Cover animation.

Create a new file called **ScaleSegue.swift** that subclasses **UIStoryboardSegue**.

Change the class definition to include the transition delegate protocol:

    class ScaleSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {

Override the segue's perform() method:

```swift
  override func perform() {
    destinationViewController.transitioningDelegate = self
    super.perform()
  }
```

Here you set the destination view controller's transitioning delegate so that the segue will take control of transition animations.

In previous iOS versions, you might have put the transition animation in perform(), but now the animation is decoupled from the segue by using this transitioning delegate. If you are using a Modal or Popover segue as you are in this example, then you must override super's `perform()` so that the framework can take care of the presentation.

The transitioning protocol allows the segue to override both the presenting and dismissing animations. After you have created the animator class, you will return to the ScaleSegue class to point to those animations. 

### 2 - Create the Animator

> **Note**: I find it easier to keep the animators in the same file as the segue because they are usually closely related, but you can separate the segue and the animators by moving the animators into their own file.

Add a new animator class at the end of **ScaleSegue.swift**

```swift
class ScalePresentAnimator:NSObject, UIViewControllerAnimatedTransitioning {

}
```

ScalePresentAnimator will be used for presenting the modal view controller. You will create a dismissing animator later, but for now the segue will by default use the current Vertical Cover transition.

### 3 - Define the animation

ScalePresentAnimator conforms to UIViewControllerAnimatedTransitioning. This protocol requires that you specify both the transition duration and the transition animation.

First specify how long the animation will take to run. Add this method to the ScalePresentAnimator class:

```swift
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 2.0
  }
```

Most transitions have a duration of about 0.3-0.5 seconds, but this duration of 2 seconds is slow so that you can see the effect clearly.
  
Now for the actual animation. 

```swift
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

    // 1. Get the transition context to- controller and view
    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
    
    // 2. Set up the initial state for the animation
    toView?.frame = .zeroRect
    toView?.layoutIfNeeded()
    
    // 3. Add the to- view to the transition context
    if let toView = toView {
      transitionContext.containerView()?.addSubview(toView)
    }

    // 4. Perform the animation
    let duration = transitionDuration(transitionContext)
    let finalFrame = transitionContext.finalFrameForViewController(toViewController)

    UIView.animateWithDuration(duration, animations: {
      toView?.frame = finalFrame
      toView?.layoutIfNeeded()
      }, completion: {
        finished in
        // 5. Clean up the transition context
        transitionContext.completeTransition(true)
    })
  }
```

Let's go through what's happening here.

1. You extract from the given transitioning context the to- controller and to- view that will be presented. Note that the controller is implicitly unwrapped as there will always be a to-controller, but the view is an optional as there may not be a to-view. You'll see why later.
2. The initial state for the to- view frame is a rectangle of zero size in the top left hand corner of the screen. Whenever you change the frame of a view, you should perform `layoutIfNeeded()` to update the view's constraints.
3. Add the to- view to the transition context. During the transition, you specify what views will be part of that hierarchy. You will generally add the to- view on presentation and the from- view on dismissal.
4. The animation block is a simple animation to animate from the zero rectangle to the final frame that is calculated by the transition context.
5. The transition context must always clean up at the end of the animation.

### 4 - Set the Animator in the Segue

Now you will tell the segue what animator to use during presentation. UIViewControllerTransitioningDelegate methods take care of this.

Inside the **ScaleSegue** class add:

```swift
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ScalePresentAnimator()
  }
```

### 5 - Use the Segue in the Storyboard

You've done all the code necessary, so in **Main.storyboard** locate the **PhotoDetail** segue and change **Segue Class** to **ScaleSegue**. Also Change **Presentation** to **Form Sheet** as this looks better on the iPad.

![bordered height=20%](images/ScaleSegue.png)

Run the application, tap the fish, and watch it scale up from the top left of the screen to full screen on the iPhone and a form sheet on the iPad. Note that when you tap the large photo to dismiss, the regular dismiss animation takes place.

Congratulations! That's your first custom segue! 

You do have some way to go to making the scaling animation look right, but **ScaleSegue.swift** in its current state is a blueprint for all animated segue transitions that you will want to do. Obviously you will add a dismissal animator, different animation code, and sometimes `animateTransition(:_)` will become quite complicated, but the initial steps are just the same.

Take a moment to look at the code of the included example custom segues DropSegue and FadeSegue. Notice how even though the animation differs, the basic structure of both those segues is exactly the same as your ScaleSegue. 

## Passing data to animators

Let's continue to improve your scaling segue. It would be good to have the larger photo smoothly scale up from the smaller one instead of from the corner. But how do you tell the animator object what view it is scaling? There's so much decoupling happening that you don't have a direct reference.

From Apple's Swift book - "A protocol defines a blueprint of methods and properties that suit a particular task". This is a perfect example of a simple task. The Animal Detail can adopt a protocol to set what view is to be scaled, and the animator object can then use that protocol's scaling view without having to know anything else about the view controller. 

In **ScaleSegue.swift** create the protocol:

```swift
protocol ViewScaleable {
  var scaleView:UIView { get }
}
```

Any view controller that wants to present a modal view using this scaling segue must adopt **ViewScaleable** by creating and filling a `scaleView` property.

Declare AnimalDetailViewController to conform to ViewScaleable. Add this extension to the end of **AnimalDetailViewController.swift**:

```swift
extension AnimalDetailViewController: ViewScaleable {
  var scaleView:UIView { return imageView }
}
```

This sets the protocol property so that the view to use for scaling is the imageView with the fish.

Back in **ScaleSegue.swift** at the top of `animateTransition(:_)`, just before declaring:

    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!

add this code:

```swift
let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
```

> **Note**: *Beware!* Make sure that you use the correct key variables. I have spent significant time wondering why my view is incorrect, when I have used UITransitionContextToViewControllerKey instead of UITransitionContextToViewKey! And because of automatic code completion it's also easy to mix up From and To. Also note again that from- controller is here implicitly unwrapped while from- view is optional.

Still in `animateTransition(:_)` replace:

    toView?.frame = .zeroRect

with

```swift
var startFrame = CGRect.zeroRect
if let fromViewController = fromViewController as? ViewScaleable {
  startFrame = fromViewController.scaleView.frame
} else {
        print("Warning: Controller: \(fromViewController) does not conform to ViewScaleable")
}
    toView?.frame = startFrame
```

Instead of starting the to- view frame animation at the top left, you are starting the animation at the from- view controller's `scaleView` frame property.

The cool thing about using the ViewScaleable protocol to pass values, is that the animator object does not need to know anything about the view controller except that it conforms to ViewScaleable.

You'll have a compile warning about fromView not being used. Don't worry - you'll be using it soon.

Run the app. This is starting to look better. 

Just a few more tweaks while we look at how all these views fit together. 

## View Hierarchy

In `animateTransition(:_)` you've been getting the to- view from  `transitionContext.viewForKey(:_)`. You may wonder why you didn't use the destination controller's view. 

The transition context copes with different presentations for the different sizes. The iPad modal form sheet is wrapped in a presentation layer which provides the dimming view and rounds the corners of the form sheet, whereas on the iPhone the modal controller is displayed full screen.

On the iPhone `viewForKey(:_)` returns the same view as the destination controller's view because there is no presentation layer. However on an iPad where the destination controller is wrapped in the presentation layer, if you referred to the destination controller's view, you would be scaling in the destination view and not the presentation layer.

You can see this for yourself; in `animateTranstion(:_)` change:

    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)

to 

    let toView = toViewController.view

and run the app. There will be no change on the iPhone, but on the iPad, the form sheet will scale in from the top left and look very weird.

Make sure you change back the code to use:

    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)

Similarly, the transition context's from- view may differ from the source view controller's view. On an iPhone the transition context's from- view will be the same as the source view controller's view, but on an iPad, the from- view will be nil.

To make your transition look better you can make use of this. On the iPhone the transition would look better if the from- view faded out. However on the iPad the from- view should remain unfaded in the background.

In `animateTransition(_:)` inside the animation block at the end of the method just after:

```swift
      toView?.frame = finalFrame
      toView?.layoutIfNeeded()
```

add this code to fade out the from- view:

      fromView?.alpha = 0.0

And in the completion block just before:

        transitionContext.completeTransition(true)

reset the from- view's alpha with this code:

        fromView?.alpha = 1.0

If you don't reset the alpha, when you dismiss the modal scene, the from- view's alpha will still be 0 and you will just see a black screen.

Run the app on both iPhone and iPad. The iPhone from- view will fade out, but the iPad from- view won't be affected because now `fromView` is nil.

That's it! You have now completed your first custom segue with animated transition! At the end of the chapter, you will be presented with two challenges. The first one will be to create the corresponding dismiss animation for scaling the photo back down to the intial small photo.

## When View Controllers are Embedded

But perhaps you need to mind more than one pet? Now you will set the table view of all pets to be the initial view controller of the application.

In **Main.storyboard**, select the **Navigation Controller** on the very left of the storyboard. In the **Attributes Inspector** tick **Is Initial View Controller**.

![bordered height=20%](images/IsInitialViewController.png)

Run the application. The app will now start with a list of all pets to be minded. Select one, and tap the photo to see your scaling animation.

![height=20%](images/RageFish.png)

The animation doesn't scale from the right place any more! If you look in the debug console, you will see the print warning that you put in your code if the presenting view controller does not conform to ViewScalable.

This is because the view controller is now embedded within a Navigation Controller, which means that the Navigation Controller is now the presenting view controller, not the AnimalDetailViewController.

Fortunately, this is easily fixed. To be reusable in multiple situations, you can find out whether the presenting view controller is a Navigation Controller, and if so, take the Navigation Controller's top view controller as the presenting view controller.

In **ScaleSegue.swift** at the top of `animateTransition(:_)` in the **ScalePresentAnimator** class where it says:

    let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!

change it to:

```swift
    var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
    if let fromNC = fromViewController as? UINavigationController {
      if let controller = fromNC.topViewController {
        fromViewController = controller
      }
    }
```

Here you replace the transition context's from- controller only if it's a Navigation Controller. 

Run the application again, and the scale transition should now work as expected.

Reusable segues need to be aware that they may be used by container controllers. The presenting controller may embedded in a UITabBarController or a UISplitViewController, so you could add similar code to make the segue usable in that situation too.

That wraps up custom segue transition animation. In the Challenge at the end of the chapter, you will get another chance (o-perch-tuna-ty? :]) to try out what you have learned so far by creating another custom segue.

## Segues are adaptive too

You want to be taking advantage of multitasking on the iPad, and your users could be changing the size of your app at any time. This means that popovers which are generally used for a regular size class such as the iPad, could be switching to full screen in a compact size class. The problem is that the user can tap outside a popover to dismiss it, but needs to have a button to dismiss a full screen. You have to present a different view controller depending on the size class.

Because the segue is retained during a popover presentation, the segue can take responsibility for this adaptivity, and can substitute the correct view controller for the current size class.

You'll now hook up the Vet Information button on the Animal Detail scene to a popover.

In **Main.storyboard** in the **Animal Detail View Controller** scene ctrl-drag from the **Vet Information button** to the small **Vet Information** Scene. Choose **popover presentation** from the popup menu. 

Run the application on the Ipad Air 2 simulator in landscape so that you can test size class changes. 

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

Once you have the Navigation Bar showing, create the unwind segue from the Done button to Animal Detail View Controller.

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

## Where To Go From Here?

Retaining segues during a modal/popover presentation is a small change, but one that has huge consequences. Previously view controllers had to know about the transitions they were using, and also the styles they were going to be presented in. 

Now the segue can take full responsibility for that. You can now create any segue with its own transition animation or adaptive style and reuse that segue in all your apps. You can also swap segues to see what looks best for each scene transition without having to update any code.

This chapter has been a basic introduction into the modern method of creating custom segues, but you can find out much more about transitions and adaptivity in our previous books:

* **iOS 7 by Tutorials** - Chapter 3 Custom View Controller Transitions
* **iOS 8 by Tutorials** - Section 1 Adaptive Layout

To be able to create any animation you can think of, I highly recommend our book:

* **iOS Animations by Tutorials**

## Challenge

In this chapter you learned how to set up custom segues and to pass data to them using protocols. 

To help cement your new skills, and become a dab hand at segues, here's a challenge for you.

### Scale Segue Dismissal

Your first challenge is to complete the Scale Segue. You will create the dismiss animator and set the segue to use this dismiss animator.

The code will look very similar to the presenting animator, bearing in mind that the from- view controller is now the modal view controller.

When the modal view controller is being dismissed, `toView` will be the view underneath. On an iPhone, this view has been taken out of the view hierarchy because modal views fully cover the screen. So `toView` needs to be added back in to the view hierarchy so that it will be seen during the animation. This is the code you will use for that:

```swift
    if let fromView = fromView,
      toView = toView {
        transitionContext.containerView()?.insertSubview(toView, belowSubview: fromView)
    }
```

You can find the solution in the sample code included with this chapter.

### A Swipe segue

Your next challenge is to create a completely new reusable segue that uses the default transition to present, but takes an up or down swipe to dismiss. The modal scene should slide away in the direction of the swipe.

Here are some tips:

* The SwipeSegue class will be almost the same as the ScaleSegue class.
* Add a new animator object similar to the Scale dismissal animator that moves the presented frame off either the top of the screen or the bottom of the screen depending on swipe direction.
* Add a new protocol Swipeable that stores the swipe direction
* Add two swipe gestures, one up and one down, to the AnimalPhotoViewController image view. Attach a handler to them to store the swipe direction in the view controller.
* Add an extension to the view controller to give Swipeable that direction
* Change the existing Scale segue to use your new Swipe segue.

As always the solution is in the accompanying sample code.

Happy Segueing :]! 
