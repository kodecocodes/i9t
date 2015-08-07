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
  
  var fullPhotoViewController: FullPhotoViewController!
  var fullPhotoView: UIView!
  var animator: UIDynamicAnimator!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    animator = UIDynamicAnimator(referenceView: self.view)
    
    self.installsStandardGestureForInteractiveMovement = true
    
    // Add full image view to top view controller
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    fullPhotoViewController = storyBoard.instantiateViewControllerWithIdentifier("FullPhotoVC") as! FullPhotoViewController
    fullPhotoView = fullPhotoViewController.view
    
    addChildViewController(fullPhotoViewController)
    view.addSubview(fullPhotoView)
    fullPhotoViewController.didMoveToParentViewController(self)

    fullPhotoView.hidden = true
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

    UIView.animateWithDuration(0.5, animations:
      { () -> Void in
        self.fullPhotoView.center = CGPointMake(self.fullPhotoView.center.x, self.fullPhotoView.frame.size.height / -2)
      }, completion: {
        (completed: Bool) -> Void in
        self.fullPhotoView.hidden = true
    })
  }
  
  func showFullImageView(index: Int) {
    //1
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.75 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismissFullPhoto:")
      self.navigationItem.rightBarButtonItem = doneButton
    }
    
    //2
    fullPhotoViewController.photoPair = photoData[index]
    fullPhotoView.center = CGPoint(x: fullPhotoView.center.x, y: fullPhotoView.frame.height / -2)
    fullPhotoView.hidden = false
    
    //3
    animator.removeAllBehaviors()
    
    let dynamicItemBehavior = UIDynamicItemBehavior(items: [fullPhotoView])
    dynamicItemBehavior.elasticity = 0.2
    dynamicItemBehavior.density = 400
    animator.addBehavior(dynamicItemBehavior)
    
    let gravityBehavior = UIGravityBehavior(items: [fullPhotoView])
    gravityBehavior.magnitude = 5.0
    animator.addBehavior(gravityBehavior)
    
    let collisionBehavior = UICollisionBehavior(items: [fullPhotoView])
    let left = CGPoint(x: 0, y: fullPhotoView.frame.height + 1.5)
    let right = CGPoint(x: fullPhotoView.frame.width, y: fullPhotoView.frame.height + 1.5)
    collisionBehavior.addBoundaryWithIdentifier("bottom", fromPoint: left, toPoint: right)
    animator.addBehavior(collisionBehavior)
  }
}