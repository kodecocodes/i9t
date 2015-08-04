//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

let view = UIView(frame: CGRectMake(0, 0, 600, 600))
view.backgroundColor = UIColor.lightTextColor()
XCPShowView("Main View", view: view)

let whiteSquare = UIView(frame: CGRectMake(100, 100, 100, 100))
whiteSquare.backgroundColor = UIColor.whiteColor()
view.addSubview(whiteSquare)

let orangeSquare = UIView(frame: CGRectMake(400, 100, 100, 100))
orangeSquare.backgroundColor = UIColor.orangeColor()
view.addSubview(orangeSquare)

let animator = UIDynamicAnimator(referenceView: view)
animator.setValue(true, forKey: "debugEnabled")

animator.addBehavior(UIGravityBehavior(items: [orangeSquare]))

let boundaryCollision = UICollisionBehavior(items: [whiteSquare, orangeSquare])
boundaryCollision.translatesReferenceBoundsIntoBoundary = true
animator.addBehavior(boundaryCollision)

let bounce = UIDynamicItemBehavior(items: [orangeSquare])
bounce.elasticity = 0.6
bounce.density = 200
bounce.resistance = 2
animator.addBehavior(bounce)

let parentBehavior = UIDynamicBehavior()

let viewBehavior = UIDynamicItemBehavior(items: [whiteSquare])
viewBehavior.density = 0.01
viewBehavior.resistance = 10
viewBehavior.friction = 0.0
viewBehavior.allowsRotation = false
parentBehavior.addChildBehavior(viewBehavior)

// Add a spring region for the swinging thing to get caught in
let fieldBehavior = UIFieldBehavior.springField()
fieldBehavior.addItem(whiteSquare)
fieldBehavior.position = CGPointMake(150, 350)
fieldBehavior.region = UIRegion(size: CGSizeMake(500, 500))
parentBehavior.addChildBehavior(fieldBehavior)

animator.addBehavior(parentBehavior)

//: After two seconds, push the white block almost out of the spring field
let delayTime = dispatch_time(DISPATCH_TIME_NOW,
    Int64(2 * Double(NSEC_PER_SEC)))

dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
    let pushBehavior = UIPushBehavior(items: [whiteSquare], mode: .Instantaneous)
    pushBehavior.pushDirection = CGVectorMake(0, -1)
    pushBehavior.magnitude = 0.3
    animator.addBehavior(pushBehavior)
}

//: Comment out the section above from `parentBehavior`'s creation to here. This demonstrates UIAttachmentBehavior attached to an anchor.
//let anchorThing = UIView(frame: CGRectMake(295, 100, 10, 10))
//anchorThing.backgroundColor = UIColor.blackColor()
//view.addSubview(anchorThing)

//let stringAttachment = UIAttachmentBehavior(item: whiteSquare, attachedToAnchor: anchorThing.center)
//stringAttachment.length = 250
//animator.addBehavior(stringAttachment)
