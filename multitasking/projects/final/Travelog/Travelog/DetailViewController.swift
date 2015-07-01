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
import TravelogKit

enum DetailViewState {
  case DisplayNone
  case DisplayTextLog
  case DisplayImageLog
}

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet private var photoLibraryButton: UIBarButtonItem!
  @IBOutlet private var cameraButton: UIBarButtonItem!
  @IBOutlet private var addNoteButton: UIBarButtonItem!
  @IBOutlet private var editButton: UIBarButtonItem!
  
  @IBOutlet private var textView: UITextView!
  @IBOutlet private var imageView: UIImageView!
  @IBOutlet private var errorView: UIView!
  
  let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .LongStyle
    formatter.timeStyle = .MediumStyle
    return formatter
  }()
  
  var selectedLog: BaseLog? {
    didSet {
      if let selectedLog = selectedLog as? TextLog {
        textView.text = selectedLog.text
        setDetailViewState(DetailViewState.DisplayTextLog)
        title = self.dateFormatter.stringFromDate(selectedLog.date)
      } else if let selectedLog = selectedLog as? ImageLog {
        imageView.image = selectedLog.image
        setDetailViewState(DetailViewState.DisplayImageLog)
        title = self.dateFormatter.stringFromDate(selectedLog.date)
      } else {
        setDetailViewState(DetailViewState.DisplayNone)
        title = nil
      }
    }
  }
  
  // MARK: Life Cycle
  
  deinit {
    LogStore.sharedStore.unregisterObserver(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let hasCamera = UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Rear) ||
      UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Front)
    cameraButton.enabled = hasCamera
    setDetailViewState(DetailViewState.DisplayNone)
  }
  
  // MARK: IBActions 
  
  @IBAction func photoLibraryButtonTapped(sender: UIBarButtonItem?) {
    presentCameraControllerForSourceType(UIImagePickerControllerSourceType.PhotoLibrary)
  }
  
  @IBAction func cameraButtonTapped(sender: UIBarButtonItem?) {
    presentCameraControllerForSourceType(UIImagePickerControllerSourceType.Camera)
  }
  
  @IBAction func addNoteButtonTapped(sender: UIBarButtonItem?) {
    presentTextViewController(nil)
  }
  
  @IBAction func editButtonTapped(sender: UIBarButtonItem?) {
    // Edit button is only visible when selected log is a text log.
    guard let selectedLog = selectedLog as? TextLog else { return }
    presentTextViewController(selectedLog.text)
  }
  
  // MARK: Private methods
  
  /// Set the state of the Detail View (show or hide UI elements that are relevant).
  private func setDetailViewState(state: DetailViewState) {
    // If it's a text log, update label and hide image view.
    // If it's an image log, update image view and hide label.
    // If it's neither of them, hide both label and image view.
    switch state {
    case .DisplayNone:
      errorView.hidden = false
      textView.hidden = true
      imageView.hidden = true
      textView.text = nil
      imageView.image = nil
      navigationItem.setRightBarButtonItems([photoLibraryButton, cameraButton, addNoteButton], animated: true)
      
    case .DisplayTextLog:
      errorView.hidden = true
      textView.hidden = false
      imageView.hidden = true
      imageView.image = nil
      navigationItem.setRightBarButtonItems([editButton], animated: true)
      
    case .DisplayImageLog:
      errorView.hidden = true
      textView.hidden = true
      imageView.hidden = false
      textView.text = nil
      navigationItem.setRightBarButtonItems([photoLibraryButton, cameraButton], animated: true)
    }
  }
  
  /// Present a text view controller. Optionally you may pass in a text object to be edited.
  private func presentTextViewController(textToEdit: String?) {
    guard let textViewNavigationController = storyboard?.instantiateViewControllerWithIdentifier("TextViewNavigationController") as? UINavigationController else { return }
    guard let controller = textViewNavigationController.viewControllers.first as? TextViewController else { return }
    unowned let weakSelf = self
    controller.saveActionBlock = { (text: String) -> () in
      
      let textLogToSave: TextLog
      
      // If it was an edit to the existing log, update the log.
      if let selectedLog = weakSelf.selectedLog {
        textLogToSave = TextLog(text: text, date: selectedLog.date)
        weakSelf.textView.text = text
      } else {
        // It is a new note (text log).
        textLogToSave = TextLog(text: text, date: NSDate())
      }
      
      // Save it.
      let store = LogStore.sharedStore
      store.logCollection.addLog(textLogToSave)
      store.save()
      
      weakSelf.dismissViewControllerAnimated(true, completion: nil)
    }
    controller.cancelActionBlock = {
      weakSelf.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Present text view controller and pass on the textToEdit if any.
    // Otherwise provide a placeholder.
    presentViewController(textViewNavigationController, animated: true) { () -> Void in
      if let textToEdit = textToEdit { controller.setText(textToEdit) }
      else { controller.setText("Today, I'm going to write about ...") }
    }
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
    
    // Only if an image can be successfully retrieved...
    if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
      
      let imageLogToSave: ImageLog
      
      // If it was an edit to the existing log, update the log.
      if let selectedLog = selectedLog {
        imageLogToSave = ImageLog(image: image, date: selectedLog.date)
        imageView.image = image
      } else {
        // It is a new image log.
        imageLogToSave = ImageLog(image: image, date: NSDate())
      }
      
      // Save it.
      let store = LogStore.sharedStore
      store.logCollection.addLog(imageLogToSave)
      store.save()
    }
    
    picker.dismissViewControllerAnimated(false, completion: nil)
  }
  
}
