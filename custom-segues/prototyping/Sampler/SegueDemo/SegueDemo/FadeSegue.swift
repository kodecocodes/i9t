//
//  FadeSegue.swift
//  PackA
//
//  Created by Caroline Begbie on 17/07/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit


// This works on both iPhone and form sheet on iPad
// due to using fromView/toView in the animator and not view property of the controllers

class FadeSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {
  
  override func perform() {
    destinationViewController.transitioningDelegate = self
    super.perform()
  }
  
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let fade = FadeAnimationController()
    fade.isPresenting = true
    return fade
  }
  
  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let fade = FadeAnimationController()
    fade.isPresenting = false
    return fade
  }
}


// MARK: - Animator



class FadeAnimationController:NSObject, UIViewControllerAnimatedTransitioning {
  
  var isPresenting = false
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 0.5
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
    
    if isPresenting {
      toView?.alpha = 0.0
      if let toView = toView {
        transitionContext.containerView()?.addSubview(toView)
        //in an iPad form sheet if you add toViewController.view, then it goes wonky
        //because the view is presented within a presentation view
      }
      
    } else {
      if let fromView = fromView {
        if let toView = toView {
          transitionContext.containerView()?.insertSubview(toView, belowSubview: fromView)
        }
        fromView.alpha = 1.0
      }
    }
    
    let duration = transitionDuration(transitionContext)
    
    UIView.animateWithDuration(duration, animations: {
      if self.isPresenting {
        if let toView = toView {
          toView.alpha = 1.0
        }
        
      } else {
        if let fromView = fromView {
          fromView.alpha = 0.0
        }
      }
      }, completion: {
        finished in
        transitionContext.completeTransition(true)
    })
    
  }
  
}


class AdaptableFormSheetSegue: UIStoryboardSegue, UIAdaptivePresentationControllerDelegate {
  override func perform() {
    /*
    Because this class is used for a Present Modally segue, UIKit will
    maintain a strong reference to this segue object for the duration of
    the presentation. That way, this segue object will live long enough
    to act as the presentation controller's delegate and customize any
    adaptation.
    */
    destinationViewController.presentationController?.delegate = self
    
    // Call super to get the standard modal presentation behavior.
    super.perform()
  }
  
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    return traitCollection.horizontalSizeClass == .Compact ? .FullScreen : .FormSheet
  }
  
  func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
    /*
    Load and return the adapted view controller from the Detail storyboard.
    That storyboard is stored within the same bundle that contains this
    class.
    */
    let adaptableFormSheetSegueBundle = NSBundle(forClass: AdaptableFormSheetSegue.self)
    
    return UIStoryboard(name: "Detail", bundle: adaptableFormSheetSegueBundle).instantiateViewControllerWithIdentifier("Adapted")
  }
}

