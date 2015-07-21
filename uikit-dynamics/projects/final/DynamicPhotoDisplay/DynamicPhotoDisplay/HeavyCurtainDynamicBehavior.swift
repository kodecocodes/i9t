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

class HeavyCurtainDynamicBehavior: UIDynamicBehavior {
  private let item: UIView
  private let collisionBehavior: UICollisionBehavior
  private let itemBehavior: UIDynamicItemBehavior
  private let gravityBehavior: UIGravityBehavior
  
  // Enabling/disabling effectively adds or removes the item from the child behaviors.
  var isEnabled = true {
    didSet {
      if isEnabled {
        collisionBehavior.addBoundaryWithIdentifier("Bottom Border", fromPoint: CGPointMake(0, item.frame.size.height), toPoint: CGPointMake(item.frame.size.width, item.frame.size.height))
        itemBehavior.addItem(item)
        gravityBehavior.addItem(item)
      } else {
        collisionBehavior.removeAllBoundaries()
        itemBehavior.removeItem(item)
        gravityBehavior.removeItem(item)
      }
    }
  }

  init(item: UIView) {
    self.item = item
    
    collisionBehavior = UICollisionBehavior(items: [item])
    collisionBehavior.addBoundaryWithIdentifier("Bottom Border", fromPoint: CGPointMake(0, item.frame.size.height), toPoint: CGPointMake(item.frame.size.width, item.frame.size.height))

    itemBehavior = UIDynamicItemBehavior(items: [item])
    itemBehavior.density = 400
    itemBehavior.resistance = 10
    itemBehavior.friction = 0.0
    itemBehavior.allowsRotation = false

    gravityBehavior = UIGravityBehavior(items: [item])
    gravityBehavior.magnitude = 5
    
    super.init()
    
    addChildBehavior(collisionBehavior)
    addChildBehavior(itemBehavior)
    addChildBehavior(gravityBehavior)
  }
  
  func addLinearVelocity(velocity: CGPoint) {
    itemBehavior.addLinearVelocity(velocity, forItem: item)
  }
}
