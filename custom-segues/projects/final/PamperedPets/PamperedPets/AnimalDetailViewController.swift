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

class AnimalDetailViewController: UIViewController {
  
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var ownerName: UILabel!
  @IBOutlet var address: UILabel!
  @IBOutlet var instructions: UITextView!
  
  var animal:Animal? {
    didSet {
      updateViewForAnimal()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // load initial sample data
    // for when this scene is initial scene
    animal = animalData[0]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateViewForAnimal()
  }
  
  private func updateViewForAnimal() {
    if let animal = animal {
      ownerName?.text = animal.owner
      address?.text = animal.address
      instructions?.text = animal.instructions
      imageView?.image = UIImage(named: animal.name)
      self.title = animal.name
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "PhotoDetail" {
      let controller = segue.destinationViewController as! AnimalPhotoViewController
      controller.image = imageView.image
    }
  }
  
  @IBAction func unwindToAnimalDetailViewController(segue:UIStoryboardSegue) {
    // placeholder for unwind segue
  }
}

extension AnimalDetailViewController: ViewScaleable {
  var scaleView:UIView { return imageView }
}

