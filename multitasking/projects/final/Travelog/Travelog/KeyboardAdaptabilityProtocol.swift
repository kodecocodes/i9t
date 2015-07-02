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

/// A protocol that an arbitrary object, e.g. a UIViewController adopts to
/// so that it can adjust itself when keyboard is shown or hidden.
/// The purpose of this protocol is to implement a set of standard rules
/// that a number of objects can comply to, instead of individually listening
/// to notications for keyboard appearance.
protocol KeyboardAdaptabilityProtocol {
  
  /// Return a UIView or any subclass of that that you want
  /// make the adjustments in. For exmaple you may return a
  /// a UIScrollView whose content inset you intend to update
  /// when keyboard is shown or hidden.
  var adaptiveView: UIView { get }
  
  func adaptToKeyboardAppearnace() 
  
}
