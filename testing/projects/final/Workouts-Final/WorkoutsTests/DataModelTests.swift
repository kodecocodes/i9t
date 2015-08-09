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

import XCTest
@testable import Workouts

class DataModelTests: XCTestCase {
  
  var dataModel: DataModel!
  
  override func setUp() {
    super.setUp()
    dataModel = DataModel()
  }
  
  func testSampleDataAdded()
  {
    XCTAssert(NSFileManager.defaultManager()
      .fileExistsAtPath(dataModel.dataFilePath()))
  }
  
  func testAllWorkoutsEqualsWorkoutsArray()
  {
    XCTAssertEqual(dataModel.workouts,
      dataModel.allWorkouts());
    
    XCTAssertEqual(dataModel.workouts.count,
      dataModel.allWorkouts().count);
  }
  
  func testAllExercisesEqualsExercisesArray()
  {
    XCTAssertEqual(dataModel.exercises,
      dataModel.allExercises());
    
    XCTAssertEqual(dataModel.exercises.count,
      dataModel.allExercises().count);
  }
  
  func testContainsUserCreatedWorkout() {
    
    XCTAssertFalse(dataModel.containsUserCreatedWorkout())
    
    let workout1 = Workout()
    dataModel.addWorkout(workout1)
    
    XCTAssertFalse(dataModel.containsUserCreatedWorkout())
    
    let workout2 = Workout()
    workout2.userCreated = true
    dataModel.addWorkout(workout2)
    
    XCTAssert(dataModel.containsUserCreatedWorkout())
  }

  func testContainsUserCreatedExercise() {
    
    XCTAssertFalse(dataModel.containsUserCreatedExercise())
    
    let exercise1 = Exercise()
    dataModel.addExercise(exercise1)
    
    XCTAssertFalse(dataModel.containsUserCreatedExercise())
    
    let exercise2 = Exercise()
    exercise2.userCreated = true
    dataModel.addExercise(exercise2)
    
    XCTAssert(dataModel.containsUserCreatedExercise())
  }
}
