//
//  ViewController.swift
//  PackA
//
//  Created by Caroline Begbie on 19/07/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

  @IBOutlet var photoView: UIImageView!
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ScaleSegue" {
      if let photoView = segue.destinationViewController.view as? UIImageView {
        photoView.image = self.photoView.image
      }
    }
  }

  @IBAction func unwindToImageViewController(segue:UIStoryboardSegue) {
    
  }
}

extension ImageViewController: Scaleable {
  var scaleView:UIView { return photoView }
}