//
//  HeavyCurtainDynamicBehavior.swift
//  DynamicPhotoDisplay
//
//  Created by Aaron Douglas on 7/20/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import UIKit

class HeavyCurtainDynamicBehavior: UIDynamicBehavior {
  private let item: UIDynamicItem
  private let collisionBehavior: UICollisionBehavior
  private let itemBehavior: UIDynamicItemBehavior
  
  // Enabling/disabling effectively adds or removes the item from the child behaviors.
  var isEnabled = true {
    didSet {
      if isEnabled {
        collisionBehavior.addItem(item)
      }
      else {
        collisionBehavior.removeItem(item)
      }
    }
  }

  init(item: UIDynamicItem) {
    self.item = item
    collisionBehavior = UICollisionBehavior(items: [item])
    
    itemBehavior = UIDynamicItemBehavior(items: [item])
    itemBehavior.density = 0.01
    itemBehavior.resistance = 10
    itemBehavior.friction = 0.0
    itemBehavior.allowsRotation = false
    
    super.init()
    
    addChildBehavior(collisionBehavior)
    addChildBehavior(itemBehavior)
  }
  
  func addLinearVelocity(velocity: CGPoint) {
    itemBehavior.addLinearVelocity(velocity, forItem: item)
  }
}
