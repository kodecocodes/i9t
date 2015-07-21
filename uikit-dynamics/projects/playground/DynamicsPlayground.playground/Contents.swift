//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

let view = UIView(frame: CGRectMake(0, 0, 600, 600))
view.backgroundColor = UIColor.lightTextColor()

let subView = UIView(frame: CGRectMake(100, 100, 100, 100))
subView.backgroundColor = UIColor.whiteColor()
view.addSubview(subView)

let subView2 = UIView(frame: CGRectMake(400, 100, 100, 100))
subView2.backgroundColor = UIColor.orangeColor()
view.addSubview(subView2)

let animator = UIDynamicAnimator(referenceView: view)
animator.setValue(true, forKey: "debugEnabled")

animator.addBehavior(UIGravityBehavior(items: [subView2]))

let boundaryCollision = UICollisionBehavior(items: [subView, subView2])
boundaryCollision.translatesReferenceBoundsIntoBoundary = true
animator.addBehavior(boundaryCollision)

let bounce = UIDynamicItemBehavior(items: [subView2])
bounce.elasticity = 0.6
bounce.density = 200
////bounce.resistance = 2
animator.addBehavior(bounce)

//let anchorThing = UIView(frame: CGRectMake(295, 100, 10, 10))
//anchorThing.backgroundColor = UIColor.blackColor()
//view.addSubview(anchorThing)

//let stringAttachment = UIAttachmentBehavior(item: subView, attachedToAnchor: anchorThing.center)
//stringAttachment.length = 250
//animator.addBehavior(stringAttachment)

if #available(iOS 9, *) {
  let fieldVisualization = UIView(frame: CGRectMake(50, 250, 200, 200))
  fieldVisualization.backgroundColor = UIColor.lightGrayColor()
  view.insertSubview(fieldVisualization, atIndex: 0)
  
  let parentBehavior = UIDynamicBehavior()
  
  let collisionBehavor = UICollisionBehavior(items: [subView])
  collisionBehavor.translatesReferenceBoundsIntoBoundary = true
  parentBehavior.addChildBehavior(collisionBehavor)
  
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
  fieldBehavior.region = UIRegion(size: CGSizeMake(200, 200))
  fieldBehavior.strength = 10.0
  parentBehavior.addChildBehavior(fieldBehavior)
  
  animator.addBehavior(parentBehavior)
}

let delayTime = dispatch_time(DISPATCH_TIME_NOW,
  Int64(2 * Double(NSEC_PER_SEC)))

dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
  let pushBehavior = UIPushBehavior(items: [subView], mode: .Instantaneous)
  pushBehavior.pushDirection = CGVectorMake(0, -10.5)
  animator.addBehavior(pushBehavior)
}

// Can be anywhere in code
XCPShowView("Main View", view: view)

