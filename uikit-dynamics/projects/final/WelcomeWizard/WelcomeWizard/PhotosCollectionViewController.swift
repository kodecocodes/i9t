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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animator = UIDynamicAnimator(referenceView: view)
        animator!.setValue(true, forKey: "debugEnabled")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        photos.append(UIImage(named: "400-0.jpeg")!)
        photos.append(UIImage(named: "400-1.jpeg")!)
        photos.append(UIImage(named: "400-2.jpeg")!)
        photos.append(UIImage(named: "400-3.jpeg")!)
        photos.append(UIImage(named: "400-4.jpeg")!)
        photos.append(UIImage(named: "400-5.jpeg")!)
        photos.append(UIImage(named: "400-6.jpeg")!)
        photos.append(UIImage(named: "400-7.jpeg")!)
        photos.append(UIImage(named: "400-8.jpeg")!)
        photos.append(UIImage(named: "400-9.jpeg")!)
        photos.append(UIImage(named: "400-10.jpeg")!)
        photos.append(UIImage(named: "400-11.jpeg")!)
        photos.append(UIImage(named: "400-12.jpeg")!)
        photos.append(UIImage(named: "400-13.jpeg")!)
        photos.append(UIImage(named: "400-14.jpeg")!)
        photos.append(UIImage(named: "400-15.jpeg")!)
        photos.append(UIImage(named: "400-16.jpeg")!)
        photos.append(UIImage(named: "400-17.jpeg")!)
        photos.append(UIImage(named: "400-18.jpeg")!)
        photos.append(UIImage(named: "400-19.jpeg")!)
        photos.append(UIImage(named: "400-20.jpeg")!)
        photos.append(UIImage(named: "400-21.jpeg")!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FullImage" {
            let indexPath = collectionView!.indexPathForCell(sender! as! UICollectionViewCell)
            let image = self.photos[indexPath!.item]
            let fullPhotoVC = segue.destinationViewController as! FullPhotoViewController
            fullPhotoVC.image = image
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        // Configure the cell
        if let photoCell = cell as? PhotoCollectionViewCell {
            photoCell.imageView.image = self.photos[indexPath.item]
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    @IBAction func unwindToPhotos(sender: UIStoryboardSegue) {
        self.childViewControllers[0].view.removeFromSuperview()
        self.childViewControllers[0].removeFromParentViewController()
    }
    
}
