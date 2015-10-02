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

@IBDesignable
public class Canvas : UIView {
  
  var image: UIImage? {
    return drawing
  }
  
  private var drawing: UIImage?
  
  @IBInspectable
  public var strokeWidth: CGFloat = 4.0
  
  @IBInspectable
  public var strokeColor = UIColor.hotPinkColor()
}

extension Canvas {
  public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let touch = touches.first {
      addLineFromPoint(touch.previousLocationInView(self), toPoint: touch.locationInView(self))
    }
  }
}

extension Canvas {
  private func addLineFromPoint(from: CGPoint, toPoint: CGPoint) {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
    
    drawing?.drawInRect(bounds)
    
    let cxt = UIGraphicsGetCurrentContext()
    CGContextMoveToPoint(cxt, from.x, from.y)
    CGContextAddLineToPoint(cxt, toPoint.x, toPoint.y)
    
    CGContextSetLineCap(cxt, .Round)
    
    CGContextSetLineWidth(cxt, strokeWidth)
    
    strokeColor.setStroke()
    
    CGContextStrokePath(cxt)
    
    drawing = UIGraphicsGetImageFromCurrentImageContext()
    
    layer.contents = drawing?.CGImage
    
    UIGraphicsEndImageContext()
  }
  
}
