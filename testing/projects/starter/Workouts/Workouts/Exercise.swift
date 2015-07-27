//
//  Exercise.swift
//  Workouts
//
//  Created by Pietro Rea on 7/22/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import Foundation
import UIKit

let exerciseUserCreatedKey = "exerciseUserCreated"
let exerciseNameKey = "exerciseNameKey"
let photoKey = "photo"
let instructionKey = "instructions"
let durationKey = "durationKey"


class Exercise : NSObject, NSCoding {
  
  var userCreated: Bool!
  var name: String!
  var photoFileName: String!
  var instructions: String!
  var duration: NSTimeInterval! //readonly
  
  var canEdit: Bool {
    get {
      return userCreated
    }
  }
  var canRemove: Bool {
    get {
      return userCreated
    }
  }
  
  var thumbnail: UIImage {
    get {
      return resizeImageWithSize(CGSizeMake(50, 50))
    }
  }
  
  //MARK: NSCoding
  
  required convenience init(coder decoder: NSCoder) {
    self.init()
    
    userCreated = decoder.decodeBoolForKey(exerciseUserCreatedKey)
    name = decoder.decodeObjectForKey(exerciseNameKey) as! String
    photoFileName = decoder.decodeObjectForKey(photoKey) as! String
    instructions = decoder.decodeObjectForKey(instructionKey) as! String
    duration = decoder.decodeDoubleForKey(durationKey)
  }
  
  func encodeWithCoder(coder: NSCoder) {
    coder.encodeBool(userCreated, forKey: exerciseUserCreatedKey)
    coder.encodeObject(name, forKey: exerciseNameKey)
    coder.encodeObject(photoFileName, forKey: photoKey)
    coder.encodeObject(instructions, forKey: instructionKey)
    coder.encodeDouble(duration, forKey: durationKey)
  }
  
  //MARK - Helper methods
  
  private func resizeImageWithSize(size: CGSize) ->  UIImage {
    
    let image = UIImage(named: photoFileName)! //research
    
    UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
    image.drawInRect(CGRectMake(0, 0, size.width, size.height))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
  }
  
}