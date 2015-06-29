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

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  
  // MARK: IBActions 
  
  @IBAction func cameraButtonTapped(sender: UIBarButtonItem?) {
    presentCameraControllerForSourceType(UIImagePickerControllerSourceType.Camera)
  }
  
  @IBAction func noteButtonTapped(sender: UIBarButtonItem?) {
    presentTextController()
  }
  
  // MARK: Private methods
    
  private func presentTextController() {
    guard let controller = storyboard?.instantiateViewControllerWithIdentifier("TextViewNavigationController") else { return }
    presentViewController(controller, animated: true, completion: nil)
  }
  
  //// A helper method to configure and display image picker controller based on the source type. Assumption is that source types are either photo library or camera.
  private func presentCameraControllerForSourceType(sourceType: UIImagePickerControllerSourceType) {
    let controller = UIImagePickerController()
    controller.allowsEditing = true
    controller.delegate = self
    controller.sourceType = sourceType
    controller.view.tintColor = ColorPalette.ultimateRedColor()
    presentViewController(controller, animated: true, completion: nil)
  }
  
  // MARK: UIImagePickerControllerDelegate
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    
    // Only if an image can be successfully retireved...
    if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
    }
    
    picker.dismissViewControllerAnimated(false, completion: nil)
  }
  
}
