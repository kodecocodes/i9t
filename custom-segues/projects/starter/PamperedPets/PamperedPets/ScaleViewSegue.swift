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

class ScaleViewSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {
  
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

class ScalePresentAnimator:NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 2
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!

    // Add code to check if inside navigation controller
    
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
    if let toView = toView {
      transitionContext.containerView()?.addSubview(toView)
    }
    
    // Add code to set up start frame here
    
    let finalFrame = transitionContext.finalFrameForViewController(toViewController)
    let startFrame = CGRect.zeroRect
    
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
  }
}

class ScaleDismissAnimator:NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 2
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

    // Add code to check if inside navigation controller
    
    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
    
    if let fromView = fromView {
      if let toView = toView {
        transitionContext.containerView()?.insertSubview(toView, belowSubview: fromView)
      }
    }
    
    // Add code to set up final frame here
    
    let finalFrame = CGRect.zeroRect
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
  }
}



