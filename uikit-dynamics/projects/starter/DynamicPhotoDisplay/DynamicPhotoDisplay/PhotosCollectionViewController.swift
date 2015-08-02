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

  override func viewDidLoad() {
    super.viewDidLoad()
    
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
    fullPhotoViewController.photoPair = photoData[index]
    fullPhotoView.center = CGPointMake(fullPhotoView.center.x, fullPhotoView.frame.size.height / -2)
    fullPhotoView.hidden = false
    
    UIView.animateWithDuration(0.5, animations:
      { () -> Void in
        self.fullPhotoView.center = self.view.center
      }, completion: {
        (completed: Bool) -> Void in
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "dismissFullPhoto:")
        self.navigationItem.rightBarButtonItem = doneButton
      })
  }
}