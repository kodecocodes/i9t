//
//  Workout.swift
//  Workouts
//
//  Created by Pietro Rea on 7/22/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import Foundation

let workoutUserCreatedKey = "workoutUserCreatedKey"
let workoutNameKey = "name"
let exercisesKey = "exercises"
let restIntervalKey = "restInterval"

class Workout : NSObject, NSCoding {
  
  var userCreated: Bool!
  var name: String!
  var exercises: Array<Exercise>!
  var restInterval: NSTimeInterval!
  
  var canModify: Bool {
    get {
      return !userCreated
    }
  }
  var canRemove: Bool {
    get {
      return !userCreated
    }
  }
  
  var duration: NSTimeInterval {
    get {
      var totalDuration: NSTimeInterval = 0
      for exercise in exercises {
        totalDuration += exercise.duration
      }
      return totalDuration
    }
  }
  
  func addExercise(exercise: Exercise) -> Bool {
    return true
  }
  
  func removeExercise(exercise: Exercise) -> Bool {
    return true
  }
  
  func performWorkout() {
    
  }
  
  //insertWorkoutAtIndex
  
  //MARK: NSCoding
  
  required convenience init(coder decoder: NSCoder) {
    self.init()
    
    userCreated = decoder.decodeBoolForKey(workoutUserCreatedKey)
    name = decoder.decodeObjectForKey(workoutNameKey) as! String
    exercises = decoder.decodeObjectForKey(exercisesKey) as! Array<Exercise>
    restInterval = decoder.decodeDoubleForKey(restIntervalKey)
  }
  
  func encodeWithCoder(coder: NSCoder) {
    coder.encodeBool(userCreated, forKey: workoutUserCreatedKey)
    coder.encodeObject(name, forKey: workoutNameKey)
    coder.encodeObject(exercises, forKey: exercisesKey)
    coder.encodeDouble(restInterval, forKey: restIntervalKey)
  }
  
}