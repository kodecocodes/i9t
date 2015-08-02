//
//  ScaleSegue.swift
//  PamperedPets
//
//  Created by Caroline Begbie on 2/08/2015.
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
  
  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ScaleDismissAnimator()
  }
}

protocol ViewScaleable {
  var scaleView:UIView { get }
}

class ScalePresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 0.5
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
    if let fromNC = fromViewController as? UINavigationController {
      if let controller = fromNC.topViewController {
        fromViewController = controller
      }
    }
    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)

    // 1. Get the transition context to- controller and view
    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
    
    // 2. Add the to-view to the transition context
    if let toView = toView {
      transitionContext.containerView()?.addSubview(toView)
    }
    
    // 3. Set up the initial state for the animation
    var startFrame = CGRect.zeroRect
    if let fromViewController = fromViewController as? ViewScaleable {
      startFrame = fromViewController.scaleView.frame
    } else {
      print("Warning: Controller \(fromViewController) does not conform to ViewScaleable")
    }
    toView?.frame = startFrame
    toView?.layoutIfNeeded()
    
    // 4. Perform the animation
    let duration = transitionDuration(transitionContext)
    let finalFrame = transitionContext.finalFrameForViewController(toViewController)
    
    UIView.animateWithDuration(duration, animations: {
      toView?.frame = finalFrame
      toView?.layoutIfNeeded()
      fromView?.alpha = 0.0
      }, completion: {
        finished in
        fromView?.alpha = 1.0
        // 5. Clean up the transition context
        transitionContext.completeTransition(true)
    })
  }
}

class ScaleDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 0.5
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
    
    // Get the transition context to- controller and view
    var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
    
    if let toNC = toViewController as? UINavigationController {
      if let controller = toNC.topViewController {
        toViewController = controller
      }
    }

    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
    
    // Add the to- view to the transition context
    if let fromView = fromView,
      toView = toView {
        transitionContext.containerView()?.insertSubview(toView, belowSubview:fromView)
    }
    
    // Set up the inital state for the animation
    toView?.alpha = 0.0
    
    // Work out the final frame for the animation
    var finalFrame = CGRect.zeroRect
    if let toViewController = toViewController as? ViewScaleable {
      finalFrame = toViewController.scaleView.frame
    } else {
      print("Warning: Controller \(toViewController) does not conform to ViewScaleable")
    }
    
    // Perform the animation
    let duration = transitionDuration(transitionContext)
    
    UIView.animateWithDuration(duration, animations: {
      fromView?.frame = finalFrame
      fromView?.layoutIfNeeded()
      toView?.alpha = 1.0
      }, completion: {
        finished in
        // Clean up the transition context
        transitionContext.completeTransition(true)
    })
  }
}