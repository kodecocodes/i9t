# Chapter X: UIKit Dynamics

## Opening

iOS applications live in the hands of the people using them. We've come to expect our mobile apps to react to us touching them and to provide some semblance of realness. iOS 7 introduced the idea of flatness in our user interfaces rather than the heavily skeuomorphic concepts previously. Instead of heavy interfaces we can provide that bond with our apps with animations and reactions to touch that mirror real-world physics.

__UIKit Dynamics__ was designed to give you a simplistic set of ways to provide the physical experiences in your animations and view interactions. UIKit Dynamics is a 2D physics-inspired animation system designed with a convenient API. Originaly introduced in iOS 7, UIKit Dynamics was left relatively unchanged in iOS 8. Now in iOS 9 we get a bunch of new exciting things like gravity and magnetic fields, non-rectangular collision bounds, and additional attachment behaviors.

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

Excellent! Wait. Where's the exciting output? Switch to the Assistant Editor by hitting __Option + Command + Enter__. You should see something like this now:

![bordered width=90%](images/playground_step1_assistant_editor.png)

> **Note**: XCPShowView(_:) is responsible for the magic of rendering your view in the Assistant Editor. Some times Xcode 7 doesn't re-run your Playground after making a change. You can force Xcode to re-run by selecting the menu item __Editor\Execute Playground__.

Add the following line after creating the second subview:

```swift
let animator = UIDynamicAnimator(referenceView: view)
```

`UIDynamicAnimator` is where all the physics voodoo happens. The `referenceView` we passed in is the canvas where all the animation takes place. All of the views we animate must be a subview of the reference view.

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

> **CHALLENGE**: Play around with other field behaviors and come up with a couple other effects.s

## Applying Dynamics to a Real App

Playing around with UIKit Dynamics in a Playground is fun - but you're probably interested in incorporating it in a real application. Dynamics aren't just all for physics simulations and games!

UIKit Dynamics is really designed for solving non-game applications. In reality your application may only need dynamics in a few key places to give it the extra "pop" you are looking for. A little does go a long way!

### Introducing DynamicPhotoDisplay

For this part of the chapter, you'll be working with simple photo viewing application. The user is displayed with a scrolling list of photo thumbails and tapping on them displays a full screen version. You can find the starter project as well as the final solution in the resources folder for this chapter.  Open it in Xcode and build and run it. You should see the following:

![width=80%](images/dynamicphotodisplay_initialwithfull.png)

You'll notice the full screen view of a photo shows a bit of metadata. The user might encounter a photo where that metadata box obscures a part of the photo. Your job is to make that box movable but only allow it to rest in the middle bottom or middle top of the image. The box should snap into place in the closest resting spot and give a cushy feel when it does.

The project structure is failure simple. The photos are displayed with a `UICollectionViewController` using a custom `UICollectionViewCell` 

### Determine what could make an app more friendly
### Pulsate a button when tapped on / off (favorite star?)
### UICollectionView dynamics - adding dynamic behavior to give physical feel to items when dragging things to change sort order
### Debugging tricks
## Conclusion
## Challenge