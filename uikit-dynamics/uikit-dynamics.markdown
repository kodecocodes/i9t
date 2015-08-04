# Chapter X: UIKit Dynamics

## Opening

iOS applications live in the hands of the people using them. We've come to expect our mobile apps to react to us touching them and to provide some semblance of realness. iOS 7 introduced the idea of flatness in our user interfaces rather than the heavily skeuomorphic concepts previously. Instead of heavy interfaces we can provide that bond with our apps with animations and reactions to touch that mirror real-world physics.

__UIKit Dynamics__ was designed to give you a simplistic set of ways to provide the physical experiences in your animations and view interactions. UIKit Dynamics is a 2D physics-inspired animation system designed with a convenient API. Originally introduced in iOS 7, UIKit Dynamics was left relatively unchanged in iOS 8. Now in iOS 9 we get a bunch of new exciting things like gravity and magnetic fields, non-rectangular collision bounds, and additional attachment behaviors.

> **Note**: This chapter will primarily focus on the new things introduced for UIKit Dynamics for iOS 9. Check out *iOS 7 by Tutorials* for a full introduction to the original APIs.

## Getting started
UIKit Dynamics is definitely a framework you have to learn by doing. You'll be using an Xcode Playground to follow along and watch the changes live!

### Create the Playground

Open Xcode, select __File\New\Playground...__. Enter __UIKit Dynamics__ for the name and set __Platform__ to __iOS__. Click __Next__. Choose a location for the Playground and click __Create__. Once the Playground opens, replace the contents with: 

```swift
import UIKit
import XCPlayground

let view = UIView(frame: CGRectMake(0, 0, 600, 600))
view.backgroundColor = UIColor.lightTextColor()
XCPShowView("Main View", view: view)

let subView = UIView(frame: CGRectMake(100, 100, 100, 100))
subView.backgroundColor = UIColor.whiteColor()
view.addSubview(subView)

let subView2 = UIView(frame: CGRectMake(400, 100, 100, 100))
subView2.backgroundColor = UIColor.orangeColor()
view.addSubview(subView2)
```

Excellent! Wait. You created a view and added two subviews giving each a different color - but you don't see anything! Where's the exciting output? Switch to the Assistant Editor by hitting __Option + Command + Enter__. You should see something like this now:

![bordered width=90%](images/playground_step1_assistant_editor.png)

> **Note**: XCPShowView(_:) is responsible for the magic of rendering your view in the Assistant Editor. Some times Xcode 7 doesn't re-run your Playground after making a change. You can force Xcode to re-run by selecting the menu item __Editor\Execute Playground__.

Add the following line after creating the second subview:

```swift
let animator = UIDynamicAnimator(referenceView: view)
```

`UIDynamicAnimator` is where all the physics voodoo happens. A dynamic animator is an intermediary between your dynamic items (UIView subviews in this case), the dynamic behaviors you create and the iOS physics engine. It provides a context for the animations to be calculated before being rendered. Dynamic Behaviors encapsulate the physics for a particular desired effect like gravity, attraction, bounce, etc. Dynamic animators keep track of where all of your items are during the animation process. The `referenceView` we passed in is the canvas where all the animation takes place. All of the views we animate must be a subview of the reference view.

### Your First Behavior

`UIDynamicBehavior` is the base class that describes an effect to one or more dynamic items (your subviews) and how they take part in the 2D animation you are trying to achieve. There are a bunch of behaviors that Apple provides but the easiest one to start with is UIGravityBehavior. Developers are like cats - they like to see things fall.

```swift
animator.addBehavior(UIGravityBehavior(items: [subView2]))
```

This adds a basic gravity behavior to the orange block. See it fall off the screen in the Assistant Editor? That took two lines of code. You should be feeling amazed and empowered right now. Lets make the box stop at the bottom of the screen.

```swift
let boundaryCollision = UICollisionBehavior(items: [subView, subView2])
boundaryCollision.translatesReferenceBoundsIntoBoundary = true
animator.addBehavior(boundaryCollision)
```

Adding a collision behavior and setting `translatesReferenceBoundsIntoBoundary` to `true` makes the border of the reference view turn into a boundary. Now when the orange block falls it stops, and bounces, at the bottom of the view.

Now change the way the orange box responds to the collision:

```swift
let bounce = UIDynamicItemBehavior(items: [subView2])
bounce.elasticity = 0.6
bounce.density = 200
bounce.resistance = 2
animator.addBehavior(bounce)
```

A dynamic item’s density, along with its size, determines its "mass" when it participates in behaviors. Elasticity changes how much an item bounces in a collision - default is 0.0. Resistance, when set, will reduce linear velocity until the item stops. Play around with these values and observe how the animation changes.

Somewhere in your Playground code put this line after creating the UIDynamicAnimator:

```swift
animator.setValue(true, forKey: "debugEnabled")
```

This is new undocumented feature in iOS 9 to turn on a visual debugging mode. It was mentioned in the 2015 WWDC session *What's New in UIKit Dynamics and Visual Effects*. It was said this had to be done in the console using LLDB but you can also turn it on using the key-value coding method shown. Debug mode shows cool things like attachments, when collisions happen and visualizations of field effects. Keep this debug turned on for the rest of this tutorial.

### Behaviors

There are a number of types of behaviors available to you: 

* `UIAttachmentBehavior` - This specifies a connection between two dynamic items or a single item and an anchor point. New in iOS 9 are variants for a sliding attachment, limit attachment (like a piece of rope), fixed attachment to fuse two items together, and a pin attachment which acts like hanging two limited items over a pin.
* `UICollisionBehavior` - As you've seen it already this behavior declares an item has a physical interaction with other items. It can also make the reference view turn its border into a collision border with `translatesReferenceBoundsIntoBoundary`.
* `UIDynamicItemBehavior` - This is a collection of physical properties for a dynamic item that aren't segmented out into a specific behavior. You've seen friction, density and resistance already. In iOS 9 you can anchor an item to a spot and also change the charge for an item when its participating in a magnetic or electric field behavior.
* `UIFieldBehavior` - Totally new in iOS 9, this adds a number of physical field behaviors like electric, magnetic, dragging, vortex, radial and linear gravity, velocity, noise, turbulence and spring fields.
* `UIGravityBehavior` - Adds a bit of gravity to your views so they react by falling in a particular direction with a set acceleration.
* `UIPushBehavior` - Give your dynamic items a push to move them around.
* `UISnapBehavior` - Moves a dynamic item to a specific point with a springy bounce-like effect.
* Composite Behaviors - You can combine behaviors together for easy packaging and reuse later.

### MOAR PLAYGROUND

Lets use some of the new stuff in iOS 9. Put this code in your playground:

```swift
let parentBehavior = UIDynamicBehavior()

let viewBehavior = UIDynamicItemBehavior(items: [subView])
viewBehavior.density = 0.01
viewBehavior.resistance = 10
viewBehavior.friction = 0.0
viewBehavior.allowsRotation = false
parentBehavior.addChildBehavior(viewBehavior)

// Add a spring region for the swinging thing to get caught in
let fieldBehavior = UIFieldBehavior.springField()
fieldBehavior.addItem(subView)
fieldBehavior.position = CGPointMake(150, 350)
fieldBehavior.region = UIRegion(size: CGSizeMake(500, 500))
parentBehavior.addChildBehavior(fieldBehavior)

animator.addBehavior(parentBehavior)
```

This is an example of a composite behavior. A generic `UIDynamicBehavior` instance is created and two behaviors were added as children. The hierarchy for how behaviors are related is purely for organizational assistance. When the dynamic animator is determining what work an animator has to do all behaviors are "flattened" out.

Did you see the bouncy snag of the white square? Re-execute the Playground if you didn't. `UIFieldBehavior` is one of the new behaviors in iOS 9 and is arguably the coolest one. Spring fields are great for positioning an element by letting it get drawn into the region's center and letting it bounce into place. Give the white square a little time-delayed push to really understand the effect:

```swift
let delayTime = dispatch_time(DISPATCH_TIME_NOW,
    Int64(2 * Double(NSEC_PER_SEC)))

dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
    let pushBehavior = UIPushBehavior(items: [subView], mode: .Instantaneous)
    pushBehavior.pushDirection = CGVectorMake(0, -10.5)
    animator.addBehavior(pushBehavior)
}
```

Now you can really see the power of the spring field!

> **CHALLENGE**: Try attaching the second box to a point with a `UIAttachmentBehavior` behavior. Use the `init(_:attachedToAnchor:)` method to anchor it to the point. You might like to play around with the Playground and see what other effects you can come up with.

## Applying Dynamics to a Real App

Playing around with UIKit Dynamics in a Playground is fun - but you're probably interested in incorporating it in a real application. Dynamics aren't just all for physics simulations and games!

UIKit Dynamics is really designed for solving non-game applications. In reality your application may only need dynamics in a few key places to give it the extra "pop" you are looking for. A little does go a long way!

### Introducing DynamicPhotoDisplay

For this part of the chapter, you'll be working with simple photo viewing application. The user is displayed with a scrolling list of photo thumbails and tapping on them displays a full screen version. You can find the starter project as well as the final solution in the resources folder for this chapter.  Open it in Xcode and build and run it. You should see the following:

![width=80%](images/dynamicphotodisplay_initialwithfull.png)

You'll notice the full screen view of a photo shows a bit of metadata. The user might encounter a photo where that metadata box obscures a part of the photo. Your job is to make that box movable but only allow it to rest in the middle bottom or middle top of the image. The box should snap into place in the closest resting spot and give a cushy feel when it does.

The project structure is failure simple. The photos are displayed with a `UICollectionViewController` using a custom `UICollectionViewCell`. When the cell is tapped the full photo view is displayed using standard UIView animations to have it fall from the top of the view.

### Sticky Behavior

You're going to create a new composite behavior to encapsulate the springy cushy feel for the metadata box. Create a new class by clicking on **File\New\File...**, select **Swift File** and name it **StickyEdgesBehavior.swift**. Replace the contents of that file with the following:

```swift
import UIKit

class StickyEdgesBehavior: UIDynamicBehavior {
  private var edgeInset: CGFloat
  private let itemBehavior: UIDynamicItemBehavior
  private let collisionBehavior: UICollisionBehavior
  private let item: UIDynamicItem
  private var fieldBehaviors = [UIFieldBehavior]()
  
  init(item: UIDynamicItem, edgeInset: CGFloat) {
    self.item = item
    self.edgeInset = edgeInset
    
    collisionBehavior = UICollisionBehavior(items: [item])
    collisionBehavior.translatesReferenceBoundsIntoBoundary = true
    
    itemBehavior = UIDynamicItemBehavior(items: [item])
    itemBehavior.density = 0.01
    itemBehavior.resistance = 20
    itemBehavior.friction = 0.0
    itemBehavior.allowsRotation = false
    
    super.init()
    
    addChildBehavior(collisionBehavior)
    addChildBehavior(itemBehavior)

    for _ in 0...1 {
      let fieldBehavior = UIFieldBehavior.springField()
      fieldBehavior.addItem(item)
      fieldBehaviors.append(fieldBehavior)
      addChildBehavior(fieldBehavior)
    }
  }
}
```

Our composite behavior starts as a subclass of `UIDynamicBehavior` which really has no behaviors on its own. The `init` method takes the item we're adding the behavior to and an edge inset to make it customizable in the future. Then a `UIDynamicItemBehavior` is created to make the item lighter and more resistant and a `UICollisionBehavior` so that it can collide with the reference view. Two `UIFieldBehavior` instances are added as well - one for the top middle and one for the bottom middle.

Add this helper enum to the file just above the class declaration:

```swift
enum StickyEdge: Int {
  case Top = 0
  case Bottom
}
```

This is used to help identify the edge in the array of spring fields. Next add the following to the class:

```swift
  func updateFieldsInBounds(bounds: CGRect) {
    if bounds != CGRect.zeroRect {
      let h = bounds.height
      let w = bounds.width
      let itemHeight = item.bounds.height

      func updateRegionForField(field: UIFieldBehavior, _ point: CGPoint) {
        let size = CGSize(width: w - 2 * edgeInset, height: h - edgeInset - itemHeight)
        field.position = point
        field.region = UIRegion(size: size)
      }
      
      let top = CGPoint(x: w / 2, y: edgeInset + itemHeight / 2)
      let bottom = CGPoint(x: w / 2, y: h - edgeInset - itemHeight / 2)

      updateRegionForField(fieldBehaviors[StickyEdge.Top.rawValue], top)
      updateRegionForField(fieldBehaviors[StickyEdge.Bottom.rawValue], bottom)
    }
  }
```

This function will be called when the view is initially displayed to set up the regions of the spring fields. The calculations will end up splitting the view in half which is the area the spring field will cover. The center of the field is just page the edge so the center of the metadata view sticks out from the edge a bit. The function will be called if the reference view is ever resized. Next, add the following property to the class:

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

This helper property turns off the behavior in the animator during certain lifecycle events while moving the item. Finally add this method:

```swift
  func addLinearVelocity(velocity: CGPoint) {
    itemBehavior.addLinearVelocity(velocity, forItem: item)
  }
```

Build your application to make sure everything is compiling up until this point. This method will help snap the item (the metadata box) into place with a velocity. You'll get that velocity from the pan gesture recognizer you'll add next. 

Go back into **FullPhotoViewController.swift** and add the following below the existing `@IBOutlet` properties:

```swift
  private var animator: UIDynamicAnimator!
  var stickyBehavior: StickyEdgesBehavior!

  private var offset = CGPoint.zeroPoint
```

Inside of `viewDidLoad()` add the following:

```swift
    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: "pan:")
    tagView.addGestureRecognizer(gestureRecognizer)
    
    animator = UIDynamicAnimator(referenceView: containerView)
    animator.setValue(true, forKey: "debugEnabled")
    stickyBehavior = StickyEdgesBehavior(item: tagView, edgeInset: 8)
    animator.addBehavior(stickyBehavior)
```

This adds the pan gesture recognizer, the dynamic animator to the container view and your new sticky behavior to the animator. Add the following method to the view controller:

```swift
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    stickyBehavior.isEnabled = false
    
    let bounds = CGRect(origin: CGPoint.zeroPoint, size: containerView.frame.size)
    
    stickyBehavior.updateFieldsInBounds(bounds)
  }
```

Whenever the main view's layout is changed the sticky behavior will adjust its bounds. Finally add the following method to the view controller:

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
      location.y = min(referenceHeight - itemHalfHeight, location.y)

      tagView.center = location
            
    default: ()
    }
  }
```

When the pan gesture begins, the sticky behavior is shut off so the animations don't interfere with the movement. The offset of where the user tapped is recorded and used during the gesture when the location is changed. The metadata view's location is updated in the `.Changed` case. The calculations done on the location x & y limit the movement of the metadata view to inside the container view.

Build and run the application. The metadata box is now draggable thanks to the pan gesture recognizer. Drop the box anywhere on the screen and notice it zips back to one of the two locations. The gesture doesn't quite have the response you're looking for. Go back into the `pan` method and add the following case:

```swift
    case .Cancelled, .Ended:
      let velocity = pan.velocityInView(containerView)
      stickyBehavior.isEnabled = true
      stickyBehavior.addLinearVelocity(velocity)
``` 

Build and run. Now when you flick the view the velocity at the time of your finger leaving the screen will be transferred into the stick behavior. For a better understanding of how the behaviors work, turn on debug mode by adding the following to `viewDidLoad()`:

```swift
    animator.setValue(true, forKey: "debugEnabled")
```

![bordered width=40%](images/dynamicphotodisplay_debug.png)

Notice how the lines shorten and nearly disappear in the two zones where the metadata box can live. Seeing is believing!

### Full Photo With a Thud

For your next trick, you're going to update the way the full photo view is displayed to make it feel more dynamic. Right now the app is using a UIView animation to animate the bounds change when re-centering the image. You'll effectively do the same action with UIKit Dynamics - animate the change of the center of the view but by using gravity and a collision. Open **PhotosCollectionViewController.swift** and add the following to the top of the class:

```swift
  var animator: UIDynamicAnimator!
```

Then inside of `viewDidLoad()` add this line:

```swift
    animator = UIDynamicAnimator(referenceView: self.view)
```

Now that the animator has been created, swap out the contents of `showFullImageView` with the following:

```swift
  func showFullImageView(index: Int) {
    // 1
    let delayTime = dispatch_time(DISPATCH_TIME_NOW,
      Int64(0.75 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
      let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "dismissFullPhoto:")
      self.navigationItem.rightBarButtonItem = doneButton
    }
    
    // 2
    fullPhotoViewController.photoPair = photoData[index]
    fullPhotoView.center = CGPointMake(fullPhotoView.center.x, fullPhotoView.frame.size.height / -2)
    fullPhotoView.hidden = false
    
    // 3
    animator.removeAllBehaviors()
    
    let dynamicItemBehavior = UIDynamicItemBehavior(items: [fullPhotoView])
    dynamicItemBehavior.elasticity = 0.2
    dynamicItemBehavior.density = 400
    animator.addBehavior(dynamicItemBehavior)
    
    let gravityBehavior = UIGravityBehavior(items: [fullPhotoView])
    gravityBehavior.magnitude = 5.0
    animator.addBehavior(gravityBehavior)
    
    let collisionBehavior = UICollisionBehavior(items: [fullPhotoView])
    collisionBehavior.addBoundaryWithIdentifier("bottom", fromPoint: CGPointMake(0, fullPhotoView.frame.size.height + 1.5), toPoint: CGPointMake(fullPhotoView.frame.size.width, fullPhotoView.frame.size.height + 1.5))
    animator.addBehavior(collisionBehavior)
  }
```

In section 1 the Done button is added to the nav bar but after a short delay. This lets the dynamic animator do most of its animations first before updating the nav bar. In section 2 the image is set and the full photo view repositioned above the thumbnails view, just off screen. Section 3 removes any existing behaviors from the animator and then adds the gravity, item and collision behaviors.

Build and run the app. Tap a photo and notice that when the view hits the bottom of the screen it bounces. The collision behavior shown here is a bit different from previous examples. Instead of using the reference view's boundary this creates a single line of collision at the bottom. Its positioned just off the screen so the bounce doesn't leave a visible gap. 

There are a lot of knobs and levers to change when dealing with behaviors. Play around with the `UIDynamicItemBehavior` and `UIGravityBehavior` properties to see if you can find a bounce behavior you like!

## Where to Go From Here

You've seen examples of most of the behaviors available to you in UIKit Dynamics but not every property and option was covered. Spend some quality time with the Apple documentation for each of the classes to learn more about the fine controls available to you. Also check out these videos from the past WWDCs:

* 2013 - #206 - Getting Started with UIKit Dynamics
* 2013 - #217 - Exploring Scroll Views in iOS 7
* 2013 - #221 - Advanced Techniques with UIKit Dynamics
* 2014 - #216 - Building Adaptive Apps with UIKit
* 2015 - #229 - What's New in UIKit Dynamics and Visual Effects

## Challenges

Now it's time for you to take a whack at adding some dynamic goodness to the app. The solution is provided for these challenges - but try giving it a chance yourself! 

### Challenge #1

Instead of using UIView animations to dismiss the view when Done is tapped, use UIKit Dynamics. You'll want the view to be pushed off the screen upwards at a slow enough rate for the user to experience it. Replace the contents of `dismissFullPhoto` with the behaviors.

* A `UIPushBehavior` behavior will give the view the kick it needs.
* You can use the `UIDynamicAnimator` delegate method `dynamicAnimatorDidPause` to hide the view after its animated off screen. There are no callbacks like UIView animations.

### Challenge #2

You're going to add an interaction to the app that allows you to swipe up on the full photo view to dismiss it. This is very similar to the lock screen photo behavior in iOS. You should be able to lift the full photo view up and it'll drop back down if you didn't lift it high enough. A good swipe upwards will fling it off the screen.

Here are some hints to get you started on your journey:

* The swipe and drag up behavior will exist in `PhotosCollectionViewController` along with a `UIPanGestureRecognizer`. The setup will look similar to the pan gesture recognizer used to move the metadata view around.
* If the view is moved up less than half way, it should bounce back down. Take the velocity into account as well to determine if there is enough movement to dismiss the view. Try playing around with the camera on the lock screen for an example.
* You'll need gravity, collisions, and push behaviors.