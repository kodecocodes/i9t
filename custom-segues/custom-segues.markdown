# Chapter 6: Custom Segues

Storyboards are laid out in Interface Builder using scenes and segues. Segues are the transitions between scenes in storyboards and they have been around since storyboards were first introduced back in iOS 5. Transition animations were later decoupled from segues  in iOS 7. And in iOS 9 segues have now become even more independent.

In a small but important change, segues are now retained during modal or popover presentation of a scene. In other words, segues are created at the start of presenting a new scene and held in memory until the presented scene view controller is dismissed.

In effect, this means that you can move all transition animation and adaptivity into a segue class. This segue can then be reused in any storyboard. When the modal scene is presented, you don't have to consider the unwind transition - it just uses the current segue transition.

If you decide to change the appearance of the segue transition, you just change the segue in the storyboard to another one in your segue repertoire. This will immediately change the presenting and unwinding transition animations.

With multitasking on the iPad, when your app is used in split screen, you will be wanting your app's presented controllers to adapt to their correct state fluidly. Because segues are now retained in memory, as well as being the controller for transitions, they can also act as controller for the adapted state.

In this chapter you will discover how to create your own library of custom segues. You'll find out how to:

* Create a segue
* Animate the segue
* Make your segue reusable within navigation and tab controllers
* Adapt between different size classes

## Getting Started

The app you will be updating today is a pet minding app called **PamperedPets**. It's a very simple app so far, with just a list of pets to be minded and details about each one.

![iPhone](images/PamperedPets.png)

Explore your starter project and see how it works. When you run the app, you will see a single scene which shows the photo, address and feeding instructions for a single pet. There is also a button for Vet information that currently doesn't work. You'll be creating a popover for that later on.

Have a look at **Main.storyboard**. There are a number of scenes that have been created for you, but initially the Animal Detail scene and the Animal Photo scene are the scenes that you will be working with. When you have finished this chapter, your app will show a list of pets to be minded, and when you select one that pet's details will be displayed.

![bordered width=90%](images/Storyboard.png)

The app is very simple, but the animated transitions that you will create will raise your app from lackluster to rock-star!

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

1. Setting up the segue. prepareForSegue(_:sender:) is performed when the segue is activated. This is where you set up the destination view controller with the necessary data.
2. Performing the destination controller's transition animation. Initially you will use the default transition, but shortly you will customize that.

Firstly, in **Main.storyboard**, select the **Animal Detail View Controller** scene. Drag a **Tap Gesture Recognizer** from the Object Library onto the **Image View** photo. This will hook up the tap gesture with that image view.

In the Document Outline ctrl-drag from this **Tap Gesture Recognizer** to **Animal Photo View Controller**. Choose **Present Modally** from the popup menu. 

That's all it takes to defined a segue. Now you will set up AnimalPhotoViewController so that it shows the correct photo.

Select the segue arrow between the two scenes **Animal Detail View Controller** and **Animal Photo View Controller**, and give the segue the Identifier **PhotoDetail**. 

In **AnimalDetailViewController.swift** create the prepareForSegue() method:

```swift
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "PhotoDetail" {
      let controller = segue.destinationViewController as! AnimalPhotoViewController
      controller.image = imageView.image
    }
  }
```

Here you give the destination controller, in this case AnimalPhotoViewController, the image to display.

Run the application and tap the photo. The larger image will slide up the screen. There is currently no way for the user to close this screen. So you will now create an unwind segue.

In **AnimalDetailViewController.swift** add this method:

```swift
  @IBAction func unwindToAnimalDetailViewController(segue:UIStoryboardSegue) {
	//placeholder for unwind segue
  }
```

This method won't contain any code. Any method with a signature of `@IBAction func methodName(segue:UIStoryboardSegue)` is considered by the system to be a marker for a Storyboard segue to unwind to.

In **Main.storyboard** select the **Animal Photo View Controller** scene. Drag a **Tap Gesture Recognizer** from the Object Library onto the **Image View**. 

In the Document Outline ctrl-drag from this Tap Gesture Recognizer to Exit (just above the Tap Gesture Recognizer). Select unwindToAnimalDetailViewController from the popup menu.

Run the app again, and tap the photo. The larger photo will transition in by sliding up the screen, and then you can tap the larger photo to unwind back to the first screen.

Let's dissect what's happened here. When the photo was tapped, the tap gesture recognizer initiated a Modal segue from AnimalDetailViewController to AnimalPhotoViewController. AnimalDetailViewController is the **source view controller**. AnimalPhotoViewController is the **destination view controller**.

The segue holds reference to both the source view controller and the destination view controller. 

Behind the scenes, the segue sets the transitioning delegate of the destination view controller to the transition of choice. In this case the default transition - Cover Vertical. 

The source view controller in `prepareForSegue(_:)` then sets up the data for the destination view controller.

Control is turned over to the destination controller. The destination controller invokes its transition delegate, so the slide up transition animation happens.

That's the basics of what happens during a segue. If you want to explore this in further detail, have a look at Custom Transitions in iOS 7 by Tutorials.

Now that your segue is working correctly, you are now going to customize it in a segue subclass.

## Segues from your Custom Segue Library

A major new feature in iOS 9 is that the custom segue is retained for the entire duration of a modal or popover presentation. In previous iOS versions, as soon as the segue finished presenting, it was deallocated. This meant that you had to set the unwind to have its own custom segue.

Because the segue is now retained, it's really easy in the Storyboard to change out segues from your library without having to touch your UIViewController code.

The starter app contains a pre-made custom segue so that you can see how easy it is to change segues. In **Main.storyboard**, in **Animal Detail View Controller** select the **PhotoDetail** segue. Change **Segue Class** to **DropSegue**. 

Run the application and tap the photo. Both the segue transition animation and the unwind transition animation have completely changed and you didn't have to change a single line of code.

Once you have built up your own library of custom segues, all you will have to do is select the relevant segue in the storyboard and your transition animation work is done!

## Create a Custom Segue

You'll now create your own custom segue to replace that Drop segue. You'll create a Fade transition animation, where the view's alpha property will animate from 0 to 1 on presentation.

The hard part about all this is the terminology. You will be using protocols with very long names, which can be quite daunting. 

These are the protocols that you will be encountering. Don't worry if you don't understand them just yet - when you have used them a few times, they will become clear.

**UIViewControllerTransitioningDelegate** - the custom segue will conform to this protocol to specify the animator objects to be performed on presentation and on dismissal.

**UIViewControllerAnimatedTransitioning** - the animator objects will describe the animations.

**UIViewControllerContextTransitioning** - the animator objects will be passed a context object for the transition. This context holds details about the presenting and presented controllers and views.

To create this transition, you will subclass UIStoryboardSegue. In this subclass, you will set the destination controller's transition delegate to be your fade animation instead of the Vertical Cover.

Create a new file called **FadeSegue.swift** that subclasses **UIStoryboardSegue**.

Change the class definition to include the transition delegate protocol:

    class FadeSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {

Override the segue's perform() method:

```swift
  override func perform() {
    destinationViewController.transitioningDelegate = self
    super.perform()
  }
```

Here you set the destination view controller's transitioning delegate so that the segue will take control of transition animations.

In previous iOS versions, you might have put the transition animation in perform(), but now the animation is decoupled from the segue by using this transitioning delegate.

The transitioning protocol allows the segue to override both the presenting and dismissing animations. After you have created the animator class, you will return to the FadeSegue class to add these animations. 

Add a new animator class to the end of **FadeSegue.swift**

```swift
class FadeAnimator:NSObject, UIViewControllerAnimatedTransitioning {
  var isPresenting = false
}
```

FadeAnimator will be used for both presenting and dismissing. The property `isPresenting` will keep track of which is happening.

FadeAnimator conforms to UIViewControllerAnimatedTransitioning. This protocol requires that you specify the transition duration and also the actual transition animation.

Firstly specify how long the animation will take to run. Add this method to the FadeAnimator class:

```swift
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 2.0
  }
```

You have specified 2 seconds here. Most transitions have a duration of about 0.3-0.5 seconds, but this is deliberately slow so that you can see the effect clearly. Later you can change this value to 0.5.
  
Now for the actual animation. I'll break this up as it's quite a long method. But once you understand how this animation method fits together, all other animations will take the same pattern.

```swift
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
```

Here you extract from the transitioning context ``fromView`` which is the presenting view, and ``toView`` which is the view that will be presented.

> **Note**: *Beware!* Make sure that you use the correct key variables. I have spent significant time wondering why my view is incorrect, when I have used UITransitionContextToViewControllerKey instead of UITransitionContextToViewKey! And it's also easy to mix up From and To.

Continue in the same method:

```swift
    if isPresenting {
      toView?.alpha = 0.0
      if let toView = toView {
        transitionContext.containerView()?.addSubview(toView)
      }
    } 
```

If the modal view controller is being presented, the transition animation will go from 100% `fromView` to 100% `toView`. `toView` is not yet in the view hierarchy, so needs to be added for the duration of the transition.

You also set the value of `toView`'s alpha property to be 0, so that even though `toView` is in the hierarchy, it is fully transparent at the beginning of the animation.

Continue adding to the same method:

```swift 
    else {
      if let fromView = fromView {
        if let toView = toView {
          transitionContext.containerView()?.insertSubview(toView, belowSubview: fromView)
        }
        fromView.alpha = 1.0
      }
    }
```

If the modal view controller is being dismissed, `toView` will be the view underneath. On an iPhone, this view has been taken out of the view hierarchy because modal views fully cover the screen. So `toView` needs to be added back in to the view hierarchy so that it will be seen during the animation.

Now add the actual animation to the end of the same method:

```swift
    let duration = transitionDuration(transitionContext)
    
    UIView.animateWithDuration(duration, animations: {
      if self.isPresenting {      
        // 1
        if let toView = toView {
          toView.alpha = 1.0
        }
        
      } else {
        // 2
        if let fromView = fromView {
          fromView.alpha = 0.0
        }
      }
      }, completion: {
        // 3
        finished in
        transitionContext.completeTransition(true)
    })
  }
}
```
Here you set up animation blocks using the duration from the 2 second `transitionDuration(_:)` method.

1. If the transition is presenting, animate `toView` from 0 to 1 to make the modal view appear
2. If the transition is dismissing, animate `fromView` from 1 to 0  to make the modal view fade away.
3. The completion block will always look the same. The `transitionContext` must always clean up the view hierarchy.

Now you have created the animations, you must set the segue to use these animations. 

Inside the **FadeSegue** class, add the method that declares the animator object to be used for presenting:

```swift
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let fade = FadeAnimator()
    fade.isPresenting = true
    return fade
  }
```

Similarly, add the method to declare the dismissal animator object. It will be the same animator, but the animator's `isPresenting` property will be set to false:

```swift
 func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let fade = FadeAnimator()
    fade.isPresenting = false
    return fade
  }
```

Whew! To recap, this is what you have just done:

1. subclassed UIStoryboardSegue
2. set the segue as the destination controller's transitioning delegate
3. created the animator class conforming to UIViewControllerAnimatedTransitioning
4. defined the animation in the animator's animateTransition()
5. told the segue what animator class to use
6. used the segue in the storyboard

Whenever you create any custom segue, no matter what wild animations you have in mind, you will always follow those steps.

Now to use your custom Fade Segue.

In **Main.storyboard**, select the **PhotoDetail** segue you created earlier between **AnimalDetailViewController** and **AnimalPhotoViewController**.

Change the Segue Class to FadeSegue.

Change Presentation to Form Sheet.

Run the application. The presented controller fades (slowly) in over the presenting controller. Notice that the unwind segue has automatically taken the same fade transition. Run on both iPhone and iPad. Notice that the iPad fades in the form sheet, whereas the iPhone fades in the full screen.

## View hierarchy 

viewToKey and not .view property

In animateTranstion(:) you got the view from the transitionContext.viewForKey(:) method. You may wonder why you didn't use the destination controller's view. In the FadeSegue example, on the iPhone, the viewForKey method returns the same view as the destination controller's view because there is no presentation layer, and the destination is presented full screen. On an iPad, the destination controller is wrapped in a presentation layer, which provides the dimming view and rounds the corners of the destination view. This means that if you were referring to the destination controller's view, you would be fading in the destination, but not the presentation layer.

In addition, you will be embedding the source controller inside a navigation controller later in the tutorial, and things will become even more tricky.

## Create more complex custom segue 

On to a slightly more complex example. What happens when you want to send data from the source view controller to the animation? For example, in **PamperedPets** if you want to tap the photo and have it smoothly scale up to the larger photo, how do you tell the animator object what view it is scaling? There's so much decoupling happening, that you don't have a direct reference. 

This is where you will create a protocol for a view controller to set its scaling view. The animator object will then use the protocol's scaling view without having to know anything about the view controller.

You'll follow exactly the same procedure as before. So first create a new file called **ScaleViewSegue.swift** as a subclass of **UIStoryboardSegue**.

Declare **ScaleViewSegue** to conform to **UIViewControllerTransitioningDelegate**:

    class ScaleViewSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {

Override perform() in exactly the same way as you did before:

```swift
 override func perform() {
    destinationViewController.transitioningDelegate = self
    super.perform()
  }
```

This time you will split out the presentation and dismissal animations. You could have a variable that tests whether you are presenting or dismissing, but the code gets harder to read.

Create the protocol that any view controller using this segue must conform to:

```swift
protocol ViewScaleable {
  var scaleView:UIView { get }
}
```

Any view controller that wants to present a modal view using this scaling segue must create a scaleView property and return a value.

Declare AnimalDetailViewController to conform to ViewScaleable. Add this to the end of **AnimalDetailViewController.swift**:

```swift
extension AnimalDetailViewController: ViewScaleable {
  var scaleView:UIView { return imageView }
}
```

All this does is set the protocol property so that the view to use for scaling is the imageView.

Now back in **ScaleViewSegue.swift**, create the presenting animator class:

```swift
class ScalePresentAnimator:NSObject, UIViewControllerAnimatedTransitioning {

}
```

Add the duration method to the animator:

```swift  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 2.0
  }
```

add the animation method. This time you will be getting the presenting view controller from the transitioning context as well as the views, so that you will be able to extract the scaling view details from the view controller
 
 ```swift
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
    if let toView = toView {
      transitionContext.containerView()?.addSubview(toView)
    }

    let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
```

Here you added the `toView` to the view hierarchy just as you did before. You also extracted the to and from view controllers from the transitioning context. 


Continue in the same method:

```swift
    if let fromViewController = fromViewController as? ViewScaleable {
```

This is where you check to make sure that the presenting view controller conforms to `ViewScalable` - if it does, you know that you will be able to retrieve the view to be scaled. 

In the same method:

```swift
      let finalFrame = transitionContext.finalFrameForViewController(toViewController)
      let startFrame = fromViewController.scaleView.frame
      
      toView?.frame = startFrame
      toView?.layoutIfNeeded()
 ```

The transition context provides you with the final frame that the modal view controller's view hierarchy will end up with.

You initialize `toView`'s frame to be the frame from the view to be scaled, and with layoutIfNeeded() you ensure that all auto layout constraints are performed. Without this step, the smooth scaling of the larger image view won't happen.

Now, just as you did before, specify the animation blocks:

```swift
      let duration = transitionDuration(transitionContext)
      
      UIView.animateWithDuration(duration, animations: {
        if let toView = toView {
          toView.frame = finalFrame
          toView.layoutIfNeeded()
        }
        }, completion: {
          finished in
          transitionContext.completeTransition(true)
      })
    } 
```

Here you animate `toView`'s frame from `startFrame` to `finalFrame`. You also make sure that the transition context will perform its cleanup in the completion block.

And lastly, in the same method, print out a warning if a view controller has been used that doesn't conform to your ViewScaleable protocol:

```swift
    else {
      // Not Scaleable
      print("Warning: Controller: \(toViewController) does not conform to ViewScaleable")
      transitionContext.completeTransition(true)
    }
  }
}
```

The cool thing about using the ViewScalable protocol to pass values, is that the animator object does not need to know anything about the view controller except that it conforms to ViewScaleable. 

Set up the segue to point to this animator:

```swift
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ScalePresentAnimator()
  }
```

In **Main.storyboard** select the segue between **AnimalDetailViewController** and **AnimalPhotoViewController**, and change the **Segue Class** to **ScaleViewSegue**.

Run the application, tap the photo and to the user it looks like the small photo view is scaling up into the presented view. Whereas behind the scenes, it is a completely different view and a different view controller.

The dismiss animator is done in the same way. On the iPhone, the presenting view is removed from the view hierarchy, so you need to make sure that it is added back in behind the presented view so that the background is not black when you are scaling.

```swift
class ScaleDismissAnimator:NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 2
    
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!

    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)

    if let fromView = fromView {
      if let toView = toView {
        transitionContext.containerView()?.insertSubview(toView, belowSubview: fromView)
      }
    }

    if let toViewController = toViewController as? ViewScaleable {
      let finalFrame = toViewController.scaleView.frame
      let duration = transitionDuration(transitionContext)
      
      UIView.animateWithDuration(duration, animations: {
        if let fromView = fromView {
          fromView.frame = finalFrame
          fromView.layoutIfNeeded()
        }
        }, completion: {
          finished in
          transitionContext.completeTransition(true)
      })
    } else {
      // Not Scaleable
      print("Warning: Controller: \(toViewController) does not conform to Scaleable")
      transitionContext.completeTransition(true)
    }
  }
  
}
```

Try it on the iPad as well as the iPhone. The scaling of the image into the form sheet is really cool.

### When view controllers are embedded

But perhaps you need to mind more than one pet? Now you will set the list of pets to be the initial view controller of the application.

In **Main.storyboard**, select the **Navigation Controller** on the very left of the storyboard. In the **Attributes Inspector** tick **Is Initial View Controller**.

Run the application. The app will now start with a list of all pets to be minded. Select one, and tap the photo to see your scaling animation.

[wtf]

The animation doesn't work any more! If you look in the debug console, you will see the print warnings that your code puts out if the presenting view controller does not conform to ViewScalable.

This is because the view controller is now embedded within a Navigation Controller. So the Navigation Controller is now the presenting view controller, not the AnimalDetailViewController.

Fortunately, this is easily fixed. To be reusable in multiple situations, you can find out whether the presenting view controller is a Navigation Controller, and if so, take the Navigation Controller's top view controller as the presenting view controller.

In ScaleViewSegue.swift, at the top of the ScalePresentAnimator class, where it says:

    let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)

change it to:

```swift
    var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
    if let from = fromViewController {
      if let fromNC = from as? UINavigationController {
        fromViewController = fromNC.topViewController
      }
    }
```

And the same thing in ScaleDismissAnimator - change 

    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!

to 

```swift
    var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
    if let controller = toViewController as? UINavigationController {
      if controller.topViewController != nil {
        toViewController = controller.topViewController!
      }
    }
```

Run the application again, and the scale transition should now work as expected.

Reusable segues need to be aware that they may be used by container controllers. The presenting controller may embedded in a UITabBarController, so you could add similar code to make the segue usable in that situation too.

## Segues are adaptable

With multitasking on the iPad, your users could be changing the size of your app at any time. This means that popovers which are generally used for a regular size class such as the iPad, could be switching to full screen in a compact size class. The user can tap outside a popover to dismiss it, but needs to have a button to dismiss a full screen. 

Because the segue is retained during a popover presentation, the segue can take responsibility for adaptivity, and can substitute different presented view controllers whenever the size class changes.

You'll now hook up the Vet Information to be a popover.

In **Main.storyboard** ctrl-drag from the **Vet Information button** to the small **Vet Information** Scene. Choose **popover presentation** from the popup menu. Select the segue that you just created and in the **Attributes Inspector** set **Segue Class** to **VetSegue**.

Run the application on the Ipad Air 2 simulator in landscape so that you can test size class changes. 

Click on the Vet Information button, and you will see a popover. Go into split screen mode with your app taking up half the screen, and the popover will adapt into full screen. This functionality is automatic.

But the problem is that the popover in split screen turns into a full screen and the user has no way to dismiss it.

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

When the size class changes to compact, instead of the segue transtioning directly to the Vet Information screen, you want it to transition to a Navigation Controller. This has already been created for you on the storyboard, with a name of VetNavigationController.

Create the delegate method that will be called when the size class changes to compact:

```swift
  func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("VetNavigationController")
  }
```

VetNavigationController, which has the Vet Information Scene embedded, will now be called when the size class changes to compact.

Run the app and try it out, switching between regular and compact sizes. When the app is shown full screen on the iPad, the popover will show, but when you resize the app to half the screen, the navigation controller will show, so that the user has a button to dismiss the Vet Information.

This is really useful that you can switch between different view controllers so easily, but in this app, the information is so small that you could actually show it as a popover on a compact size class as well.

Comment out the method you just created, as you won't be using it any more.

There's a method available in UIAdaptivePresentationControllerDelate to specify what presentation style to use. Add this to your **VetSegue** extension:

```swift
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    return .None
  }
```

Returning `UIModalPresentationStyle.None` tells the system that for any size device you want it to show a nonmodal presentation style.

Run the application on an iPhone, and see your popover. 

## Process for creating custom segues


The transition animation process is made more daunting by all the protocols and long method names. But boiled down to a simple sequence, this is all you have to do to create a new custom segue in your segue library:

1. subclass UIStoryboardSegue
2. set segue as destination controller's transitioning delegate
3. create animator class conforming to UIViewControllerAnimatedTransitioning
4. define the animation in animateTransition()
4. set segue to use animator in animationControllerForPresentedController and animationControllerForDismissedController
5. use in storyboard

## Where To Go From Here?

Retaining segues during a modal/popover presentation is a small change, but one that has huge consequences. Previously view controllers had to know about the transitions they were using, and also the styles they were going to be presented in. 

Now the segue can take full responsibility for that. You can now create any segue with its own transition animation or adaptive style and reuse that segue in all your apps. You can also swap segues to see what looks best for each scene transition without having to update any code.

This chapter has been a basic introduction into the modern method of creating custom segues, but you can find out much more about transitions and adaptivity in our previous books:

* **iOS 7 by Tutorials** - Chapter 3 Custom View Controller Transitions
* **iOS 8 by Tutorials** - Section 1 Adaptive Layout

To be able to create any animation you can think of, I highly recommend our book:

* **iOS Animations by Tutorials**

##Challenge

In this chapter you learned how to set up custom segues and to pass data to them using protocols.

To help cement your new skills, here's a challenge for you

### A Swipe segue

Your challenge is to replace the dismissing part of the Scaling segue with a new reusable animation that takes an up or down swipe direction and slides the photo away in the direction of the swipe.

Here are some tips:

* Add a new animator object similar to the Scaling dismissal animator that moves the presented frame off either the top of the screen or the bottom of the screen depending on swipe direction.
* Add a new protocol Swipeable that stores the swipe direction
* Add two swipe gestures, one up and one down, to the AnimalPhotoViewController image view. Attach a handler to them to store the swipe direction
* Add an extension to the view controller to give Swipeable that direction
* Change the existing Scaling segue to use your new animator object

You'll find the solution in the sample code.

