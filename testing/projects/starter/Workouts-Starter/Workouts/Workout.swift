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