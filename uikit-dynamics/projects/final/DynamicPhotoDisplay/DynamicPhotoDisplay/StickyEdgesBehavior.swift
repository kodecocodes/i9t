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

enum StickyEdge: Int {
  case Top = 0
  case Bottom
}

class StickyEdgesBehavior: UIDynamicBehavior {
  // MARK: Properties
  
  private var edgeInset: CGFloat
  
  private let itemBehavior: UIDynamicItemBehavior
  
  private let collisionBehavior: UICollisionBehavior
  
  private let item: UIDynamicItem
  
  private var fieldBehaviors = [UIFieldBehavior]()
  
  // Enabling/disabling effectively adds or removes the item from the child behaviors.
  var isEnabled = true {
    didSet {
      if isEnabled {
        for fieldBehavior in fieldBehaviors {
          fieldBehavior.addItem(item)
        }
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
      }
      else {
        for fieldBehavior in fieldBehaviors {
          fieldBehavior.removeItem(item)
        }
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
      }
    }
  }
  
  // MARK: Initializers
  
  init(item: UIDynamicItem, edgeInset: CGFloat) {
    self.item = item
    self.edgeInset = edgeInset
    
    // Setup a collision behavior so the item cannot escape the screen.
    collisionBehavior = UICollisionBehavior(items: [item])
    collisionBehavior.translatesReferenceBoundsIntoBoundary = true
    
    // Setup the item behavior to alter the items physical properties causing it to be "sticky."
    itemBehavior = UIDynamicItemBehavior(items: [item])
    itemBehavior.density = 0.01
    itemBehavior.resistance = 20
    itemBehavior.friction = 0.0
    itemBehavior.allowsRotation = false
    
    super.init()
    
    // Add each behavior as a child behavior.
    addChildBehavior(collisionBehavior)
    addChildBehavior(itemBehavior)

    // Add spring behaviors for the top and bottom of the screen
    for _ in 0...1 {
      let fieldBehavior = UIFieldBehavior.springField()
      fieldBehavior.addItem(item)
      fieldBehaviors.append(fieldBehavior)
      addChildBehavior(fieldBehavior)
    }
  }
  
  // MARK: Public
  
  func updateFieldsInBounds(bounds: CGRect) {
    if bounds != CGRect.zeroRect {
      // Get bounds width & height.
      let h = bounds.height
      let w = bounds.width
      
      // Private function to update the position & region of a given field.
      func updateRegionForField(field: UIFieldBehavior, _ point: CGPoint) {
        let size = CGSize(width: w - 2 * edgeInset, height: h - edgeInset)
        field.position = point
        field.region = UIRegion(size: size)
      }
      
      // Calculate the field origins.
      let top = CGPoint(x: w / 2, y: edgeInset)
      let bottom = CGPoint(x: w / 2, y: h - edgeInset)
      
      // Update each field.
      updateRegionForField(fieldBehaviors[StickyEdge.Top.rawValue], top)
      updateRegionForField(fieldBehaviors[StickyEdge.Bottom.rawValue], bottom)
    }
  }
  
  func addLinearVelocity(velocity: CGPoint) {
    itemBehavior.addLinearVelocity(velocity, forItem: item)
  }
}
