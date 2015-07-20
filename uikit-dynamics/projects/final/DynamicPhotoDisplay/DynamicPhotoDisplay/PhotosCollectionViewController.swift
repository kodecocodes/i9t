//
//  PhotosCollectionViewController.swift
//  DynamicPhotoDisplay
//
//  Created by Aaron Douglas on 7/19/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoCell"

class PhotosCollectionViewController: UICollectionViewController {
  var photos = [UIImage]()
  var animator: UIDynamicAnimator?
  
  @IBOutlet var fullPhotoViewController: UIViewController!
  @IBOutlet var fullPhotoView: UIView!
  @IBOutlet var imageView: UIImageView!

  // Touch handling
  var offset = CGPoint.zeroPoint

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    animator = UIDynamicAnimator(referenceView: self.view)

    // Data initialization
    (0...21).map({
      photos.append(UIImage(named: "400-\($0).jpeg")!)
    })
    
    // Add full image view to top view controller
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    fullPhotoViewController = storyBoard.instantiateViewControllerWithIdentifier("FullPhotoVC")
    fullPhotoView = fullPhotoViewController.view
    imageView = fullPhotoView.viewWithTag(100) as! UIImageView
    let button = fullPhotoView.viewWithTag(200) as! UIButton
    button.addTarget(self, action: "dismissFullPhoto:", forControlEvents: UIControlEvents.AllEvents)
    
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "pan:")
    fullPhotoView.addGestureRecognizer(panGestureRecognizer)
    
    addChildViewController(fullPhotoViewController)
    view.addSubview(fullPhotoView)
    fullPhotoView.frame = view.frame
    fullPhotoView.setNeedsLayout()
    fullPhotoView.hidden = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
    // Configure the cell
    if let photoCell = cell as? PhotoCollectionViewCell {
      photoCell.imageView.image = photos[indexPath.item]
    }
    
    return cell
  }
  
  // MARK: UICollectionViewDelegate
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    showFullImageView(photos[indexPath.item])
  }
  
  // MARK: Private methods
  
  @IBAction func dismissFullPhoto(sender: UIButton) {
    animator!.removeAllBehaviors()
    animator!.delegate = self
    
    let slidingAttachment = UIAttachmentBehavior.slidingAttachmentWithItem(fullPhotoView, attachmentAnchor: navigationController!.view.center, axisOfTranslation: CGVectorMake(0, 1))
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
  
  func showFullImageView(image: UIImage) {
    fullPhotoView.frame = view.frame
    fullPhotoView.setNeedsLayout()
    
    imageView.image = image
    fullPhotoView.center = CGPointMake(fullPhotoView.center.x, fullPhotoView.frame.size.height / -2)
    fullPhotoView.hidden = false
    
    animator!.removeAllBehaviors()
    
    let dynamicItemBehavior = UIDynamicItemBehavior(items: [fullPhotoView])
    dynamicItemBehavior.elasticity = 0.2
    dynamicItemBehavior.density = 400
    animator!.addBehavior(dynamicItemBehavior)
    
    let gravityBehavior = UIGravityBehavior(items: [fullPhotoView])
    gravityBehavior.magnitude = 5.0
    animator!.addBehavior(gravityBehavior)
    
    let collisionBehavior = UICollisionBehavior(items: [fullPhotoView])
    collisionBehavior.addBoundaryWithIdentifier("bottom", fromPoint: CGPointMake(0, fullPhotoView.frame.size.height + 1), toPoint: CGPointMake(fullPhotoView.frame.size.width, fullPhotoView.frame.size.height + 1))
    animator!.addBehavior(collisionBehavior)
    
    let slidingAttachment = UIAttachmentBehavior.slidingAttachmentWithItem(fullPhotoView, attachmentAnchor: view.center, axisOfTranslation: CGVectorMake(0, 1))
    slidingAttachment.attachmentRange = UIFloatRange(minimum: fullPhotoView.frame.size.height * -1, maximum: fullPhotoView.frame.size.height + 1)
    animator!.addBehavior(slidingAttachment)
  }
  
  func pan(pan: UIPanGestureRecognizer) {
    var location = pan.locationInView(view)
    
    switch pan.state {
    case .Began:
      // Capture the initial touch offset from the itemView's center.
      let center = fullPhotoView.center
      offset.x = location.x - center.x
      offset.y = location.y - center.y
      
      // Disable the behavior while the item is manipulated by the pan recognizer.
//      stickyBehavior.isEnabled = false
      
    case .Changed:
      // Get reference bounds.
      let referenceBounds = view.bounds
      let referenceWidth = referenceBounds.width
      let referenceHeight = referenceBounds.height
      
      // Get item bounds.
      let itemBounds = fullPhotoView.bounds
      let itemHalfWidth = itemBounds.width / 2.0
      let itemHalfHeight = itemBounds.height / 2.0
      
      // Apply the initial offset.
      location.x -= offset.x
      location.y -= offset.y
      
      // Bound the item position inside the reference view.
      location.x = max(itemHalfWidth, location.x)
      location.x = min(referenceWidth - itemHalfWidth, location.x)
//      location.y = max(itemHalfHeight, location.y)
      location.y = min(referenceHeight - itemHalfHeight, location.y)
      
      // Apply the resulting item center.
      fullPhotoView.center = location
      
    case .Cancelled, .Ended:
      // Get the current velocity of the item from the pan gesture recognizer.
      let velocity = pan.velocityInView(view)
      
      // Re-enable the stickyCornersBehavior.
//      stickyBehavior.isEnabled = true
      
      // Add the current velocity to the sticky corners behavior.
//      stickyBehavior.addLinearVelocity(velocity)
      
    default: ()
    }
  }

}

extension PhotosCollectionViewController: UIDynamicAnimatorDelegate {
  func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
    fullPhotoView.hidden = true
    animator.delegate = nil
  }
}