//
//  ScaleSegue.swift
//  PackA
//
//  Created by Caroline Begbie on 19/07/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class CellScaleSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {
  
  override func perform() {
    destinationViewController.transitioningDelegate = self
    super.perform()
  }
  
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CellScalePresentAnimator()
  }
  
  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CellScaleDismissAnimator()
  }
  
}

protocol CellScaleable {
  var cellView:UIView? { get }
  var cellViewFrame:CGRect { get }
}

// MARK:- Animators


class CellScalePresentAnimator:NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 0.5
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
    
    if let toView = toView {
      transitionContext.containerView()?.addSubview(toView)
    }
    
    var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
    if let from = fromViewController {
      if let fromNC = from as? UINavigationController {
        fromViewController = fromNC.topViewController
      }
    }
    if let fromViewController = fromViewController as? CellScaleable {
      let finalFrame = transitionContext.finalFrameForViewController(toViewController)
      
      let startFrame = fromViewController.cellViewFrame
      toView?.frame = startFrame
      toView?.layoutIfNeeded()
      
      let duration = transitionDuration(transitionContext)
      UIView.animateWithDuration(duration, animations: {
        if let toView = toView {
          toView.frame = finalFrame
          toView.layoutIfNeeded()
        }
        }, completion: {
          finished in
          transitionContext.completeTransition(true)
      })
    } else {
      // Not Scaleable
      print("Warning: Controller: \(fromViewController) does not conform to CellScaleable")
      transitionContext.completeTransition(true)
    }
  }
}

class CellScaleDismissAnimator:NSObject, UIViewControllerAnimatedTransitioning {
  
  var closure : (() -> ())!
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 0.5
  }
  
  func animationEnded(transitionCompleted: Bool) {
    if let closure = closure {
      closure()
    }
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
    
    if let toViewController = toViewController  as? CellScaleable {
      let finalFrame = toViewController.cellViewFrame
      
      let duration = transitionDuration(transitionContext)
      
      UIView.animateWithDuration(duration, animations: {
        if let fromView = fromView {
          fromView.frame = finalFrame
          fromView.layoutIfNeeded()
        }
        }, completion: {
          finished in
          transitionContext.completeTransition(true)
      })
    } else {
      // Not Scaleable
      print("Warning: Controller: \(toViewController) does not conform to CellScaleable")
      transitionContext.completeTransition(true)
    }
  }
}
