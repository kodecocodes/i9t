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

class WorkoutsUITests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    XCUIApplication().launch()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testAddWorkout() {
    
    let app = XCUIApplication()
    let tablesQuery = app.tables
    
    let oldCount = tablesQuery["Workout Table"].cells.count
    
    tablesQuery.staticTexts["Add New Workout (+)"].tap()
    tablesQuery.textFields["Workout Name Text Field"].tap()
    tablesQuery.textFields["Workout Name Text Field"].typeText("Hello World")
    
    tablesQuery.textFields["Rest Interval Text Field"].tap()
    tablesQuery.textFields["Rest Interval Text Field"].typeText("10")
    
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
