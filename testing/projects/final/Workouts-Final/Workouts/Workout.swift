//
//  Workout.swift
//  Workouts
//
//  Created by Pietro Rea on 7/22/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import Foundation

private let userCreatedKey = "workoutUserCreatedKey"
private let nameKey = "name"
private let restIntervalKey = "restInterval"
private let exercisesKey = "exercises"
private let counterKey = "workoutCounter"

class Workout : NSObject, NSCoding {
  
  var userCreated: Bool!
  var name: String!
  var restInterval: NSTimeInterval = 0.0
  var exercises = Array<Exercise>()
  private var workoutCounter: Int = 0
  
  var workoutCount: Int {
    get {
      return workoutCounter
    }
  }
  
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
  
  var duration: NSTimeInterval {
    get {
      var totalDuration: NSTimeInterval = 0
      for exercise in exercises {
        totalDuration += exercise.duration
      }
      
      totalDuration += Double(exercises.count / 2) * restInterval
      
      return totalDuration
    }
  }
  
  func addExercise(exercise: Exercise) {
    exercises.append(exercise)
  }
  
  func removeExercise(exercise: Exercise) -> Bool {
    return true
  }
  
  func performWorkout() {
    workoutCounter++
  }
  
  //MARK: NSCoding
  
  required convenience init(coder decoder: NSCoder) {
    self.init()
    
    userCreated = decoder.decodeBoolForKey(userCreatedKey)
    name = decoder.decodeObjectForKey(nameKey) as! String
    exercises = decoder.decodeObjectForKey(exercisesKey) as! Array<Exercise>
    restInterval = decoder.decodeDoubleForKey(restIntervalKey)
    workoutCounter = decoder.decodeIntegerForKey(counterKey)
  }
  
  func encodeWithCoder(coder: NSCoder) {
    coder.encodeBool(userCreated, forKey: userCreatedKey)
    coder.encodeObject(name, forKey: nameKey)
    coder.encodeObject(exercises, forKey: exercisesKey)
    coder.encodeDouble(restInterval, forKey: restIntervalKey)
    coder.encodeInteger(workoutCounter, forKey: counterKey)
  }
  
}