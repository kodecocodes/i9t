//
//  ScrollViewOverlayTouchForwardingView.swift
//  Topo
//
//  Created by Derek Selander on 6/30/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

class ScrollViewOverlayTouchForwardingView: UIView {
  
  override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
    return self.subviews.first
  }
  

}
