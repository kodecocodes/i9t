/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class SwipeSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {
  
  override func perform() {
    destinationViewController.transitioningDelegate = self
    super.perform()
  }

  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    // Challenge is only swipe to dismiss, so still scale up
    return ScalePresentAnimator()
  }
  
  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return SwipeDismissAnimator()
  }
}

protocol ViewSwipeable {
  var swipeDirection:UISwipeGestureRecognizerDirection { get }
}

class SwipeDismissAnimator:NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 0.5
    
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!

    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)


    if let fromView = fromView {
      if let toView = toView {
        transitionContext.containerView()?.insertSubview(toView, belowSubview: fromView)
      }
    }
    var finalFrame = transitionContext.initialFrameForViewController(fromViewController)
    // Center final frame so it slides  vertically
    let toFinalFrame = transitionContext.finalFrameForViewController(toViewController)
    finalFrame.origin.x = toFinalFrame.width/2 - finalFrame.width/2
    
    if let fromViewController = fromViewController as? ViewSwipeable {
      let direction = fromViewController.swipeDirection
      switch direction {
      case UISwipeGestureRecognizerDirection.Up:
        finalFrame.origin.y = -finalFrame.height
      case UISwipeGestureRecognizerDirection.Down:
        finalFrame.origin.y = UIWindow().bounds.height
      default:()
      }
      
      let duration = transitionDuration(transitionContext)
      UIView.animateWithDuration(duration, animations: {
          fromView?.frame = finalFrame
        }, completion: {
          finished in
          transitionContext.completeTransition(true)
      })
    } else {
      // Not Swipeable
      print("Warning: Controller: \(fromViewController) does not conform to ViewSwipeable")
      transitionContext.completeTransition(true)
    }
  }
  
}

