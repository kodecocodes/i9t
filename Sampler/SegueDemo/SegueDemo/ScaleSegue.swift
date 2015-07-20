//
//  ScaleSegue.swift
//  PackA
//
//  Created by Caroline Begbie on 19/07/2015.
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

protocol Scaleable {
  var scaleView:UIView { get }
}

class ScalePresentAnimator:NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 0.5
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
    
    var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
    if let from = fromViewController {
      if let fromNC = from as? UINavigationController {
        fromViewController = fromNC.topViewController
      }
    }
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
    if let toView = toView {
      transitionContext.containerView()?.addSubview(toView)
    }

    if let fromViewController = fromViewController as? Scaleable {
      let finalFrame = transitionContext.finalFrameForViewController(toViewController)
      let startFrame = fromViewController.scaleView.frame
      
      toView?.frame = startFrame
      let duration = transitionDuration(transitionContext)

      UIView.animateWithDuration(duration, animations: {
        if let toView = toView {
          toView.frame = finalFrame
        }
        }, completion: {
          finished in
          transitionContext.completeTransition(true)
      })
    } else {
      // Not Scaleable
      print("Warning: Controller: \(toViewController) does not conform to Scaleable")
      transitionContext.completeTransition(true)
    }
  }
}

class ScaleDismissAnimator:NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 0.5
    
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
    if let controller = toViewController as? UINavigationController {
      if controller.topViewController != nil {
        toViewController = controller.topViewController!
      }
    }

    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)

    if let fromView = fromView {
      if let toView = toView {
        transitionContext.containerView()?.insertSubview(toView, belowSubview: fromView)
      }
    }

    if let toViewController = toViewController as? Scaleable {
      let finalFrame = toViewController.scaleView.frame
      let duration = transitionDuration(transitionContext)
      
      UIView.animateWithDuration(duration, animations: {
        if let fromView = fromView {
          fromView.frame = finalFrame
        }
        }, completion: {
          finished in
          transitionContext.completeTransition(true)
      })
    } else {
      // Not Scaleable
      print("Warning: Controller: \(toViewController) does not conform to Scaleable")
      transitionContext.completeTransition(true)
    }
  }
  
}



