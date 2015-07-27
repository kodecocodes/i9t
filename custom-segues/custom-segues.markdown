# Chapter 6: Custom Segues

Segues have been around since storyboards were first introduced in iOS 5. In iOS 7, transitions were reified - they became their own object. 

A small but important change to how segues are retained will make your life much easier. When custom segues are now be presented as modal or popover presentations, they will be retained until the presented controller is dismissed.

In effect, this means that you can move all the transition animation and adaptivity into a segue class. This segue can then be reused in any storyboard. When the modal scene is presented, you don't have to consider the unwind transition - it just uses the segue transition presentation.

If you decide to change the appearance of the segue transition, you just change the segue in the storyboard to another one in your segue repertoire. This will immediately change the presenting and unwinding transition animations.

In this chapter you will discover how to start your own library of custom segues. You'll find out how to:

* Create the segue
* Animate the segue
* Make your segue reusable within navigation and tab controllers
* Adapt between different size classes




## Getting Started

The app you will be updating today is a pet minding app called **PamperedPets**. It's a very simple app so far, with just a list of pets to be minded and details about each one.

![iPhone](images/PamperedPets.png)

Explore your starter project and see how it works. When you run the app, you will see a single scene which shows a single pet.

When you have finished this chapter, your app will start out by showing a list of all the animals to be minded. When you tap an animal in the table that animal's information will be displayed. 

The app is very simple, but the animated transitions that you will create will raise your app from lacklustre to rock star.

## Segue Review

Have a look at Main.storyboard.

![bordered width=90%](images/Storyboard.png)

This will be the final flow of the app. Currently the app is starting on the Animal Detail scene.

As you will know from the previous chapter, segues are indicated by arrows between the view controller scenes. These segue types can be:

* Show. This segue presents into the master.
* Show Detail. Presents into teh detail.
* Present Modally. Presents a scene on top of the current scene.
* Popover. Present as a popover on the iPad or full screen on the iPhone.

You will now create a very basic modal segue. When the user taps the photo in the AnimalDetailViewController scene, the AnimalPhotoViewController scene will be presented as a modal controller, showing the photo larger. 

There are two main parts of a segue.

1. First prepareForSegue() is done when the segue is activated. This is where you set up the destination view controller - in this case AnimalPhotoViewController - with the necessary data.
2. The destination controller's transition is then performed. Initially you will use the default transition, but shortly you will customize that.

Firstly, in Main.storyboard, select AnimalDetailViewController. Drag a Tap Gesture Recognizer onto the Image View.

In the Document Outline ctrl-drag from this Tap Gesture Recognizer to Animal Photo View Controller.

Choose Present Modally from the menu. 

You've now defined the segue transition. Now you will set up AnimalPhotoViewController so that it shows the correct photo.

Select the segue arrow between the two scenes, and give the segue an Identifier PhotoDetail. 

In AnimalDetailViewController create the prepareForSegue() method:

```swift
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "PhotoDetail" {
      let controller = segue.destinationViewController as! AnimalPhotoViewController
      controller.imageView.image = imageView.image
    }
  }
```

Here you give the destination controller, in this case AnimalPhotoViewController, the image to display.

Run the application and tap the photo. The larger image will slide up the screen. There is currently no way for the user to close this screen. So you will now create an unwind segue.

In AnimalDetailViewController.swift add this method:

```swift
  @IBAction func unwindToAnimalDetailViewController(segue:UIStoryboardSegue) {

  }
```

This method won't contain any code. Any method with a signature of @IBAction func methodName(segue:UIStoryboardSegue) is considered by the system to be a marker for a Storyboard segue to unwind to.

In Main.storyboard select the Animal Photo View Controller scene. Drag a Tap Gesture Recognizer onto the Image View. 

In the Document Outline ctrl-drag from this Tap Gesture Recognizer to Exit just above. Select unwindToAnimalDetailViewController from the popup menu.

Run the app again, and tap the photo. The larger photo will transition in by sliding up the screen, and they you can tap the larger photo to unwind back to the first screen.

Let's dissect what's happened here. The source view controller, AnimalDetailViewController initiated a Modal segue. 

The segue is told the source view controller and the destination view controller. 

Behind the scenes, the segue sets the transitioning delegate of the destination view controller to the transition of choice. In this case the default transition - Cover Vertical. 

The source view controller then prepares for the segue to happen by setting up the data for the destination view controller.

Adaptivity in here somewhere.

Control is turned over to the destination controller. The destination controller invokes its delegate transition, so the slide up transition animation happens.

That covers what a segue will do. You are now going to change the transition animation in a segue subclass.

If you want to explore this in further detail, have a look at Custom Transitions in iOS 7 by Tutorials.

## Choosing a segue from your custom segue library

In Main.storyboard, change the default segue to XXXtransitionSegue. Run the application and notice that the segue transition and unwind transition have completely changed and you didn't have to change a single line of code.

## Create simple custom segue

You'll now create your own custom segue from scratch. The easiest transition to demonstrate is a Fade transition animation, where a view's alpha property animates from 0 to 1 on presentation, so that is what you will be doing.

To create this transition, you will subclass UIStoryboardSegue. In this subclass, you will set the destination controller's transition delegate to be your fade animation instead of the Vertical Cover.

Create a new file called FadeSegue.swift subclassing UIStoryboardSegue.

change the class definition to include the transition delegate protocol:

    class FadeSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {

Override the segue's perform() method:

```swift
  override func perform() {
    destinationViewController.transitioningDelegate = self
    super.perform()
  }
```

Here you set the destination view controller's transitioning delegate so that the segue will take control of transition animations.

In previous iOS versions, you might have put the transition animation in perform(), but the animation is further decoupled from the segue using this delegate.

Add a new animator class to the end of FadeSegue.swift

```swift
class FadeAnimator:NSObject, UIViewControllerAnimatedTransitioning {
  
  var isPresenting = false
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 2.0
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
    
    if isPresenting {
      toView?.alpha = 0.0
      if let toView = toView {
        transitionContext.containerView()?.addSubview(toView)
        //in an iPad form sheet if you add toViewController.view, then it goes wonky
        //because the view is presented within a presentation view
      }
      
    } else {
      if let fromView = fromView {
        if let toView = toView {
          transitionContext.containerView()?.insertSubview(toView, belowSubview: fromView)
        }
        fromView.alpha = 1.0
      }
    }
    
    let duration = transitionDuration(transitionContext)
    
    UIView.animateWithDuration(duration, animations: {
      if self.isPresenting {
        if let toView = toView {
          toView.alpha = 1.0
        }
        
      } else {
        if let fromView = fromView {
          fromView.alpha = 0.0
        }
      }
      }, completion: {
        finished in
        transitionContext.completeTransition(true)
    })
    
  }
  
}
```

Explain...

In Main.storyboard, select the segue between AnimalDetailViewController and AnimalPhotoViewController.

Change the Segue Class to FadeSegue.

Change Presentation to Form Sheet.

Run the application. The presented controller fades (slowly) in over the presenting controller. Notice that the unwind segue has automatically taken the same fade transition. Run on both iPhone and iPad. Notice that the iPad fades in the form sheet, whereas the iPhone fades in the full screen.

You can change the speed of the transition in transitionduration to be a sensible speed.

*this could be earlier - could have a nice library segue before actually writing your own.*

A major new feature in iOS 9 is that the custom segue is retained for the duration of a modal popover. In previous iOS versions, as soon as the segue finished presenting, it was deallocated. This meant that you had to set the unwind to have its own custom segue.

Because the segue is now retained, it's really easy in the Storyboard to change out segues from your library without having to touch your UIViewController code.

## View hierarchy 

viewToKey and not .view property

In animateTranstion(:) you got the view from the transitionContext.viewForKey(:) method. You may wonder why you didn't use the destination controller's view. In the FadeSegue example, on the iPhone, the viewForKey method returns the same view as the destination controller's view because there is no presentation layer, and the destination is presented full screen. On an iPad, the destination controller is wrapped in a presentation layer, which provides the dimming view and rounds the corners of the destination view. This means that if you were referring to the destination controller's view, you would be fading in the destination, but not the presentation layer.

In addition, you will be embedding the source controller inside a navigation controller later in the tutorial, and things will become even more tricky.

## Create more complex custom segue 

On to a slightly more complex example. What happens when you want to send data from the source view controller to the animation? For example, in **PamperedPets** if you want to tap the photo and have it smoothly scale up to the larger photo.  How do you tell the animation what view it is scaling? There's so much decoupling happening, that you don't have a direct reference. (Good!).

This is where you will create a protocol for a view controller to set its scaling view. The animation will then use the protocol's scaling view without having to know anything about the view controller.

You'll follow exactly the same procedure as before. So first create a new file called ScaleViewSegue.swift as a subclass of UIStoryboardSegue.

Declare ScaleViewSegue to conform to UIViewControllerTransitioningDelegate:

    class ScaleViewSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {

Override perform() in the same way:

 override func perform() {
    destinationViewController.transitioningDelegate = self
    super.perform()
  }

This time you will split out the presentation and dismissal animations. You could have a variable that tests whether you are presenting or dismissing, but the code gets harder to read.

Create the protocol that any view controller using this segue must conform to:

```swift
protocol ViewScaleable {
  var scaleView:UIView { get }
}
```

So any view controller that wants to use this scaling segue must create a scaleView property and return a value. Later you'll be setting this scaleView to be the photo view.

Create the presenting animator first:

```swift
class ScalePresentAnimator:NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 2.0
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
    let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)

    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
    if let toView = toView {
      transitionContext.containerView()?.addSubview(toView)
    }

    if let fromViewController = fromViewController as? ViewScaleable {
      let finalFrame = transitionContext.finalFrameForViewController(toViewController)
      let startFrame = fromViewController.scaleView.frame
      
      toView?.frame = startFrame
      toView?.layoutIfNeeded()
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
    } else {
      // Not Scaleable
      print("Warning: Controller: \(toViewController) does not conform to Scaleable")
      transitionContext.completeTransition(true)
    }
  }
}
```

Here you have retrieved the view to scale because the animator knows that the view controller has this property. Remember that the animator does not need to know anything about the class of the view controller except that it conforms to ViewScaleable. 

Set up the segue to point to this animator:

```swift
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ScalePresentAnimator()
  }
```

Declare AnimalDetailViewController to conform to ViewScaleable. Add this to the end of AnimalDetailViewController.swift:

extension AnimalDetailViewController: ViewScaleable {
  var scaleView:UIView { return imageView }
}

All this does is tell the protocol that the view to use for scaling is the imageView.

In Main.storyboard select the segue between AnimalDetailViewController and AnimalPhotoViewController, and change the Segue Class to ScaleViewSegue.

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

But perhaps your collection of dinosaurs includes more than one. Now you will set the list of dinosaurs to be the initial view controller of the application.

In Main.storyboard, select the Navigition Controller on the very left of the storyboard. In the Attributes Inspector tick Is Initial View Controller.

Run the application. The app will now start with a list of your collection. Select one, and tap the photo to see your scaling animation.

[wtf]

The animation doesn't work any more. If you look in the console, you will see the print warnings that your code puts out if the presenting view controller does not conform to ViewScalable.

This is because the view controller is now embedded within a Navigation Controller. So the Navigation Controller is now the presenting view controller, not the AnimalDetailViewController.

Fortunately, this is easily fixed. To be reusable in multiple situations, you can find out whether the presenting view controller is a Navigation Controller, and if so, take the current view controller of the Navigation Controller as the presenting view controller.

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

Reusable segues need to be aware that they may be used by container controllers. The presenting controller may embedded in a UITabBarController, so the same code should be added to make the segue usable in that situation too.

### Segues are adaptable

Popovers can be popovers on iPhone as well as iPad 

Segue responds to adaptivity by substituting different view controllers

## Process for creating custom segues

The transition animation process is made more daunting by all the protocols and long method names. But boiled down to a simple sequence, this is all you have to do to create a new custom segue in your segue library:

1. subclass UIStoryboardSegue
2. set segue as destination controller's transitioning delegate
3. create animator class conforming to UIViewControllerAnimatedTransitioning
4. define the animation in animateTransition()
4. set segue to use animator in animationControllerForPresentedController and animationControllerForDismissedController
5. use in storyboard

## Where To Go From Here?
i7t Transitions
i8t Adaptivity
iOS Animations by Tutorials
Apple “View Controller Programming Guide - Customizing the Transition Animations” article

##Challenge

Make a reusable sliding segue with animator using swipe direction 
