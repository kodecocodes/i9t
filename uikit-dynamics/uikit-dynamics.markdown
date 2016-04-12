```metadata
author: "By Aaron Douglas"
number: "11"
title: "Chapter 11: UIKit Dynamics"
```

# Chapter 11: UIKit Dynamics

iOS applications live in the hands of the people using them. Until somebody taps, swipes and enjoys your work, it sits in suspended animation on a device. Users have come to expect our mobile apps to react to touch and to provide some semblance of "realness". Your app's success depends in part on how much the user enjoys its responsiveness.

iOS 7 introduced the idea of flatness in user interfaces rather than the heavily skeuomorphic concepts we previously experienced. Instead of heavy interfaces, users bond with apps through animations and reactions to touch that mirror real-world physics.

__UIKit Dynamics__ is a 2D physics-inspired animation system designed with a high-level API, allowing you to simulate the physical experiences in your animations and view interactions. Originally introduced in iOS 7, UIKit Dynamics saw very few changes in iOS 8. 

iOS 9 is a different matter. With this update we get a bunch of exciting new things like gravity and magnetic fields, non-rectangular collision bounds and additional attachment behaviors.

> **Note**: This chapter will primarily focus on the new features in UIKit Dynamics for iOS 9. Check out chapter 2, "UIKit Dynamics and Motion Effects" of iOS 7 by Tutorials for a full introduction to the original APIs.

$[=p=]

## Getting started
UIKit Dynamics is definitely a technology you have to learn through playing. Make sure you're using an Xcode Playground to follow along and watch the changes live!

### Create the playground

Open Xcode, select __File\New\Playground...__  and enter __UIKit Dynamics__ for the name and set __Platform__ to __iOS__. Click __Next__. Choose a location for your playground and click __Create__. 

Once the playground opens, replace the contents with: 

```swift
import UIKit
import XCPlayground

let view = UIView(frame: CGRect(x: 0, y: 0,
  width: 600, height: 600))
view.backgroundColor = UIColor.lightTextColor()
XCPShowView("Main View", view: view)

let whiteSquare = UIView(frame: CGRect(x: 100, y: 100,
  width: 100, height: 100))
whiteSquare.backgroundColor = UIColor.whiteColor()
view.addSubview(whiteSquare)

let orangeSquare = UIView(frame: CGRect(x: 400, y: 100,
  width: 100, height: 100))
orangeSquare.backgroundColor = UIColor.orangeColor()
view.addSubview(orangeSquare)
```

You just created a view and added two subviews while giving each a different color, but you don't see anything! 

![width=30%](images/where_is_exiting_output.png)

Find it by switching to the assistant editor; simply press __Option + Command + Enter__ to bring it up quickly. You should see something like this now:

![bordered width=90%](images/playground_step1_assistant_editor.png)

> **Note**: XCPShowView(_:) is responsible for the magic of rendering your view in the assistant editor. Sometimes Xcode 7 doesn't re-run your Playground after making a change. You can force Xcode to re-run by selecting the menu item __Editor\Execute Playground__.

Add the following line after the second subview:

```swift
let animator = UIDynamicAnimator(referenceView: view)
```

`UIDynamicAnimator` is where all the physics voodoo happens. The dynamic animator is an intermediary between your dynamic items — UIView subviews in this case — the dynamic behaviors you create, and the iOS physics engine. It provides a context for calculating the animations before rendering. 

**Dynamic behaviors** encapsulate the physics for a particular desired effect like gravity, attraction or bounce. **Dynamic animators** keep track of where all of your items are during the animation process. The `referenceView` you passed in is the canvas where all the animation takes place. All of the views you animate _must_ be subviews of the reference view.

$[break]
### Your first behavior

`UIDynamicBehavior` is the base class that describes an effect for one or more dynamic items, like your subviews, and how they take part in the animation. Apple provides a bunch of behaviors, but the easiest one to start with is `UIGravityBehavior`. It's perfect since developers are like cats — we can't help it that we like to see things fall.

![width=40%](images/and_bounce_and_explode.png)

Add the following line:

```swift
animator.addBehavior(UIGravityBehavior(items: [orangeSquare]))
```

This adds a basic gravity behavior to the orange square. See it fall off the screen in the assistant editor? 

That took two lines of code. You should be feeling amazed and empowered right now. 

Now you'll make the box stop at the bottom of the screen.

```swift
let boundaryCollision = UICollisionBehavior(items:
  [whiteSquare, orangeSquare])
boundaryCollision.translatesReferenceBoundsIntoBoundary = true
animator.addBehavior(boundaryCollision)
```

Adding a collision behavior and setting `translatesReferenceBoundsIntoBoundary` to `true` makes the border of the reference view turn into a boundary. Now when the orange square falls, it stops and bounces at the bottom of the view. 

By default, all dynamic items get a set of behaviors that describe how heavy they are, how much they slow down due to movement, how they respond to collisions and several other physical traits. `UIDynamicItemBehavior` describes these traits.

$[=s=]

Change the way the orange square responds to the collision:

```swift
let bounce = UIDynamicItemBehavior(items: [orangeSquare])
bounce.elasticity = 0.6
bounce.density = 200
bounce.resistance = 2
animator.addBehavior(bounce)
```

A dynamic item’s density, along with its size, determines its "mass" when it participates with other behaviors.  Elasticity changes how much an item bounces in a collision – the default is 0.0. Resistance represents a frictional force — reducing linear velocity until the item comes to rest.

Take a moment to play around with these values and observe how the animation changes.

Add this line to the end of the playground:

```swift
animator.setValue(true, forKey: "debugEnabled")
```

This is a new undocumented feature in iOS 9 that turns on a visual debugging mode. It was mentioned in the 2015 WWDC session *What's New in UIKit Dynamics and Visual Effects* ([apple.co/1IO1nF3](http://apple.co/1IO1nF3)). Although this was described as only being available through the LLDB console, it transpires that you can also enable it via key-value coding using method shown. Debug mode shows cool things like attachments, collision locations and visualizations of field effects. 

You'll notice the orange box, when animating, shows a blue border, which visually describes the collision borders for the item. 

Leave this debug mode turned on for the remainder of this tutorial.

### Behaviors

There are a number of types of behaviors to play around with: 

* `UIAttachmentBehavior` – This specifies a connection between two dynamic items or a single item and an anchor point. New to iOS 9 are variants for a sliding attachment, a limit attachment that acts like a piece of rope, a fixed attachment that fuses two items, and a pin attachment that creates the effect of two items connected by a piece of rope hanging over a pin.
* `UICollisionBehavior` – As you've seen already, this behavior declares that an item has a physical interaction with other items. It can also make the reference view turn its border into a collision border with `translatesReferenceBoundsIntoBoundary`.
* `UIDynamicItemBehavior` – This is a collection of physical properties for a dynamic item that are common to multiple behavior types. You've seen friction, density and resistance already. In iOS 9, you can anchor an item to a spot and also change the charge for an item when it's participating in a magnetic or electric field behavior.
* `UIFieldBehavior` – Totally _new_ in iOS 9, this adds a number of physical field behaviors, including electric, magnetic, dragging, vortex, radial and linear gravity, velocity, noise, turbulence and spring fields.
* `UIGravityBehavior` – Adds a gravity field to your views so they react by falling in a particular direction, with constant acceleration.
* `UIPushBehavior` – Applies a force to dynamic items, pushing them around.
* `UISnapBehavior` – Moves a dynamic item to a specific point with a springy bounce-like effect.
* Composite behaviors – You can combine behaviors together for easy packaging and reuse.

### MOAR playground

You're probably eager to get lost in the playground with all these new "toys", and now you'll get your chance. Add this code to your playground:

```swift
let parentBehavior = UIDynamicBehavior()

let viewBehavior = UIDynamicItemBehavior(items: [whiteSquare])
viewBehavior.density = 0.01
viewBehavior.resistance = 10
viewBehavior.friction = 0.0
viewBehavior.allowsRotation = false
parentBehavior.addChildBehavior(viewBehavior)
```

Here you've defined a parent behavior, which doesn't do anything, then you added some physical properties to the white square. Carry on by adding this code:

```swift
let fieldBehavior = UIFieldBehavior.springField()
fieldBehavior.addItem(whiteSquare)
fieldBehavior.position = CGPoint(x: 150, y: 350)
fieldBehavior.region = UIRegion(size: CGSizeMake(500, 500))
parentBehavior.addChildBehavior(fieldBehavior)
```

This is one of the new field behaviors. A spring field will drag items caught inside its region to the center. The further out they are, the harder it is to pull them in, so they'll bounce around the center for a while before settling. Note that you've added this spring behavior to the parent behavior.

Now add the composite behavior to the dynamic animator:

```swift
animator.addBehavior(parentBehavior)
```

Did you see the bouncy snag of the white square? Re-execute the Playground if you didn't. Also, check out the little red lines; this is debug mode showing you the direction and strength of the spring field:

![width=50%](images/field_visualisation.png)

`UIFieldBehavior` is one of the new behaviors in iOS 9 and arguably the coolest one. Spring fields are great for positioning an element because the region's center draws it in while it bounces into place. Give the white square a little time-delayed push to understand the effect:

```swift
let delayTime = dispatch_time(DISPATCH_TIME_NOW,
  Int64(2 * Double(NSEC_PER_SEC)))

dispatch_after(delayTime, dispatch_get_main_queue()) {
  let pushBehavior = UIPushBehavior(items: [whiteSquare],
    mode: .Instantaneous)
  pushBehavior.pushDirection = CGVector(dx: 0, dy: -1)
  pushBehavior.magnitude = 0.3
  animator.addBehavior(pushBehavior)
}
```

Now you can really see the power of the spring field! The `UIPushBehavior` gave the white square a nudge upwards and it sprung right back to the center of the field. Push direction is a vector and setting _y_ to -1 means up. 

The magnitude of the push behavior is set to a small number because the density is set to a small value — the normal push magnitude would kick that box out of the field. 

Try removing the magnitude, and you'll notice it does exit the field; however, the collision boundary bounces it back into play.

> **CHALLENGE**: Try attaching the orange box to a point with a `UIAttachmentBehavior` behavior. Use the `init(_:attachedToAnchor:)` method to anchor it to the point. Check out the end of the accompanying playground for the solution. You might like to _play around_ with the _playground_ (that's kind of the point!) to see what other effects you can create.

## Applying dynamics to a real app

Playing around with UIKit Dynamics in a Playground is fun — but it's not real until it's in an app. UIKit Dynamics is really designed for non-game applications. In reality, your application may only need dynamics in a few key places to give it that extra "pop" you're after. A little goes a long way!

### Meet DynamicPhotoDisplay

For this part, you'll work with simple photo viewing application. The user sees a scrolling list of photo thumbnails and taps them to see a full screen version. 

You'll find the starter project as well as the final solution in the resources folder for this chapter.  Open it in Xcode and build and run it. You should see the following:

![width=70% print](images/dynamicphotodisplay_initialwithfull.png)
![width=80% screen](images/dynamicphotodisplay_initialwithfull.png)

You'll notice the full screen view of a photo shows a bit of metadata. The user might encounter a photo where that metadata box obscures a part of the photo. 

Your job is to make that box movable, but it should snap into place at the middle-bottom or middle-top of the image and give a cushy feel when it does.

The project's structure is simple. The photos are displayed with a `UICollectionViewController` using a custom `UICollectionViewCell`. When the user taps a cell, standard UIView animations make the corresponding full photo view fall in from the top of the view.

### Sticky behavior

You're going to create a new composite behavior to encapsulate the springy-cushiony feel for the metadata box. 

Create a new class by clicking on **File\New\File...**, select **Swift File** and name it **StickyEdgesBehavior.swift**. Replace the contents of that file with the following:

```swift
import UIKit

class StickyEdgesBehavior: UIDynamicBehavior {
  private var edgeInset: CGFloat
  private let itemBehavior: UIDynamicItemBehavior
  private let collisionBehavior: UICollisionBehavior
  private let item: UIDynamicItem
  private let fieldBehaviors = [
    UIFieldBehavior.springField(),
    UIFieldBehavior.springField()
  ]
  
  init(item: UIDynamicItem, edgeInset: CGFloat) {
    self.item = item
    self.edgeInset = edgeInset
    
    collisionBehavior = UICollisionBehavior(items: [item])
    collisionBehavior.translatesReferenceBoundsIntoBoundary =
      true
    
    itemBehavior = UIDynamicItemBehavior(items: [item])
    itemBehavior.density = 0.01
    itemBehavior.resistance = 20
    itemBehavior.friction = 0.0
    itemBehavior.allowsRotation = false
    
    super.init()
    
    addChildBehavior(collisionBehavior)
    addChildBehavior(itemBehavior)

    for fieldBehavior in fieldBehaviors {
      fieldBehavior.addItem(item)
      addChildBehavior(fieldBehavior)
    }
  }
}
```

The composite behavior starts as a subclass of `UIDynamicBehavior`, which really has no behaviors on its own (make sure you've entered this and **not** `UIDynamicItemBehavior`). 

`init` takes the item you're adding the behavior to, as well as an edge inset to make it customizable in the future. Then you create a `UIDynamicItemBehavior` to make the item lighter and more resistant, and also a `UICollisionBehavior` so it can collide with the reference view. Lastly, you add two `UIFieldBehavior` instances, one for the top-middle and one for the bottom-middle.

Add this helper enum just above the class declaration:

```swift
enum StickyEdge: Int {
  case Top = 0
  case Bottom
}
```

This helps identify the edge in the array of spring fields. 

Add the following to the class:

```swift
func updateFieldsInBounds(bounds: CGRect) {
  
  //1
  guard bounds != CGRect.zero else { return }
  let h = bounds.height
  let w = bounds.width
  let itemHeight = item.bounds.height

  //2
  func updateRegionForField(field: UIFieldBehavior,
    _ point: CGPoint) {

    let size = CGSize(width: w - 2 * edgeInset,
      height: h - 2 * edgeInset - itemHeight)
    field.position = point
    field.region = UIRegion(size: size)
  }
  
  //3
  let top = CGPoint(x: w / 2, y: edgeInset + itemHeight / 2)
  let bottom = CGPoint(x: w / 2,
    y: h - edgeInset - itemHeight / 2)

  //4
  updateRegionForField(fieldBehaviors[StickyEdge.Top.rawValue],
    top)
  updateRegionForField(
    fieldBehaviors[StickyEdge.Bottom.rawValue], bottom)
  }
}
```

This function will be called upon initial display of the view or if the view is ever resized. Its job is to set up the size and position of each of the sticky spring fields. Here's a deeper breakdown:

1. Makes sure the bounds are non-zero or that layout has occurred, and extracts some important values into constants.
2. Defines an inner function to update a particular field, given a location. It centers the field on the location and sizes it so it's inset from the left and right edges and takes up enough vertical space to reach the middle of the screen.
3. Defines the points that will be the center of each field.
4. Updates the top and bottom fields based on the new values.

Next, add the following property to the class:

```swift
var isEnabled = true {
  didSet {
    if isEnabled {
      for fieldBehavior in fieldBehaviors {
        fieldBehavior.addItem(item)
      }
      collisionBehavior.addItem(item)
      itemBehavior.addItem(item)
    } else {
      for fieldBehavior in fieldBehaviors {
        fieldBehavior.removeItem(item)
      }
      collisionBehavior.removeItem(item)
      itemBehavior.removeItem(item)
    }
  }
}
```

This helper property turns off the behavior in the animator during certain lifecycle events that happen while moving the item. 

Finally, add this method:

```swift
func addLinearVelocity(velocity: CGPoint) {
  itemBehavior.addLinearVelocity(velocity, forItem: item)
}
```

Build your application to make sure it compiles correctly. Disappointingly the app won't look any different yet :[

The method you just added will help snap the metadata box into place with a velocity. Now you need some velocity. To get that, you'll need to add the pan gesture recognizer, which is next. 

$[=s=]

Open **FullPhotoViewController.swift** and add the following below the existing `@IBOutlet` properties:

```swift
private var animator: UIDynamicAnimator!
var stickyBehavior: StickyEdgesBehavior!

private var offset = CGPoint.zero
```

Inside of `viewDidLoad()` add the following:

```swift
let gestureRecognizer = UIPanGestureRecognizer(target: self,
  action: #selector(FullPhotoViewController.pan(_:)))
tagView.addGestureRecognizer(gestureRecognizer)

animator = UIDynamicAnimator(referenceView: containerView)
stickyBehavior = StickyEdgesBehavior(item: tagView,
  edgeInset: 8)
animator.addBehavior(stickyBehavior)
```

This adds the pan gesture recognizer, the dynamic animator to the container view _and_ your new sticky behavior to the animator. It also sets the debug flag so you can see what's happening. 

Now add the following method to the view controller:

```swift
override func viewDidLayoutSubviews() {
  super.viewDidLayoutSubviews()

  stickyBehavior.isEnabled = false
  stickyBehavior.updateFieldsInBounds(containerView.bounds)
}
```

Whenever the main view's layout changes, the sticky behavior adjusts its bounds. 

Finally, add the following method to the view controller:

```swift
func pan(pan:UIPanGestureRecognizer) {
  var location = pan.locationInView(containerView)
  
  switch pan.state {
  case .Began:
    let center = tagView.center
    offset.x = location.x - center.x
    offset.y = location.y - center.y
    
    stickyBehavior.isEnabled = false
    
  case .Changed:
    let referenceBounds = containerView.bounds
    let referenceWidth = referenceBounds.width
    let referenceHeight = referenceBounds.height

    let itemBounds = tagView.bounds
    let itemHalfWidth = itemBounds.width / 2.0
    let itemHalfHeight = itemBounds.height / 2.0

    location.x -= offset.x
    location.y -= offset.y

    location.x = max(itemHalfWidth, location.x)
    location.x = min(referenceWidth - itemHalfWidth, location.x)
    location.y = max(itemHalfHeight, location.y)
    location.y = min(referenceHeight - itemHalfHeight,
      location.y)

    tagView.center = location
          
  default: ()
  }
}
```

When the pan gesture begins, the sticky behavior is shut off so the animations won't interfere with the movement. It records the offset of where the user tapped and uses it during the gesture when the location changes. The metadata view's location is updated in the `.Changed` case. The calculations done on the location _x_ and _y_ limit the movement of metadata view to inside of the container view.

Build and run the application. The metadata box is now draggable, thanks to the pan gesture recognizer, but it just stays where you put it. Seems the sticky behavior is not enabled. 

Go back into the `pan` method and add the following case, before the `default:` case:

```swift
case .Cancelled, .Ended:
  let velocity = pan.velocityInView(containerView)
  stickyBehavior.isEnabled = true
  stickyBehavior.addLinearVelocity(velocity)
``` 

Build and run. Now the velocity of your finger as it lifts from the screen will transfer into the sticky behavior, so the view will continue for a moment before being dragged back to the closest field. 

For a better understanding of how the behaviors work, turn on debug mode by adding the following to `viewDidLoad()`:

$[=p=]

```swift
animator.setValue(true, forKey: "debugEnabled")
```

![bordered iPhone](images/dynamicphotodisplay_debug.png)

Notice how the lines shorten and nearly disappear in the two zones where the metadata box can live. Seeing is believing!

### Full photo with a thud

For your next trick, you're going to update the way the full photo view animates while appearing. Right now, the app uses a UIView animation to animate the bounds change when re-centering the image, you're going to update it to make it feel more dynamic.

You'll effectively do the same action with UIKit Dynamics — animate the change of the center of the view, but this time you'll use gravity and a collision. 

Open **PhotosCollectionViewController.swift**, and add the following to the top of the class:

```swift
var animator: UIDynamicAnimator!
```

Add this line inside of `viewDidLoad()`:

```swift
animator = UIDynamicAnimator(referenceView: self.view)
```

Now that you've created the animator, swap out the contents of `showFullImageView` with the following:

$[=p=]

```swift
func showFullImageView(index: Int) {
  //1
  let delayTime = dispatch_time(DISPATCH_TIME_NOW,
    Int64(0.75 * Double(NSEC_PER_SEC)))
  dispatch_after(delayTime, dispatch_get_main_queue()) {
    let doneButton = UIBarButtonItem(barButtonSystemItem: .Done,
      target: self, action: #selector(PhotosCollectionViewController.dismissFullPhoto(_:)))
    self.navigationItem.rightBarButtonItem = doneButton
  }
  
  //2
  fullPhotoViewController.photoPair = photoData[index]
  fullPhotoView.center = CGPoint(x: fullPhotoView.center.x,
    y: fullPhotoView.frame.height / -2)
  fullPhotoView.hidden = false
  
  //3
  animator.removeAllBehaviors()
  
  let dynamicItemBehavior = UIDynamicItemBehavior(items:
    [fullPhotoView])
  dynamicItemBehavior.elasticity = 0.2
  dynamicItemBehavior.density = 400
  animator.addBehavior(dynamicItemBehavior)
  
  let gravityBehavior = UIGravityBehavior(items:
    [fullPhotoView])
  gravityBehavior.magnitude = 5.0
  animator.addBehavior(gravityBehavior)
  
  let collisionBehavior = UICollisionBehavior(items:
    [fullPhotoView])
  let left = CGPoint(x: 0, y: fullPhotoView.frame.height + 1.5)
  let right = CGPoint(x: fullPhotoView.frame.width,
    y: fullPhotoView.frame.height + 1.5)
  collisionBehavior.addBoundaryWithIdentifier("bottom",
    fromPoint: left, toPoint: right)
  animator.addBehavior(collisionBehavior)
}
```

Here's a breakdown of that block:

1. Adds the Done button to the nav bar after a short delay. This lets the dynamic animator do most of its animations first before updating the nav bar. 
2. Sets the image and repositions the full photo view above the thumbnails view, just off-screen.
3. Removes any existing behaviors from the animator, and then adds the gravity, item and collision behaviors.

Build and run the app. Tap a photo and notice the bounce when the view hits the bottom of the screen. The collision behavior demonstrated here is a bit different from previous examples; instead of using the reference view's boundary, this creates a single line of collision at the bottom. It's positioned just off the screen so the bounce doesn't leave a visible gap. 

There are a lot of knobs and levers to change when dealing with behaviors. Play around with the `UIDynamicItemBehavior` and `UIGravityBehavior` properties to see if you can find a bounce behavior you like!

![width=40%](images/too_much_bounce.png)

## Where to go from here

You've now played with most of the behaviors available to you in UIKit Dynamics, but there's more properties and options to be explored. 

At the time of writing this chapter, Apple hasn't created a guide for UIKit Dynamics, so you'll want to spend some quality time with the documentation on each of the classes to learn more about the finer controls available to you.

Also, check out these videos from the past WWDCs:

* 2013 - #206 - Getting Started with UIKit Dynamics - [apple.co/1J1IoNB](https://developer.apple.com/videos/wwdc/2013/#206)
* 2013 - #217 - Exploring Scroll Views in iOS 7 - [apple.co/1gQGtPM](https://developer.apple.com/videos/wwdc/2013/#217)
* 2013 - #221 - Advanced Techniques with UIKit Dynamics - [apple.co/1T1N2Qf](https://developer.apple.com/videos/wwdc/2013/#221)
* 2014 - #216 - Building Adaptive Apps with UIKit - [apple.co/1hoAQbr](https://developer.apple.com/videos/wwdc/2014/#216)
* 2015 - #229 - What's New in UIKit Dynamics and Visual Effects - [apple.co/1IO1nF3](https://developer.apple.com/videos/wwdc/2015/?id=229)

## Challenges

Now it's time for you to take a whack at adding some dynamic goodness to the app. You'll find the solutions in the final version of this app — but give yourself a chance before you go reverse engineering! 

### Challenge #1

Instead of using UIView animations to dismiss the view after tapping the done button, use UIKit Dynamics. You'll want the view to be pushed off-screen upwards at a slow enough rate for the user to experience it. Replace the contents of `dismissFullPhoto` with the behaviors.

**Hints:**

* A `UIPushBehavior` behavior will give the view the kick it needs.
* A `UIDynamicItemBehavior` can adjust the photo view's properties so it moves the way you want.
* A `UIAttachmentBehavior` sliding behavior can stop the view once it gets off screen.
* You can use the `UIDynamicAnimator` delegate method `dynamicAnimatorDidPause` to hide the view after it has animated off-screen.

### Challenge #2

Add an interaction to the app that allows you to swipe up on the full photo view to dismiss it — it's very similar to the lock screen photo behavior in iOS. You should be able to lift the full photo view up, but it should drop back down if you didn't lift it high enough. A good swipe upwards should fling it off the screen.

**Hints:**

* You'll need to create a new composite behavior like you did with the `StickyEdgesBehavior` earlier. This should have a dynamic item behavior to give density and elasticity, a collision behavior to stop it from falling off the bottom of the screen, and a gravity behavior to make it drop. You should also allow it to take a linear velocity like the sticky edges behavior did.
* The swipe and drag up behavior will exist in `PhotosCollectionViewController` along with a `UIPanGestureRecognizer`. The setup will look similar to the pan gesture recognizer used to move the metadata view around.
* If the view is moved up less than half way, it should bounce back down. Take the velocity into account as well to determine if there is enough movement to dismiss the view. Try playing around with the camera on the lock screen for an example.
* If you do dismiss the view, you may as well reuse the code you wrote earlier for pushing the view off the screen. Refactor that into a separate method so you can use it in both cases. 
