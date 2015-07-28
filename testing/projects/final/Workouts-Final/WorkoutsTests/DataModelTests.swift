//
//  DataModelTests.swift
//  Workouts
//
//  Created by Pietro Rea on 7/26/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import XCTest
@testable import Workouts

class DataModelTests: XCTestCase {
  
  var dataModel: DataModel!
  
  override func setUp() {
    super.setUp()
    dataModel = DataModel()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testSampleDataAdded()
  {
    XCTAssert(NSFileManager.defaultManager().fileExistsAtPath(dataModel.dataFilePath()))
  }
  
  func testAllWorkoutsEqualsWorkoutsArray()
  {
    XCTAssertEqual(dataModel.workouts, dataModel.allWorkouts());
    XCTAssertEqual(dataModel.workouts.count, dataModel.allWorkouts().count);
  }
  
  func testAllExercisesEqualsExercisesArray()
  {
    XCTAssertEqual(dataModel.exercises, dataModel.allExercises());
    XCTAssertEqual(dataModel.exercises.count, dataModel.allExercises().count);
  }
  

  
}
