//
//  WorkoutsUITests.swift
//  WorkoutsUITests
//
//  Created by Pietro Rea on 7/27/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import XCTest

class WorkoutsUITests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication().launch()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testAddWorkout() {
    
    let app = XCUIApplication()
    let tablesQuery = app.tables
    
    let oldCount = tablesQuery["Workout Table"].cells.count
    
    tablesQuery.staticTexts["Add New Workout (+)"].tap()
    tablesQuery.textFields["Workout Name Text Field"].tap()
    tablesQuery.textFields["Workout Name Text Field"].typeText("Hello World")
    
    tablesQuery.textFields["Duration Text Field"].tap()
    tablesQuery.textFields["Duration Text Field"].typeText("10")
    
    tablesQuery.staticTexts["Jumping Jacks"].tap()
    app.navigationBars["Workouts.AddWorkoutView"].buttons["Save"].tap()
    
    XCTAssertEqual(tablesQuery["Workout Table"].cells.count, oldCount + 1)
  }
  
  func testAddExercise()
  {
    let app = XCUIApplication()
    let tabBarsQuery = app.tabBars
    tabBarsQuery.buttons["Exercises"].tap()
    
    let oldCount = app.tables["Exercise Table"].cells.count
    
    app.tables.staticTexts["Add New Exercise (+)"].tap()
    let alert = app.alerts["Add New Exercise"]
    alert.textFields["Name"].tap()
    alert.textFields["Name"].typeText("My Exercise")
    alert.textFields["e.g. 30"].tap()
    alert.textFields["e.g. 30"].typeText("10")
    alert.textFields["Instructions (Optional)"].tap()
    alert.textFields["Instructions (Optional)"].typeText("My Instructions")
    
    alert.buttons["Save"].tap()
    
    XCTAssertEqual(app.tables["Exercise Table"].cells.count, oldCount + 1)
  }
}
