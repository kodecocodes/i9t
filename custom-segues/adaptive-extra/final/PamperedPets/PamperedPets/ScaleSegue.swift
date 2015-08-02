//
//  ScaleSegue.swift
//  PamperedPets
//
//  Created by Caroline Begbie on 31/07/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class ScaleSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {

  override func perform() {
    destinationViewController.transitioningDelegate = self
    super.perform()
  }
  
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ScalePresentAnimator()
  }
}

protocol ViewScaleable {
  var scaleView:UIView { get }
}

class ScalePresentAnimator:NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 2.0
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
    if let fromNC = fromViewController as? UINavigationController {
      if let controller = fromNC.topViewController {
        fromViewController = controller
      }
    }
    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
    
    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
    
    var startFrame = CGRect.zeroRect
    if let fromViewController = fromViewController as? ViewScaleable {
      startFrame = fromViewController.scaleView.frame
    } else {
      print("Warning: Controller \(fromViewController) does not conform to ViewScaleable")
    }
    toView?.frame = startFrame
    toView?.layoutIfNeeded()
    
    if let toView = toView {
      transitionContext.containerView()?.addSubview(toView)
    }
    
    let duration = transitionDuration(transitionContext)
    let finalFrame = transitionContext.finalFrameForViewController(toViewController)
    
    UIView.animateWithDuration(duration, animations: {
      toView?.frame = finalFrame
      toView?.layoutIfNeeded()
      fromView?.alpha = 0.0
      }, completion: {
        finished in
        fromView?.alpha = 1.0
        transitionContext.completeTransition(true)
    })
  }
}