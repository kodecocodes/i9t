//
//  ThumbnailScrollingViewController.swift
//  Topo
//
//  Created by Derek Selander on 6/30/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

protocol ThumbnailScrollingViewControllerDelegate {
  func thumbnailScrollView(scrollView : UIScrollView, didLandOnMapTitle title : String)
}

class ThumbnailScrollingViewController: UIViewController, UIScrollViewDelegate {

  
  @IBOutlet weak var scrollView: UIScrollView!
  var delegate : ThumbnailScrollingViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  func scrollViewDidScroll(scrollView: UIScrollView) {
    self.delegate?.thumbnailScrollView(scrollView , didLandOnMapTitle: "SF_Map")
  }

}
