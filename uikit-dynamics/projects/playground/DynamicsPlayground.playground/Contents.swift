//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

let mainView = UIView(frame: CGRectMake(0, 0, 600, 600))
mainView.backgroundColor = UIColor.lightTextColor()

let whiteSquare = UIView(frame: CGRectMake(100, 100, 100, 100))
whiteSquare.backgroundColor = UIColor.whiteColor()
mainView.addSubview(whiteSquare)

let orangeSquare = UIView(frame: CGRectMake(400, 100, 100, 100))
orangeSquare.backgroundColor = UIColor.orangeColor()
mainView.addSubview(orangeSquare)

let animator = UIDynamicAnimator(referenceView: mainView)
animator.setValue(true, forKey: "debugEnabled")

animator.addBehavior(UIGravityBehavior(items: [orangeSquare]))

let boundaryCollision = UICollisionBehavior(items: [whiteSquare, orangeSquare])
boundaryCollision.translatesReferenceBoundsIntoBoundary = true
animator.addBehavior(boundaryCollision)

let bounce = UIDynamicItemBehavior(items: [orangeSquare])
bounce.elasticity = 0.6
bounce.density = 200
animator.addBehavior(bounce)

//let anchorThing = UIView(frame: CGRectMake(295, 100, 10, 10))
//anchorThing.backgroundColor = UIColor.blackColor()
//view.addSubview(anchorThing)

//let stringAttachment = UIAttachmentBehavior(item: subView, attachedToAnchor: anchorThing.center)
//stringAttachment.length = 250
//animator.addBehavior(stringAttachment)

//: `UIFieldBehavior` is only available in iOS 9 and currently Playgrounds requires a guard for compilation. This may change in the future.
if #available(iOS 9, *) {
  let fieldVisualization = UIView(frame: CGRectMake(50, 250, 200, 200))
  fieldVisualization.backgroundColor = UIColor.lightGrayColor()
  mainView.insertSubview(fieldVisualization, atIndex: 0)
  
  let parentBehavior = UIDynamicBehavior()
  
  let collisionBehavor = UICollisionBehavior(items: [whiteSquare])
  collisionBehavor.translatesReferenceBoundsIntoBoundary = true
  parentBehavior.addChildBehavior(collisionBehavor)
  
  let viewBehavior = UIDynamicItemBehavior(items: [whiteSquare])
  viewBehavior.density = 0.01
  viewBehavior.resistance = 10
  viewBehavior.friction = 0.0
  viewBehavior.allowsRotation = false
  parentBehavior.addChildBehavior(viewBehavior)
  
//: Add a spring region for the swinging thing to get caught in
  let fieldBehavior = UIFieldBehavior.springField()
  fieldBehavior.addItem(whiteSquare)
  fieldBehavior.position = CGPointMake(150, 350)
  fieldBehavior.region = UIRegion(size: CGSizeMake(200, 200))
  fieldBehavior.strength = 10.0
  parentBehavior.addChildBehavior(fieldBehavior)
  
  animator.addBehavior(parentBehavior)
}

//: After two seconds, push the white block into the spring field
var delayTime = dispatch_time(DISPATCH_TIME_NOW,
  Int64(2 * Double(NSEC_PER_SEC)))

dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
  let pushBehavior = UIPushBehavior(items: [whiteSquare], mode: .Instantaneous)
  pushBehavior.pushDirection = CGVectorMake(0, -10.5)
  animator.addBehavior(pushBehavior)
}

delayTime = dispatch_time(DISPATCH_TIME_NOW,
  Int64(6 * Double(NSEC_PER_SEC)))
dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
  orangeSquare.center = CGPointMake(450, 150)
//: Moving an item does not restart animation. State must be updated manually on animators or behaviors removed and readded.
  animator.updateItemUsingCurrentState(orangeSquare)
}

// Can be anywhere in code
XCPShowView("Main View", view: mainView)

