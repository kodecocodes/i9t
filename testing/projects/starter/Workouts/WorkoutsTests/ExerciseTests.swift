//
//  ExerciseTests.swift
//  Workouts
//
//  Created by Pietro Rea on 7/26/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import XCTest
import Workouts

class ExerciseTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExerciseCanEdit()
  {
    let builtInExercise = Exercise()
    builtInExercise.userCreated = false
    
    let userCreatedExercise = Exercise()
    userCreatedExercise.userCreated = true
    
    XCTAssertFalse(builtInExercise.canEdit, "Bulit-in exercises and not editable")
    XCTAssertTrue(userCreatedExercise.canEdit, "User-created exercises and editable")
  }
  
  func testExerciseCanRemove()
  {
    let builtInExercise = Exercise()
    builtInExercise.userCreated = false
    
    let userCreatedExercise = Exercise()
    userCreatedExercise.userCreated = true
        
    XCTAssertFalse(builtInExercise.canRemove, "Bulit-in exercises and not removable")
    XCTAssertTrue(userCreatedExercise.canRemove, "User-created exercises and removable")
  }
  
}
