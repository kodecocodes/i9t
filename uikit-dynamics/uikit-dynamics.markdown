# Chapter X: UIKit Dynamics

## Opening

iOS applications live in the hands of the people using them. We've come to expect our mobile apps to react to us touching them and to provide some semblance of realness. iOS 7 introduced the idea of flatness in our user interfaces rather than the heavily skeuomorphic concepts previously. Instead of heavy interfaces we can provide that bond with our apps with animations and reactions to touch that mirror real-world physics.

__UIKit Dynamics__ was designed to give you a simplistic set of ways to provide the physical experiences in your animations and view interactions. UIKit Dynamics is a full physics engine wrapped with a convenient API. Originaly introduced in iOS 7, UIKit Dynamics was left relatively unchanged in iOS 8. Now in iOS 9 we get a bunch of new exciting things like gravity and magnetic fields, non-rectangular collision bounds, and additional attachment behaviors.

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

This adds a basic gravity behavior to the orange block. See it fall off the screen in the Assistant Editor? That took two lines of code - you should be feeling amazed and empowered right now. Lets make the box stop at the bottom of the screen.

```swift
let boundaryCollision = UICollisionBehavior(items: [subView, subView2])
boundaryCollision.translatesReferenceBoundsIntoBoundary = true
animator.addBehavior(boundaryCollision)
```




### Introduce basic pieces of dynamics
#### Dynamic Items - UIDynamicItem protocol, UIDynamicItemGroup
#### Behaviors - UIDynamicBehavior
##### UIAttachmentBehavior - discuss new attachment types in iOS 9
##### UICollisionBehavior - discuss non-rectangular collision bounds new in iOS 9
##### UIDynamicItemBehavior
##### UIFieldBehavior - spend more time on this as it's new in iOS 9
##### UIGravityBehavior
##### UIPushBehavior
##### UISnapBehavior
##### Composite
#### Animators - UIDynamicAnimator
##### init with Reference View
##### init with Collection View
##### init
### Add each piece as you go along to demonstrate
## Real World Application - Add dynamics to a non-game app
### Determine what could make an app more friendly
### Pulsate a button when tapped on / off (favorite star?)
### UICollectionView dynamics - adding dynamic behavior to give physical feel to items when dragging things to change sort order
### Debugging tricks
## Conclusion
## Challenge