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

class ScaleSegue: UIStoryboardSegue {
  
  override func perform() {
    destinationViewController.transitioningDelegate = self
    super.perform()
  }
}

extension ScaleSegue: UIViewControllerTransitioningDelegate {
  func animationControllerForPresentedController(presented: UIViewController,
     presentingController presenting: UIViewController,
     sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ScalePresentAnimator()
  }
}

protocol ViewScaleable {
  var scaleView:UIView { get }
}

class ScalePresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
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
    
    // 1. Get the transition context to- controller and view
    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)

    // 2. Add the to- view to the transition context
    if let toView = toView {
      transitionContext.containerView()?.addSubview(toView)
    }
    
    // 3. Set up the initial state for the animation
    var startFrame = CGRect.zero
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