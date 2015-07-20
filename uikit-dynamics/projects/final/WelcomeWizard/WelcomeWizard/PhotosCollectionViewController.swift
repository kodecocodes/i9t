//
//  PhotosCollectionViewController.swift
//  WelcomeWizard
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
  
}

extension PhotosCollectionViewController: UIDynamicAnimatorDelegate {
  func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
    fullPhotoView.hidden = true
    animator.delegate = nil
  }
}