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

private let reuseIdentifier = "PhotoCell"


class PhotosCollectionViewController: UICollectionViewController {
  var photoData: [PhotoPair] = retrievePhotoData()
  var animator: UIDynamicAnimator?
  var heavyCurtainBehavior: HeavyCurtainDynamicBehavior!
  
  var fullPhotoViewController: FullPhotoViewController!
  var fullPhotoView: UIView!

  // Touch handling
  var offset = CGPoint.zeroPoint
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.installsStandardGestureForInteractiveMovement = true
    
    animator = UIDynamicAnimator(referenceView: self.view)
//    animator?.setValue(true, forKey: "debugEnabled")
    
    // Add full image view to top view controller
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    fullPhotoViewController = storyBoard.instantiateViewControllerWithIdentifier("FullPhotoVC") as! FullPhotoViewController
    fullPhotoView = fullPhotoViewController.view
    
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "pan:")
    fullPhotoView.addGestureRecognizer(panGestureRecognizer)
    
    addChildViewController(fullPhotoViewController)
    view.addSubview(fullPhotoView)
    fullPhotoViewController.didMoveToParentViewController(self)

    fullPhotoView.hidden = true
    
    heavyCurtainBehavior = HeavyCurtainDynamicBehavior(item: fullPhotoView)
    heavyCurtainBehavior.isEnabled = false
    animator?.addBehavior(heavyCurtainBehavior)
  }
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photoData.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
    // Configure the cell
    if let photoCell = cell as? PhotoCollectionViewCell {
      photoCell.imageView.image = photoData[indexPath.item].image
    }
    
    return cell
  }
  
  override func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    let photo = photoData.removeAtIndex(sourceIndexPath.item)
    photoData.insert(photo, atIndex: destinationIndexPath.item)
  }
  
  // MARK: UICollectionViewDelegate
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    showFullImageView(indexPath.item)
  }
  
  // MARK: Private methods
  
  @IBAction func dismissFullPhoto(sender: UIControl) {
    navigationItem.rightBarButtonItem = nil
    
    animator!.removeAllBehaviors()
    animator!.delegate = self
    
    let slidingAttachment = UIAttachmentBehavior.slidingAttachmentWithItem(fullPhotoView, attachmentAnchor: view.center, axisOfTranslation: CGVectorMake(0, 1))
    slidingAttachment.attachmentRange = UIFloatRange(minimum: fullPhotoView.frame.size.height * -1, maximum: fullPhotoView.frame.size.height + 1)
    animator!.addBehavior(slidingAttachment)
    
    let dynamicItemBehavior = UIDynamicItemBehavior(items: [fullPhotoView])
    dynamicItemBehavior.elasticity = 0.2
    dynamicItemBehavior.density = 0.001
    animator!.addBehavior(dynamicItemBehavior)
    
    let pushBehavior = UIPushBehavior(items: [fullPhotoView], mode: .Instantaneous)
    pushBehavior.pushDirection = CGVectorMake(0, -1)
    animator!.addBehavior(pushBehavior)
  }
  
  func showFullImageView(index: Int) {
    let delayTime = dispatch_time(DISPATCH_TIME_NOW,
      Int64(0.75 * Double(NSEC_PER_SEC)))
    
    dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
      let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "dismissFullPhoto:")
      self.navigationItem.rightBarButtonItem = doneButton
    }

    
    fullPhotoViewController.photoPair = photoData[index]
    fullPhotoView.center = CGPointMake(fullPhotoView.center.x, fullPhotoView.frame.size.height / -2)
    fullPhotoView.hidden = false
    
    animator!.removeAllBehaviors()
    animator!.delegate = nil
    
    let dynamicItemBehavior = UIDynamicItemBehavior(items: [fullPhotoView])
    dynamicItemBehavior.elasticity = 0.2
    dynamicItemBehavior.density = 400
    animator!.addBehavior(dynamicItemBehavior)
    
    let gravityBehavior = UIGravityBehavior(items: [fullPhotoView])
    gravityBehavior.magnitude = 5.0
    animator!.addBehavior(gravityBehavior)
    
    let collisionBehavior = UICollisionBehavior(items: [fullPhotoView])
    collisionBehavior.addBoundaryWithIdentifier("bottom", fromPoint: CGPointMake(0, fullPhotoView.frame.size.height + 1.5), toPoint: CGPointMake(fullPhotoView.frame.size.width, fullPhotoView.frame.size.height + 1.5))
    animator!.addBehavior(collisionBehavior)
  }
  
  func pan(pan: UIPanGestureRecognizer) {
    var location = pan.translationInView(view)
    
    switch pan.state {
    case .Began:
      // Capture the initial touch offset from the itemView's center.
      let center = fullPhotoView.center
      offset.x = 0
      offset.y = location.y - center.y
      
      // Disable the behavior while the item is manipulated by the pan recognizer.
      animator!.removeAllBehaviors()
      animator!.delegate = nil
      
    case .Changed:
      // Get reference bounds.
      let referenceBounds = view.bounds
      let referenceHeight = referenceBounds.height
      
      // Get item bounds.
      let itemBounds = fullPhotoView.bounds
      let itemHalfWidth = itemBounds.width / 2.0
      let itemHalfHeight = itemBounds.height / 2.0
      
      // Apply the initial offset.
      location.y -= offset.y
      
      // Bound the item position inside the reference view.
      location.x = itemHalfWidth
      location.y = min(referenceHeight - itemHalfHeight, location.y)
      
      // Apply the resulting item center.
      fullPhotoView.center = location
      
    case .Cancelled, .Ended:
      // Get the current velocity of the item from the pan gesture recognizer.
      var velocity = pan.velocityInView(view)
      velocity.x = 0
      
      // Re-enable the heavyCurtainBehavior.
      heavyCurtainBehavior.isEnabled = true
      animator!.addBehavior(heavyCurtainBehavior)

      if velocity.y < 0.0 && (fullPhotoView.center.y < 0 || velocity.y < -1200) {
        // If we're more than half way up with the full photo, dismiss it with a push
        animator!.removeAllBehaviors()
        // Sets the delegate which will hide the view after animations complete
        animator!.delegate = self

        let dynamicItemBehavior = UIDynamicItemBehavior(items: [fullPhotoView])
        dynamicItemBehavior.elasticity = 0.2
        dynamicItemBehavior.density = 0.005
        animator!.addBehavior(dynamicItemBehavior)
        
        let pushBehavior = UIPushBehavior(items: [fullPhotoView], mode: .Instantaneous)
        pushBehavior.pushDirection = CGVectorMake(0, -1)
        pushBehavior.magnitude = 5
        animator!.addBehavior(pushBehavior)
      } else {
        heavyCurtainBehavior.addLinearVelocity(velocity)
      }
      
    default: ()
    }
  }

}

extension PhotosCollectionViewController: UIDynamicAnimatorDelegate {
  func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
    fullPhotoView.hidden = true
    animator.delegate = nil
    animator.removeAllBehaviors()
  }
}