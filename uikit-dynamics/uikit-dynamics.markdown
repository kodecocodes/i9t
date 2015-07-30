# Chapter X: UIKit Dynamics

## Opening

iOS applications live in the hands of the people using them. We've come to expect our mobile apps to react to us touching them and to provide some semblance of realness. iOS 7 introduced the idea of flatness in our user interfaces rather than the heavily skeuomorphic concepts previously. Instead of heavy interfaces we can provide that bond with our apps with animations and reactions to touch that mirror real-world physics.

UIKit Dynamics was designed to give you a simplistic set of ways to provide the physical experiences in your animations and view interactions. UIKit Dynamics is a full physics engine wrapped with a convenient API. Originaly introduced in iOS 7, UIKit Dynamics was left relatively unchanged in iOS 8. Now in iOS 9 we get a bunch of new exciting things like gravity and magnetic fields, non-rectangular collision bounds, and additional attachment behaviors.

> **Note**: This chapter will primarily focus on the new things introduced for UIKit Dynamics for iOS 9. Check out *iOS 7 by Tutorials* for a full introduction to the original APIs.

## Getting started
UIKit Dynamics is definitely a framework you have to learn by doing. You'll be using an Xcode Playground to follow along and watch the changes live!



### Playground
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