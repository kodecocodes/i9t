//
//  StickyEdgesBehavior.swift
//  DynamicPhotoDisplay
//
//  Created by Richard Turton on 07/08/2015.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import UIKit

enum StickyEdge: Int {
  case Top = 0
  case Bottom
}

class StickyEdgesBehavior: UIDynamicBehavior {
  private var edgeInset: CGFloat
  private let itemBehavior: UIDynamicItemBehavior
  private let collisionBehavior: UICollisionBehavior
  private let item: UIDynamicItem
  private let fieldBehaviors = [
    UIFieldBehavior.springField(),
    UIFieldBehavior.springField()
  ]
  
  init(item: UIDynamicItem, edgeInset: CGFloat) {
    self.item = item
    self.edgeInset = edgeInset
    
    collisionBehavior = UICollisionBehavior(items: [item])
    collisionBehavior.translatesReferenceBoundsIntoBoundary = true
    
    itemBehavior = UIDynamicItemBehavior(items: [item])
    itemBehavior.density = 0.01
    itemBehavior.resistance = 20
    itemBehavior.friction = 0.0
    itemBehavior.allowsRotation = false
    
    super.init()
    
    addChildBehavior(collisionBehavior)
    addChildBehavior(itemBehavior)
    
    for fieldBehavior in fieldBehaviors {
      fieldBehavior.addItem(item)
      addChildBehavior(fieldBehavior)
    }
  }
  
  func updateFieldsInBounds(bounds: CGRect) {
    guard bounds != CGRect.zero else { return }
    let h = bounds.height
    let w = bounds.width
    let itemHeight = item.bounds.height
    
    func updateRegionForField(field: UIFieldBehavior, _ point: CGPoint) {
      let size = CGSize(width: w - 2 * edgeInset, height: h - 2 * edgeInset - itemHeight)
      field.position = point
      field.region = UIRegion(size: size)
    }
    
    let top = CGPoint(x: w / 2, y: edgeInset + itemHeight / 2)
    let bottom = CGPoint(x: w / 2, y: h - edgeInset - itemHeight / 2)
    updateRegionForField(fieldBehaviors[StickyEdge.Top.rawValue], top)
    updateRegionForField(fieldBehaviors[StickyEdge.Bottom.rawValue], bottom)
    
  }
  
  var isEnabled = true {
    didSet {
      if isEnabled {
        for fieldBehavior in fieldBehaviors {
          fieldBehavior.addItem(item)
        }
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
      } else {
        for fieldBehavior in fieldBehaviors {
          fieldBehavior.removeItem(item)
        }
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
      }
    }
  }
  
  func addLinearVelocity(velocity: CGPoint) {
    itemBehavior.addLinearVelocity(velocity, forItem: item)
  }
}
