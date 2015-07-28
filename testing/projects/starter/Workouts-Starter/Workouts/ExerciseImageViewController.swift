//
//  ExerciseImageViewController.swift
//  Workouts
//
//  Created by Pietro Rea on 7/26/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

class ExerciseImageViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  var exercise: Exercise!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = exercise.name
    imageView.image = UIImage(named: exercise.photoFileName)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
