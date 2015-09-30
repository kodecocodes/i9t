```metadata
author: Caroline Begbie
number: 9
title: Custom Segues
```

# Chapter 9: Custom Segues

Segues have long been a familiar way to transition between scenes — all the way back to iOS 5. iOS 7 introduced custom view controller transitions to support custom, interactive transitions between views. iOS 9 takes custom transitions even further with custom segues that let you make a complete separation between your transition animation and view controller code.

A small but important change is that segues are now retained during modal or popover presentations of scenes; segues instantiate when presenting a new scene and are held in memory until you dismiss the scene view controller. This means you can move _all_ your transition's animation and adaptivity code into a segue class and reuse that segue in any storyboard. When you dismiss the modal scene, the unwind transition will use the presenting segue's transition.

This chapter will show you how to do the following:

* Create a custom segue
* Animate a custom transition within the segue
* Make your segue reusable within navigation and tab controllers

 You'll need some basic knowledge of storyboards and segues, but if you understood the previous chapter "What's New In Storyboards?", consider yourself well prepared.

$[break]
## Getting started

The sample app for this chapter is **PamperedPets**, a simple pet-minding app that, when complete, will display a list of pets to mind and their details:

![iPhone width=60%](images/PamperedPets.png)

Explore your starter project for a bit to see how it works. Run the app; you'll see a single scene showing the photo, address and feeding instructions for the star of your show: Bubbles the goldfish.

> **Note**: The project will throw a few warnings related to the Storyboard. Don't panic — you'll hook up the disconnected storyboards later in the chapter.

Have a look at **Main.storyboard**; it has a number of pre-created scenes, but you'll start working with the Animal Detail and Animal Photo scenes:

![bordered width=100%](images/Storyboard.png)

There aren't any transitions yet - it's your job to add some awesome transitions and make this app shine. And to get you _hooked_, there may be some fish jokes before you _fin_-ish :].

## What are segues?

Segues describe transitions between scenes; they show up as the arrows between view controller scenes. There are several types of segues:

* **Show**: Pushes a scene from a navigation controller.
* **Show Detail**: Replaces a scene detail when in a `UISplitViewController`.
* **Present Modally**: Presents a scene on top of the current scene.
* **Popover**: Presents a scene as a popover on the iPad or full screen on the iPhone.

> **Note**: Relationships between child view controllers embedded in a container view are also shown as arrows on the storyboard, but these types of segues can't be customized.

Segues have always been *either* modal and popover *or* custom. But in iOS 9, you can use the underlying segue type with your custom segue instead of having to define the segue from scratch:

![bordered width=30%](images/NewSegueInspector.png)

This chapter has you customizing modal segues alone.

## A simple segue

Even though you might have used them before, to fully appreciate how segues work you'll first create a basic modal segue, which you will customize later in this chapter.

You'll invoke the segue when the user taps the photo in the `AnimalDetailViewController` scene. The segue will then present the AnimalPhotoViewController scene as a modal controller showing a larger photo.

There are two main parts to this task:

1. Setting up the segue. `prepareForSegue(_:sender:)` triggers when you activate the segue; you'll set up the destination view controller with the necessary data in this method.
2. Performing the destination controller's transition animation. You'll use the default transition initially, but you'll customize it in just a bit.

In **Main.storyboard**, select the **Animal Detail View Controller** scene. Drag a **Tap Gesture Recognizer** from the Object Library onto the **Pet Photo Thumbnail** of Bubbles the fish. This hooks up the tap gesture to the image view.

Next, __Ctrl-drag__ from the **Tap Gesture Recognizer** in the document outline to **Animal Photo View Controller**. Choose **present modally** from the popup menu.

That's all it takes to define a segue; now you've just to name the segue and set up `AnimalPhotoViewController` so it shows the correct photo.

Select the segue arrow between the **Animal Detail View Controller** and **Animal Photo View Controller** scenes; use the Attributes Inspector to assign it the identifier **PhotoDetail**:

![bordered height=20%](images/PhotoDetailSegue.png)

Override `prepareForSegue(_:sender:)` in **AnimalDetailViewController.swift** to set up the destination controller data as shown below:

```swift
override func prepareForSegue(segue: UIStoryboardSegue,
  sender: AnyObject?) {
    if segue.identifier == "PhotoDetail" {
      let controller = segue.destinationViewController
        as! AnimalPhotoViewController
      controller.image = imageView.image
    }
}
```

Here you give the destination controller — in this case, `AnimalPhotoViewController` — the image to display.

Run the app and tap the photo; you should see a larger photo slide up the screen:

![bordered iPhone width=60%](images/FishDetail.png)

Right now, you have no way to close this screen. You'll need to create a tap gesture to perform an unwind segue.

Add the following method to `AnimalDetailViewController` in **AnimalDetailViewController.swift**:

```swift
@IBAction func unwindToAnimalDetailViewController(
  segue:UIStoryboardSegue) {
    // placeholder for unwind segue
}
```

For a simple unwind segue, this method doesn't require any code. Any method with a signature of `@IBAction func methodName(segue:UIStoryboardSegue)` is considered a marker to which a Storyboard segue can unwind.

In **Main.storyboard**, select the **Animal Photo View Controller** scene. Drag a **Tap Gesture Recognizer** from the Object Library onto **Pet Photo View**. Next, __Ctrl-drag__ from your new **Tap Gesture Recognizer** in the document outline to **Exit**, then select `unwindToAnimalDetailViewController:` from the popup:

![bordered width=60%](images/ExitSegue.png)

$[break]
Run the app again and tap the photo; the larger photo appears and a simple tap unwinds it back to the first scene:

![bordered iPhone](images/DismissFish.png)

Time to dissect what's happened here. When you tap the thumbnail on the detail view, the tap gesture recognizer initiates a modal segue from `AnimalDetailViewController` to `AnimalPhotoViewController`. `AnimalDetailViewController` is the **source view controller**, while `AnimalPhotoViewController` is the **destination view controller**. The segue holds a reference to _both_ the source and destination view controllers:

![bordered width=80%](images/AppFlow.png)

The segue sets the transitioning delegate of the destination view controller behind the scenes and also sets up its presentation according to the current size class.

The source view controller method `prepareForSegue(_:sender:)` sets up the data for the destination view controller.

The system then turns control over to the destination view controller. The destination view controller then invokes its transition delegate which sets off the default Cover Vertical animation.

That covers the basic actions behind a segue. Now you can take the working segue and customize it with a segue subclass.

## Your custom segue library

A segue exists for the entire duration of a modal or popover presentation, so it's really easy to swap in segues from your library without touching your UIViewController code. The segue can be responsible for both presentation and dismissal transition animations. The starter app contains a pre-made custom segue called `DropSegue` to give you an idea of how easy changing segues can be.

In **Main.storyboard**, select the **PhotoDetail** segue between the Animal Detail and the Animal Photo view controllers. Change **Segue Class** to `DropSegue` as shown below:

![bordered height=20%](images/DropSegue.png)

Run the app and tap the photo; you can see the segue and unwind transition animations have changed completely — and you didn't change a single line of code. In fish terms, that was _reely_ easy! :]

Want to try another segue modification? Try changing the segue class to `FadeSegue`, which is included in the starter project.

Once you've built up a library of custom segues, you only need to select the desired segue from your library on your storyboard and you're done — no code required.

## Creating a custom segue

You'll now create your own custom segue to replace `DropSegue`. As is befitting a fish, you'll create a `Scale` transition animation. :] 

$[break]
The image below shows the transition you'll be creating:

![bordered width=70%](images/ScaleFlow.png)

The hardest part of creating a custom segue is the terminology. The protocols you'll be working with have rather long names:

* **UIViewControllerTransitioningDelegate**:  The custom segue adopts this protocol to vend the animator objects upon presentation and dismissal.

* **UIViewControllerAnimatedTransitioning**: The animator objects adopt this protocol to describe the animations.

* **UIViewControllerContextTransitioning**: This context holds details about the presenting and presented controllers and views; you pass this to the animator objects to provide them the _context_ within which to perform the animation.

If you haven't used custom transition animations before, you might be _floundering_ a bit at these long method names. :] Once you've used these methods a few times they'll become quite familiar.

Before you start, take a moment to review the steps required to create an animated segue:

1. Subclass `UIStoryboardSegue` and set the segue as the destination controller's transitioning delegate.
2. Create the presenting and dismissing animator classes.
3. Define the animation and its duration to be used in the animators.
4. Instruct the segue which animator classes to use for presentation and dismissal.
5. Finally, use the segue in the storyboard.

The sections below walk you neatly through each step.

### Subclass UIStoryboardSegue

You'll first create a new `UIStoryboardSegue` subclass. This segue will adopt the transitioning delegate protocol, allowing it to specify a custom transition animation.

Create a new Cocoa Touch class named **ScaleSegue.swift** that subclasses **UIStoryboardSegue**. Add the following `extension` just below the `ScaleSegue` class:

```swift
extension ScaleSegue: UIViewControllerTransitioningDelegate {

}
```

The `UIViewControllerTransitioningDelegate` protocol lets the segue vend presentation and dismissal animators for use in its transitions. Later, you'll implement a protocol method in this extension that returns the custom animator you're going to build in the next section.

For now, in the `ScaleSegue` class, override `perform()` as follows:

```swift
override func perform() {
  destinationViewController.transitioningDelegate = self
  super.perform()
}
```

Here you set the destination view controller's transitioning delegate so that `ScaleSegue` will be in charge of vending animator objects. When creating a modal or popover segue as you do here, you must call `perform()` on `super` so that UIKit can take care of the presentation.

In previous iOS versions, you might have put the transition animation in `perform()`, but now you can use this transitioning delegate to decouple the animation from the segue.

### Create the animator

Add the following new animator class at the end of **ScaleSegue.swift**:

```swift
class ScalePresentAnimator : NSObject,
  UIViewControllerAnimatedTransitioning {

}
```

You'll use `ScalePresentAnimator` to present the modal view controller. You'll create a dismissal animator in a bit, but for now your segue will use the default vertical cover transition for the dismissal. Note that Xcode will complain this doesn't yet conform to the `UIViewControllerAnimatedTransitioning` protocol; you're just about to fix that.

> **Note**: It's often easier to keep the animators in the same file as their respective segue as they're usually closely related. If you want to separate the segues from the animators simply move the animators into their own file.

### Define the animation

`ScalePresentAnimator` conforms to `UIViewControllerAnimatedTransitioning`. This protocol requires that you specify both the duration and the animation to be used for the transition.

First, you have to specify the duration of the animation. Add the following method to `ScalePresentAnimator`:

```swift
func transitionDuration(
  transitionContext: UIViewControllerContextTransitioning?)
  -> NSTimeInterval {
    return 2.0
}
```

Most transitions will have a duration of about 0.3 to 0.5 seconds, but this uses a duration of two seconds so that you can see the effect clearly.

Now for the actual animation: add the following method to `ScalePresentAnimator`:

```swift
func animateTransition(transitionContext:
  UIViewControllerContextTransitioning) {

  // 1. Get the transition context to- controller and view
  let toViewController = transitionContext
    .viewControllerForKey(
      UITransitionContextToViewControllerKey)!
  let toView = transitionContext
    .viewForKey(UITransitionContextToViewKey)

  // 2. Add the to- view to the transition context
  if let toView = toView {
    transitionContext.containerView()?.addSubview(toView)
  }

  // 3. Set up the initial state for the animation
  toView?.frame = .zero
  toView?.layoutIfNeeded()

  // 4. Perform the animation
  let duration = transitionDuration(transitionContext)
  let finalFrame = transitionContext
    .finalFrameForViewController(toViewController)

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

Taking each numbered comment in turn:

1. You extract the "to" controller and view from the given transition context. Note that the controller is implicitly unwrapped; there will always be a "to" controller, but there may not always be a "to" view. You'll see why later.
2. Add the "to" view to the transition context `containerView` where the animation takes place. Left to its own devices, the framework doesn't add the "to" view to the view hierarchy until the end of the transition. In order to see the new view appear, you need to add it to the hierarchy in your code.
3. The initial state for the "to" view frame is a rectangle of zero size in the top left-hand corner of the screen. When you change the frame of a view, you should always call `layoutIfNeeded()` to update the view's constraints.
4. The animation block is a simple animation from the zero rectangle to the final frame calculated by the transition context.
5. The transition context must always clean up at the end of the animation; calling `completeTransition(_:)` finalizes the view hierarchy and the layout of all views.

### Set the animator in the segue

Add the following delegate method to `ScaleSegue`'s `UIViewControllerTransitioningDelegate` extension:

```swift
func animationControllerForPresentedController(presented:
            UIViewController,
            presentingController presenting: UIViewController,
            sourceController source: UIViewController) ->
            UIViewControllerAnimatedTransitioning? {
  return ScalePresentAnimator()
}
```

This simply tells the segue to use your `ScalePresentAnimator` during presentation.

### Use the segue in the storyboard

That takes care of all the actual code; all that's left is to set your custom segue in the storyboard. In **Main.storyboard**, locate the **PhotoDetail** segue and change **Segue Class** to `ScaleSegue`. Also, change **Presentation** to **Form Sheet** to improve the appearance of the segue on the iPad:

![bordered height=18%](images/ScaleSegue.png)

Run your application and tap the fish; the image will scale from the top left of the screen to take up the full screen on the iPhone, while on the iPad the image scales up to a form sheet:

![width=80%](images/InitialScale.png)

Tap the large photo to dismiss it via the standard dismiss animation.

Hey – you've completed your first custom segue! There's a bit of tweaking to do, for sure, but the current state of **ScaleSegue.swift** will serve as a blueprint for all animated segue transitions from here on out. You're going to need a dismissal animator and some more animation code, and your implementation of `animateTransition(_:)` can become quite complicated sometimes, but the basic process will be the same.

Take a moment to browse through example custom segue code in **DropSegue.swift** and **FadeSegue.swift**. Even though the animations are different, the basic structure of both segues is exactly the same as `ScaleSegue`.

## Passing data to animators

Most users would expect the small photo to scale directly to a large one when they tap it. But how do you indicate to the animator object which view to scale? You don't have a direct reference to the source image view as everything is decoupled.

Protocols are the perfect tool for this problem. The Animal Detail view controller can adopt a protocol to set which view to scale; the animator object can then use that protocol's scaling view without knowing anything else about the source view controller.

Create the following protocol in **ScaleSegue.swift**:

```swift
protocol ViewScaleable {
  var scaleView: UIView { get }
}
```

Any view controller can use this segue by adopting `ViewScaleable` and creating a `scaleView` property containing the view to scale.

Add the following extension to the very end of **AnimalDetailViewController.swift**:

```swift
extension AnimalDetailViewController: ViewScaleable {
  var scaleView: UIView { return imageView }
}
```

`AnimalDetailViewController` now conforms to `ViewScaleable`; this sets the protocol's property to `imageView`, which in this instance is your fish image.

Find the following code in `animateTransition(_:)` of **ScaleSegue.swift**:

```swift
let toViewController = transitionContext
  .viewControllerForKey(UITransitionContextToViewControllerKey)!
```

Add the following code directly after the above line:

```swift
let fromViewController = transitionContext
  .viewControllerForKey(
    UITransitionContextFromViewControllerKey)!
let fromView = transitionContext
  .viewForKey(UITransitionContextFromViewKey)
```

This gets references for the "from" view controller and for the "from" view. Again, the view controller is implicitly unwrapped while the "from" view is optional.

> **Note**: Make absolutely sure you use the correct key variables. It's frustratingly easy to use `UITransitionContextToViewControllerKey` instead of `UITransitionContextToViewKey`. Code completion makes it all too easy to pick the wrong variable or to mix up the "from" and "to".

$[break]
Still in `animateTransition(_:)`, replace:

```swift
toView?.frame = .zero
```

with the following:

```swift
var startFrame = CGRect.zero
if let fromViewController = fromViewController
  as? ViewScaleable {
    startFrame = fromViewController.scaleView.frame
} else {
  print("Warning: Controller \(fromViewController) does not " +
    "conform to ViewScaleable")
}
toView?.frame = startFrame
```

Instead of starting the "to" view frame animation at the top left, you start the animation at the "from" view controller's `scaleView` frame property.

Notice again that the animator knows _nothing_ about the source view controller, other than that it conforms to the `ViewScaleable` protocol, and therefore has a `scaleView` property. This is a great, decoupled software design!

You'll see a compile warning noting you're not using `fromView`; you'll take care of this in a moment.

Run your app; the segue now scales the original view as expected:

![height=22%](images/BetterScale.png)

Things are going _swimmingly_! :] There are only a few more tweaks left; the following sections show you how all the views work together.

## Working with the view hierarchy

You've been using `transitionContext.viewForKey(_:)` in `animateTransition(_:)` to grab the "to" view. But why didn't you just use the destination controller's `view` property?

The transition context handles presentations differently based on the size class. The modal form sheet for a horizontal, regular-sized display is wrapped in a presentation layer that provides the dimming view and rounds the corners of the form sheet. In contrast, a modal controller on a compact display takes up the full screen.

Therefore, on all iPhones, with the exception of the iPhone 6 Plus in landscape, `viewForKey(UITransitionContextToViewKey)` returns the same view as the destination controller's view because no presentation layer exists. However, the destination controller is wrapped in the presentation layer for iPads and the iPhone 6 Plus in landscape; if you referred to the destination controller's view in this case, you'd scale the destination view — not the presentation layer.

You can try this yourself. Find the following in `animateTranstion(_:)` of **ScaleSegue.swift**:

```swift
let toView = transitionContext
  .viewForKey(UITransitionContextToViewKey)
```

And modify it as follows:

```swift
let toView = toViewController.view
```

Run your app on the iPhone 6 in portrait mode, and then run it on an iPad. You won't see any change on the iPhone, but on the iPad the form sheet scales in from the top left and looks very weird — _fishy_, even! :]

Revert the code to its original state:

```swift
let toView = transitionContext
  .viewForKey(UITransitionContextToViewKey)
```

Similarly, the transition context's "from" view could be different to the source view controller's view. In a compact sized view, the transition context's "from" view will be the same as the source view controller's view, but in a normal-sized view the "from" view would be `nil`.

You can take advantage of this behavior in your transition. The transition on compact-sized screens with full-screen modal views would look better if the "from" view faded out during the scale animation. The transition can remain the same on normal-sized screens since the modal scene is a form sheet and therefore leaves the source view controller in situ in the background.

Find the following in `animateTransition(_:)`, inside the animation block at the end of the method:

```swift
toView?.frame = finalFrame
toView?.layoutIfNeeded()
```

Add the following code immediately after the code above:

```swift
fromView?.alpha = 0.0
```

This fades out the "from" view.

Next, find the following in the completion block:

```swift
transitionContext.completeTransition(true)
```

Add the following code just _before_ the code above:

```swift
fromView?.alpha = 1.0
```

This resets the alpha of the "from" view. If you don't do this, the alpha of the "from" view will remain at 0 and you'll just see a black screen when you when you dismiss the modal scene.

Run the app on both the iPhone 6 and any iPad; the "from" view on the iPad will fade out, but the same view on the iPad won't be affected because `fromView` is `nil`:

![iPad width=50%](images/FinalScale.png)

You've created a great-looking custom segue with an animated transition! But don't forget what was promised at the beginning of this chapter — the ability to add multiple pets.

## Handling embedded view controllers

That seems like an easy task; you just need to set the table view of all pets as the initial view controller of the application.

In **Main.storyboard**, select the **Navigation Controller** on the very left of the storyboard. Use the Attributes Inspector to tick **Is Initial View Controller**:

![bordered width=25%](images/IsInitialViewController.png)

Run your application; you'll see a list of all pets to be minded. Select any pet in the list and tap its photo:

![width=55%](images/RageFish.png)

Oh no! The animation scales up from the wrong spot! Look in the debug console and you'll see the debug statement you added earlier indicating the presenting view controller doesn't conform to `ViewScalable`.

That's because the view controller is now embedded within a navigation controller, making that the presenting view controller — not `AnimalDetailViewController`.

Fortunately, this is easy to fix. Simply check whether the presenting view controller is a navigation controller; if so, use the navigation controller's top view controller as the presenting view controller.

Find the following code in the `ScalePresentAnimator` class of  **ScaleSegue.swift**, at the top of `animateTransition(_:)`:

```swift
let fromViewController = transitionContext
  .viewControllerForKey(
    UITransitionContextFromViewControllerKey)!
```

Replace the previous code with the following:

```swift
var fromViewController = transitionContext
  .viewControllerForKey(
    UITransitionContextFromViewControllerKey)!
if let fromNC = fromViewController as? UINavigationController {
  if let controller = fromNC.topViewController {
    fromViewController = controller
  }
}
```

Here you replace the transition context's "from" controller _only_ if the presenting view controller is a navigation controller.


Run the application again, and the scale transition will work as expected:

![iPad width=60%](images/CompletedScale.png)

When building your reusable segues, expect that they could be used by container controllers. For example, the presenting controller in this case could be a `UITabBarController`, so you could add similar code to handle that case as well.

Now that you're an expert on custom segues, why don't you try these few extra challenges to stretch yourself?

### Completing the scale segue dismissal

Your first challenge is to complete the scale segue. You'll create the dismiss animator and set the segue to use it.

The code will look very similar to the presenting animator from this chapter, except that the "from" view controller is now the modal view controller, and the "to" view will be the view from which it was presented. The animator object will need to add the "to" view back to the hierarchy during the transition, so you'll need the code below in order to insert the "to" view at the correct place in the hierarchy:

```swift
if let fromView = fromView,
  toView = toView {
    transitionContext.containerView()?
      .insertSubview(toView, belowSubview: fromView)
}
```

You can find the full solution to this challenge in the sample code included with this chapter.

### Adding a swipe segue

Your next challenge is to create a completely new reusable segue called `SwipeSegue` that uses the default transition to present an up or down swipe to dismiss. The modal scene should slide away in the direction of the swipe.

Here are some tips:

* The `SwipeSegue` class will be almost the same as the `ScaleSegue` class.
* Add a new animator object similar to the Scale dismissal animator that moves the presented frame either off the top of the screen or off the bottom of the screen, depending on which way you swipe.
* Add a new protocol `ViewSwipeable` that stores the swipe direction.
* Add two swipe gestures, one up and one down, to the `AnimalPhotoViewController` image view. Attach an `@IBAction` handler method to the gestures to store the swipe direction in the view controller.
* Add an extension to the view controller for the `ViewSwipeable` protocol that returns the swipe direction.
* Change the existing `PhotoDetail` segue to use your new Swipe segue.

Once again, the solution is in the accompanying sample code.

## Where to go from here?

Retaining segues during a modal and popover presentation is a small change that has huge consequences. Previously, view controllers had to know about the transitions to use along with the style to use when presenting. Now the segue can take full responsibility for both elements. You can create any segue with its own transition animation and reuse that segue in any app you wish. You can also easily swap out segues to see which ones look best in your particular app — without changing any code!

You can read more on custom segues in Chapter 3, "Custom View Controller Transitions" of _iOS 7 by Tutorials_. For an excellent reference book on all types of animations in iOS, check out _iOS Animations by Tutorials_.

Congratulations on completing this chapter; with your newly learned transition skills, your apps will be truly _fin_-tastic! :]
