//
//  BorderedView.swift
//  Prepped
//
//  Created by Caroline Begbie on 25/06/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

@IBDesignable

class BorderedView: UIView {
  
  @IBInspectable var borderColor = UIColor.darkGrayColor()
  @IBInspectable var lineWidth:CGFloat = 2.0
  @IBInspectable var cornerRadius:CGFloat = 5.0
  
  override func drawRect(rect: CGRect) {
    borderColor.setStroke()
    let path = UIBezierPath(roundedRect: CGRectInset(rect, lineWidth/2, lineWidth/2), cornerRadius: cornerRadius)
    path.lineWidth = lineWidth
    path.stroke()
  }
  
}
