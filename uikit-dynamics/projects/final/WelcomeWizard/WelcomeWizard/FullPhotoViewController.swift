//
//  FullPhotoViewController.swift
//  WelcomeWizard
//
//  Created by Aaron Douglas on 7/19/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import UIKit

class FullPhotoViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let photo = image {
            imageView.image = photo
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
