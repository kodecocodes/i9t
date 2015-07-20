//
//  HeavyCurtainDynamicBehavior.swift
//  DynamicPhotoDisplay
//
//  Created by Aaron Douglas on 7/20/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

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
