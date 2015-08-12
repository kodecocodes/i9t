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
  
  func testExerciseCanEdit() {
    let builtInExercise = Exercise()
    builtInExercise.userCreated = false
    
    let userCreatedExercise = Exercise()
    userCreatedExercise.userCreated = true
    
    XCTAssertFalse(builtInExercise.canEdit, "Bulit-in exercises are not editable")
    XCTAssertTrue(userCreatedExercise.canEdit, "User-created exercises are editable")
  }
  
  func testExerciseCanRemove() {
    let builtInExercise = Exercise()
    builtInExercise.userCreated = false
    
    let userCreatedExercise = Exercise()
    userCreatedExercise.userCreated = true
    
    XCTAssertFalse(builtInExercise.canRemove, "Built-in exercises are not removable")
    XCTAssertTrue(userCreatedExercise.canRemove, "User-created exercises are removable")
  }
  
}
