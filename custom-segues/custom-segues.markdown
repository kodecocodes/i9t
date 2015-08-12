# Chapter 6: Custom Segues

Ever since Apple introduced storyboards in iOS 5, you've been using segues to transition between scenes. In iOS 7, custom view controller transitions were introduced to enable custom and even interactive transition animations between views. Now in iOS 9, Apple has directly leveraged view controller transitions for custom segue implementations, allowing you to completely separate out your transition animation from your view controller code. 

In a small but important change, segues are now retained during modal or popover presentation of a scene. In other words, segues are created at the start of presenting a new scene and held in memory until the presented scene view controller is dismissed.

In effect, this means that you can move all transition animation and adaptivity code into a segue class. This segue can then be reused in any storyboard. When the modal scene is dismissed the unwind transition will use the current segue's transition.

If you decide to change the appearance of the segue transition, you just change the segue class in the storyboard to another one in your segue repertoire. This will immediately change the presenting and unwinding transition animations.

In this chapter you will discover how to create your own library of custom segues. You'll need basic knowledge of storyboards and segues, but as long as you've understood the previous chapter **What's New In Storyboards** you'll be fine. 

You'll find out how to:

* Create a custom segue
* Animate a custom transition within the segue
* Make your segue reusable within navigation and tab controllers

&nbsp;

&nbsp;

## Getting Started

The app you'll be updating today is a pet minding app called **PamperedPets**. It's a very simple app, that when complete, will display a list of pets to be minded and details about each one. 

![iPhone](images/PamperedPets.png)

Explore your starter project and see how it works. When you run the app, you'll see a single scene which shows the photo, address and feeding instructions the star of our show - Bubbles the goldfish. No transitions are yet implemented.

> **Note**: The project will throw some warnings related to the Storyboard. Don't panic.  You'll hook the disconnected storyboards up later in the chapter.

Have a look at **Main.storyboard**. There are a number of scenes that have been created for you, but initially the Animal Detail scene and the Animal Photo scene are the scenes that you'll be working with. 

![bordered width=80%](images/Storyboard.png)

When you've finished this chapter, your app will show a list of pets to be minded. You'll be able to select a pet and that pet's details will be displayed.

The app is very simple, but the animated transitions that you will create will raise your app from lackluster to rock-star!

And to get you hooked there may be some fish jokes before you fin-ish :].

## What are Segues?

As you have learned from What's New in Storyboards in the previous chapter, segues describe transitions between scenes and are indicated by arrows between the view controller scenes. Segue types can be:

* **Show** - this segue pushes a scene from a navigation controller.
* **Show Detail** - replaces a scene detail when in a `UISplitViewController`.
* **Present Modally** - presents a scene on top of the current scene.
* **Popover** - presents as a popover on the iPad or full screen on the iPhone.

> **Note**: Relationships between child view controllers embedded in a container view are also shown on the storyboard as arrows but these are not segues that can be customized.

Custom segues have been around for a while, but previously, a segue was *either* modal/popover *or* custom. Now you can use the underlying segue type with your custom segue instead of having to define the segue from scratch.

![bordered width=25%](images/NewSegueInspector.png)

In this chapter you will be customizing only Modal and Popover segues. 

## A Simple Segue

I'm sure you've already created many segues, but to ensure that you fully appreciate how segues work you will now create the basic modal segue which you will later customize. 

You will create a segue that will be invoked when the user taps the photo in the AnimalDetailViewController scene. The segue will then present the AnimalPhotoViewController scene as a modal controller showing a larger photo. 

There are two main parts to this segue:

1. Setting up the segue. `prepareForSegue(_:sender:)` is performed when the segue is activated. This is where you will set up the destination view controller with the necessary data.
2. Performing the destination controller's transition animation. Initially you'll use the default transition, but shortly you will customize that.

First in **Main.storyboard**, select the **Animal Detail View Controller** scene. Drag a **Tap Gesture Recognizer** from the Object Library onto the **Image View** photo of Bubbles the fish. This will hook up the tap gesture with that image view.

In the Document Outline ctrl-drag from this **Tap Gesture Recognizer** to **Animal Photo View Controller**. Choose **present modally** from the popup menu. 

That's all it takes to define a segue. Now you will name the segue and set up AnimalPhotoViewController so that it shows the correct photo.

Select the segue arrow between the two scenes **Animal Detail View Controller** and **Animal Photo View Controller**, and in the **Attributes Inspector** give the segue the Identifier **PhotoDetail**. 

![bordered height=20%](images/PhotoDetailSegue.png)

In **AnimalDetailViewController.swift** override `prepareForSegue(_:sender:)` to set up the destination controller data:

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

Here you give the destination controller, in this case `AnimalPhotoViewController`, the image that it will display.

Run the app and tap the photo. 

![bordered iPhone](images/FishDetail.png)

A larger photo of the fish will slide up the screen. There is currently no way for the user to close this screen so you will now create a tap gesture to perform an unwind segue.

In **AnimalDetailViewController.swift** add the following method to `AnimalDetailViewController`:

```swift
@IBAction func unwindToAnimalDetailViewController(segue:UIStoryboardSegue) {
  // placeholder for unwind segue
}
```

This method doesn't require any code for a simple unwind segue. Any method with a signature of `@IBAction func methodName(segue:UIStoryboardSegue)` is considered by the system to be a marker for a Storyboard segue to unwind to.

In **Main.storyboard** select the **Animal Photo View Controller** scene. Drag a **Tap Gesture Recognizer** from the Object Library onto **Pet Photo View**. 

In the Document Outline ctrl-drag from this new **Tap Gesture Recognizer** to **Exit**. Select **unwindToAnimalDetailViewController** from the popup menu.

![bordered width=40%](images/ExitSegue.png)

Run the app again, and tap the photo. The larger photo will transition in by sliding up the screen, and tapping the larger photo will unwind back to the first screen.

![bordered iPhone](images/DismissFish.png)

Let's dissect what's happened here. When you tap the thumbnail on the detail view, the tap gesture recognizer initiates a Modal segue from `AnimalDetailViewController` to `AnimalPhotoViewController`. `AnimalDetailViewController` is the **source view controller**. AnimalPhotoViewController is the **destination view controller**. The segue holds a reference to both the source view controller and the destination view controller. 

![bordered height=20%](images/AppFlow.png)

Behind the scenes the segue sets the transitioning delegate of the destination view controller and also sets up its presentation according to size class.

The source view controller method `prepareForSegue(_:sender:)` sets up the data for the destination view controller.

Control is turned over to the destination controller. The destination controller invokes its transition delegate which sets off the default Cover Vertical animation.

Those are the basic principles of what happens during a segue. Now that you have seen a simple working segue you are going to customize one using a segue subclass.

## Segues from your Custom Segue Library

Because the segue is now retained throughout the entire duration of a modal or popover presentation, it's really easy to change segues from your library without having to touch your UIViewController code. The segue can be responsible for both presentation and dismissal transition animations.

The starter app contains a pre-made custom segue called `DropSegue` so that you can see how easy it is to change segues. In **Main.storyboard** select the **PhotoDetail** segue between the Animal Detail View Controller and the Animal Photo View Controller. Change **Segue Class** to **DropSegue**. 

![bordered height=20%](images/DropSegue.png)

Run the app and tap the photo. Both the segue transition animation and the unwind transition animation have completely changed and you didn't have to change a single line of code. In fish terms, that was reely easy!

There's also a FadeSegue included in the starter project, so you can try this one as well if you like.

Once you have built up your own library of custom segues, all you will have to do is select the relevant segue in the storyboard and your transition animation work is done!

## Create a Custom Segue

You'll now create your own custom segue to replace that Drop segue. Appropriately for a fish, you'll create a Scale transition animation, where the fish photo will scale in on presentation.

The hard part about all this is the terminology. You will be using protocols with very long names, which can be quite daunting, but familiar if you've used Custom Transition Animations. 

These are the protocols that you will be encountering. 

**UIViewControllerTransitioningDelegate** - the custom segue will adopt this protocol to vend the animator objects to perform animations upon presentation and dismissal.

**UIViewControllerAnimatedTransitioning** - the animator objects will adopt this to describe the animations.

**UIViewControllerContextTransitioning** - the animator objects will be passed a context object for the transition. This context holds details about the presenting and presented controllers and views.

If you're floundering, don't worry if you don't have these down just yet - when you have used them a few times they will become clear. 

Before you start, here's an overview the steps required to create every animated segue:

1. Subclass `UIStoryboardSegue` and set the segue as the destination controller's transitioning delegate 
2. Create the presenting and dismissing animator classes
3. Define the duration and animation in the animators.
4. Tell the segue what animator classes to use for presentation and dismissal
5. Use the segue in the storyboard

You're just about to dig in and implement each of these steps. The picture below shows the transition you will end up with:

![bordered height=22%](images/ScaleFlow.png)

### 1 - Subclass `UIStoryboardSegue`

You'll create a new `UIStoryboardSegue` subclass that acts as a transitioning delegate for the destination controller. This will allow it to implement a custom transition animation.

Create a new Cocoa Touch Class called **ScaleSegue.swift** that subclasses **UIStoryboardSegue**. Add the following `extension` just below the `ScaleSegue` class:

```swift
extension ScaleSegue: UIViewControllerTransitioningDelegate {

}
```

The `UIViewControllerTransitioningDelegate` protocol allows the segue to vend presentation and dismissal animators for use in its transitions. After you have created an animator, you will return here to implement the method that returns it.

Back in `ScaleSegue`, override the `perform()` method:

```swift
override func perform() {
  destinationViewController.transitioningDelegate = self
  super.perform()
}
```

Here you set the destination view controller's transitioning delegate so that `ScaleSegue` will be in charge of vending animator objects. When creating a Modal or Popover segue as you are here, you must override super's `perform()` so that `UIKit` can take care of the presentation.

In previous iOS versions, you might have put the transition animation in `perform()`, but now the animation is decoupled from the segue by using this transitioning delegate. 

### 2 - Create the Animator

Add a new animator class at the end of **ScaleSegue.swift**

```swift
class ScalePresentAnimator:NSObject, UIViewControllerAnimatedTransitioning {

}
```

`ScalePresentAnimator` will be used for presenting the modal view controller. You will create a dismissing animator later, but for now your segue will by default use the current Vertical Cover transition for the dismissal. Note that Xcode will complain that this doesn't yet conform to the protocol - you're just about to rectify that. 

> **Note**: I find it easier to keep the animators in the same file as the segue because they are usually closely related, but you can separate the segue and the animators by moving the animators into their own file.

### 3 - Define the animation

`ScalePresentAnimator` conforms to `UIViewControllerAnimatedTransitioning`. This protocol requires that you specify both the transition duration and the transition animation.

First specify how long the animation will take to run. Add this method to the `ScalePresentAnimator` class:

```swift
func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
  return 2.0
}
```

Most transitions have a duration of about 0.3-0.5 seconds, but this duration of 2 seconds is slow so that you can see the effect clearly.
  
Now for the actual animation. Add this method to `ScalePresentAnimator`:

```swift
func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

  // 1. Get the transition context to- controller and view
  let toViewController = 
    transitionContext.viewControllerForKey
         (UITransitionContextToViewControllerKey)!
  let toView = transitionContext.viewForKey(UITransitionContextToViewKey)

  // 2. Add the to- view to the transition context
  if let toView = toView {
    transitionContext.containerView()?.addSubview(toView)
  }
    
  // 3. Set up the initial state for the animation
  toView?.frame = .zeroRect
  toView?.layoutIfNeeded()

  // 4. Perform the animation
  let duration = transitionDuration(transitionContext)
  let finalFrame = 
       transitionContext.finalFrameForViewController(toViewController)

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

1. You extract from the given transitioning context the to- controller and to- view that will be presented. Note that the controller is implicitly unwrapped as there will always be a to- controller, but the view is an optional as there may not be a to- view. You'll see why later.
2. Add the to- view to the transition context `containerView` where the animation takes place. The framework doesn't add the to- view to the view hierarchy until the end of the transition, so you will need to add it to the hierarchy in your code so that you can see it scaling.
3. The initial state for the to- view frame is a rectangle of zero size in the top left hand corner of the screen. Whenever you change the frame of a view, you should perform `layoutIfNeeded()` to update the view's constraints.
4. The animation block is a simple animation to animate from the zero rectangle to the final frame that is calculated by the transition context.
5. The transition context must always clean up at the end of the animation. Calling `completeTransition` will finalize the view hierarchy and layout all views.

### 4 - Set the Animator in the Segue

Inside the `UIViewControllerTransitioningDelegate` extension, add the delegate method:

```swift
func animationControllerForPresentedController(presented: UIViewController,
               presentingController presenting: UIViewController, 
               sourceController source: UIViewController) -> 
               UIViewControllerAnimatedTransitioning? {
  return ScalePresentAnimator()
}
```

This simply tells the segue to use your `ScalePresentAnimator` during presentation.

### 5 - Use the Segue in the Storyboard

You've done all the code necessary, so in **Main.storyboard** locate the **PhotoDetail** segue and change **Segue Class** to **ScaleSegue**. Also Change **Presentation** to **Form Sheet** as this looks better on the iPad.

![bordered height=20%](images/ScaleSegue.png)

Run the application, tap the fish, and watch it scale up from the top left of the screen to full screen on the iPhone and a form sheet on the iPad. (Note that when you tap the large photo to dismiss, the regular dismiss animation takes place.)

![bordered height=22%](images/InitialScale.png)

Congratulations! That's your first custom segue! 

You do have some way to go to making the scaling animation look right, but **ScaleSegue.swift** in its current state is a blueprint for all animated segue transitions that you will want to do. Obviously you will add a dismissal animator, different animation code, and sometimes `animateTransition(:_)` will become quite complicated, but the initial steps are just the same.

Take a moment to look at the code of the included example custom segues DropSegue and FadeSegue. Notice how even though the animation differs, the basic structure of both those segues is exactly the same as your ScaleSegue. 

## Passing data to animators

Let's continue to improve your scaling segue. It would be good to have the larger photo smoothly scale up from the smaller one instead of from the corner. But how do you tell the animator object what view it is scaling? There's so much decoupling happening that you don't have a direct reference.

From Apple's Swift book - "A protocol defines a blueprint of methods and properties that suit a particular task". The scaling segue requiring a start view frame is a perfect example of a simple task. The Animal Detail can adopt a protocol to set what view is to be scaled, and the animator object can then use that protocol's scaling view without having to know anything else about the view controller. 

In **ScaleSegue.swift** create the protocol:

```swift
protocol ViewScaleable {
  var scaleView:UIView { get }
}
```

Any view controller that wants to present a modal view using this scaling segue should adopt `ViewScaleable` by creating and filling a `scaleView` property. So make  AnimalDetailViewController conform to `ViewScaleable` by adding this extension to the very end of **AnimalDetailViewController.swift**:

```swift
extension AnimalDetailViewController: ViewScaleable {
  var scaleView:UIView { return imageView }
}
```

This sets the protocol property so that the view to use for scaling is the imageView with the fish.

Back in **ScaleSegue.swift** at the top of `animateTransition(:_)`, just before declaring:

```swift
let toViewController = transitionContext.viewControllerForKey⏎
                         (UITransitionContextToViewControllerKey)!
```

add this code:

```swift
let fromViewController = 
    transitionContext.viewControllerForKey⏎
        (UITransitionContextFromViewControllerKey)!
let fromView = 
    transitionContext.viewForKey(UITransitionContextFromViewKey)
```

Again from- controller is implicitly unwrapped while from- view is optional.

> **Note**: *Beware!* Make sure that you use the correct key variables. I have spent significant time wondering why my view is incorrect when I have used UITransitionContextToViewControllerKey instead of UITransitionContextToViewKey. And because of automatic code completion it's also easy to mix up From and To. 

Still in `animateTransition(:_)` replace:

    toView?.frame = .zeroRect

with

```swift
var startFrame = CGRect.zeroRect
if let fromViewController = fromViewController as? ViewScaleable {
  startFrame = fromViewController.scaleView.frame
} else {
  print("Warning: Controller \(fromViewController) does not conform to ViewScaleable")
}
toView?.frame = startFrame
```

Instead of starting the to- view frame animation at the top left, you are starting the animation at the from- view controller's `scaleView` frame property.

The cool thing about using the ViewScaleable protocol to pass values, is that the animator object does not need to know anything about the view controller except that it conforms to ViewScaleable.

You'll have a compile warning about fromView not being used. Don't worry - you'll be using it soon.

Run the app. This is starting to look better. 

![bordered height=22%](images/BetterScale.png)

There are just a few more tweaks for you to make while we look at how all these views fit together. 

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

Similarly, the transition context's from- view may differ from the source view controller's view. On an iPhone the transition context's from- view will be the same as the source view controller's view, but on an iPad the from- view will be nil.

To make your transition look better you can make use of this. On the iPhone the transition would look better if the from- view faded out during the scale animation. However on the iPad because the modal scene is a form sheet, the from- view should remain unfaded in the background.

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

![iPad](images/FinalScale.png)

That's it! You have now completed your first custom segue with animated transition! At the end of the chapter, you will be presented with two challenges. The first one will be to create the corresponding dismiss animation for scaling the photo back down to the intial small photo.

## When View Controllers are Embedded

But perhaps you need to mind more than one pet? Now you will set the table view of all pets to be the initial view controller of the application.

In **Main.storyboard**, select the **Navigation Controller** on the very left of the storyboard. In the **Attributes Inspector** tick **Is Initial View Controller**.

![bordered height=20%](images/IsInitialViewController.png)

Run the application. The app will now start with a list of all pets to be minded. Select one, and tap the photo to see your scaling animation.

![height=20%](images/RageFish.png)

Oh no! The animation doesn't scale from the right place any more! If you look in the debug console, you'll see the print warning that you put in your code to print if the presenting view controller does not conform to ViewScalable.

This is because the view controller is now embedded within a Navigation Controller, which means that the Navigation Controller is now the presenting view controller, not the AnimalDetailViewController.

Fortunately, this is easily fixed. To be reusable in multiple situations, you can find out whether the presenting view controller is a Navigation Controller, and if so, take the Navigation Controller's top view controller as the presenting view controller.

In **ScaleSegue.swift** at the top of `animateTransition(:_)` in the **ScalePresentAnimator** class where it says:

    let fromViewController = 
       transitionContext.viewControllerForKey⏎
           (UITransitionContextFromViewControllerKey)!

replace that line with:

```swift
var fromViewController = 
    transitionContext.viewControllerForKey⏎
        (UITransitionContextFromViewControllerKey)!
if let fromNC = fromViewController as? UINavigationController {
  if let controller = fromNC.topViewController {
    fromViewController = controller
  }
}
```

Here you replace the transition context's from- controller, but only if it's a Navigation Controller. 

Run the application again, and the scale transition should now work as expected.

![iPad](images/CompletedScale.png)

Reusable segues need to be aware that they may be used by container controllers. The presenting controller could be a UITabBarController, so you could add similar code to make the segue usable in that situation too.

That wraps up custom segue transition animation. In the Challenge at the end of the chapter, you will get another chance (o-perch-tuna-ty? :]) to try out what you have learned so far by creating another custom segue.

&nbsp;

## Where To Go From Here?

Retaining segues during a modal/popover presentation is a small change but one that has huge consequences. Previously view controllers had to know about both the transitions they were using and the styles they were going to be presented in. 

Now the segue can take full responsibility for those. You can now create any segue with its own transition animation and reuse that segue in all your apps. You can also swap segues to see what looks best for each scene transition without having to update any code.

This chapter has been a basic introduction into the modern method of creating custom segues, but you can find out much more about transitions in our book: 

* **iOS 7 by Tutorials** - Chapter 3 Custom View Controller Transitions

To be able to create any animation you can think of, I highly recommend our book:

* **iOS Animations by Tutorials**

## Challenge

In this chapter you learned how to set up custom segues and to pass data to them using protocols. 

To help cement your new skills, and become a dab hand at segues, here's a challenge for you.

### Scale Segue Dismissal

Your first challenge is to complete the Scale Segue. You will create the dismiss animator and set the segue to use this dismiss animator.

The code will look very similar to the presenting animator from this chapter, except that the from- view controller is now the modal view controller and to- view will be the view underneath. On an iPhone, the framework removes this view because modal views fully cover the screen. So `toView` needs to be added back in to the view hierarchy. This is the code you will use for that:

```swift
if let fromView = fromView,
  toView = toView {
    transitionContext.containerView()?
              .insertSubview(toView, belowSubview: fromView)
}
```

You can find the solution in the sample code included with this chapter.

### A Swipe segue

Your next challenge is to create a completely new reusable segue that uses the default transition to present, but takes an up or down swipe to dismiss. The modal scene should slide away in the direction of the swipe.

Here are some tips:

* The SwipeSegue class will be almost the same as the ScaleSegue class.
* Add a new animator object similar to the Scale dismissal animator that moves the presented frame off either the top of the screen or the bottom of the screen depending on swipe direction.
* Add a new protocol `Swipeable` that stores the swipe direction
* Add two swipe gestures, one up and one down, to the AnimalPhotoViewController image view. Attach an `@IBAction` handler method to them to store the swipe direction in the view controller.
* Add an extension to the view controller to give `Swipeable` the direction used.
* Change the existing PhotoDetail segue to use your new Swipe segue.

As always the solution is in the accompanying sample code.

Congratulations on completing this chapter - with your new transition skills your apps will be truly fin-tastic!
