# Chapter X: What's New In Testing?

"How did this feature break _again_?" If you've been writing code for any length of time, you have probably asked yourself that question at least once. As any experienced programmer will tell you, writing code "right" the first time difficult. And even if you get it right the first time, as you add more code to your project you can unknowingly introduce bugs in parts of your application that previously worked flawlessly.

Wouldn't it be great if you could add little "scaffolds" as you write code? These would prevent code from failing after you've moved on to something else. At the very least they would tell you if something doesn't work anymore. The good news is you can. You can write tests!

Testing is a proven software engineering practice that makes software robust and maintainable and it should be a part of every developer's toolkit. Today it's easy to add unit tests to an iOs project, but it wasn't always that way.

Over the past few years, Apple has made it easier to test your iOS apps. Heres's a short recap of what's happened in the world of iOS testing since iOS 7:
- In Xcode 5/iOS 7, Apple introduced the first version of the `XCTest` framework. With this framework you can write unit tests without having to rely on third party libraries.
- In Xcode 6/iOS 8, Apple beefed up `XCTest` by adding asynchronous testing as well as performance testing.
- This year, with Xcode 7 and iOS 9, Apple introduced code coverage reports and UI testing.

Before Xcode 7 you couldn't use `XCTest` to test your user interface or write functional tests. You could have used third party libraries such as KIF and Cucumber that filled this gap. The problem is that these libraries weren't integrated into Xcode and you'd sometimes find yourself fighting an uphill battle.

This chapter focuses on the new additions to `XCTest`. If you're interested in UI testing but don't know much about `XCTest` you should first read **Chapter 11** in **iOS 7 by Tutorials**, "Unit Testing in Xcode 5" as well as **Chapter 29** in **iOS 8 by Tutorials**, "What's New with Testing?".s

Swift 2.0 also has an important feature related to testing that you'll read about in this chapter, the addition of `@testable imports`, which solves issues related to access control developers previously had. Are you ready to write some tests?

## Introducing the RW workout app

This chapter's sample project is a simple fitness app for iOS. This workouts app has two tabs: Exercises and Workouts. In the exercises tab, you can browse the set of built-in exercises, all time favorites like push-ups and crunches, or create your own. In the workout tab, you can also choose one of the built-in workouts or create your own. If the distinction is not clear, a workout is a sequential list of exercises :]

> **Note**: As you start exploring the sample project in this chapter you'll realize that it's closer to a final product than other sample projects in this app. This is intentional! You won't be adding new features. Since this is a testing chapter, you'll be adding tests to an app that's close to shipping.

Go to this chapter's files and find the Workouts-Starter project. Open Workouts.xcodeproj. Build and run the starter project:

![bordered bezel](/images/add-image.png)

Let's walk through the main functionality of the workouts app. Let's say you want to do a workout. From the workout screen, tap "Ray's Full Body Workout". In the workout detail screen scroll to the bottom and tap "Select and Perform". You'll see this congratulatory alert view:

![bordered bezel](/images/add-image.png)

Go back to the list of workouts and tap on Add New Workout (+). Add the workouts name and its list of exercises. When you're done tap Save on the top right corner:

![bordered bezel](/images/add-image.png)

Tapping save will save the workout and pop you back to the list of workouts. Your newly created workout is at the bottom of the screen. Let's say this workout doesn't give you the burn you wanted. Tap on Edit at the top right screen and delete your workout.

![bordered bezel](/images/add-image.png)

Noticed how the app didn't let you delete built-in workouts? This will be important later in the chapter. Now switch to the exercise tab. Tap on "Add New Exercise +": 

![bordered bezel](/images/add-image.png)

An exercise only takes a name and a duration. Tap save when you're done and your new workout will appear at the bottom of the list. You can try deleting this one again with the edit button on the top right. As before, you can't delete built-in exercises.

Now open the project navigator and take a look at the full list of files in the stater project:

![bordered bezel](/images/add-image.png)

The starter project groups source code files into groups. Before jumping into the code, let's briefly go over the classes in each group:

- **Model:** The project relies on two main model objects, **Exercise.swift** and **Workout.swift**. An exercise model object holds its name, the name of its image file, instructions to perform the exercise and its duration. The duration of an exercise is determined at exercise creation and it's readonly after that. An exercise also keep track of whether it is a build-in exercise or if it was created by the user. This will be important later on.

Similarly, a workout model object also holds its name and whether it is a built-in workout or if it was created by the user. It also holds an array of its exercises as well as the total duration of the workout - a sum of the duration of each exercise plus an optional rest interval between exercises. 

If a user creates an exercise or a workout, it's saved to disk do the user doesn't lose data between app launches. Both Exercise and Workout conform to NSCoding to persist user data on disk. DataModel helps store and retrieve information from disk. It also helps answer queries such as "give me all exercises" or "give me all workouts"

- **WorkoutTests:** The sample app already includes some tests in its testing target. **Exercises.swift** and **WorkoutsTests.swift** contain unit tests for their respective model objects. **DataModelTests.swift** is supposed to test `DataModel`...but if you take a closer look you'll see that the file doesn't include any unit tests.

- View Controllers: **WorkoutViewController.swift**, **WorkoutDetailViewController.swift** and **AddWorkoutViewController.swift** all do what their name suggests. `WorkoutViewController` shows you a list of all workouts, both built-in and user-created. When you tap on a specific workout, WorkoutDetailViewController displays the workouts information as well as lets you perform the exercise. AddWorkoutViewController lets you add a new workout to the list of workouts.

Similarly, `ExerciseViewController` displays a list of all exercises in the app. From here you can add a new exercise or tap into an existing exercise, taking you to `ExerciseDetailViewController`. 

> **Note**: Even though the view controller source files are much longer than the model object source files, notice how they don't have any tests. This is a problem! That's a lot of UI code that has no test coverage. You'll learn how to measure and test this code in this chapter.

## Code Coverage

The starter project already comes with tests. However, how do you know if you have _enough_ tests and whether you're testing the right parts of your project? That's where code coverage comes in. New in Xcode 7, you can now get coverage reports to see what is tested and what isn't. Let's try it out.

Code coverage doesn't come turned on by default. Click on the **Workouts** scheme and then on **Edit Scheme...**

![bordered bezel](/images/codeCoverage1.png)

Then select the **Test** action and click on the **Code Coverage -Gather coverage data** checkbox.

![bordered bezel](/images/codeCoverage2.png)

That's all you need to do to turn on code coverage reports. To check your current levels of code coverage you have to run your existing suite of unit tests. You'll be running your unit tests constantly in this chapter so let's do a quick refresher on how to do this. There are three ways to run tests in your testing target:

1. Long click Xcode's **Run** button and click on **Test** from the drop down menu.
1. Select **Product/Test** from Xcode's menu.
1. Use the shortcut **Command+U**

Pick your favorite method and run your unit tests. Xcode will build and launch your app and your tests will run. In the Test Navigator you should see that there are 8 total tests:

![bordered bezel](/images/testNavigator.png)

Let's focus on your code coverage report. Switch to the Report Navigator and click on the latest **Test** action.

![bordered bezel](/images/reportNavigator1.png)

You're currently seeing the **Test** view of the test report. This shows you a list of your unit tests along with a report of the passes and failures. From here, click on the **Coverage** view (circled above) to switch to the code coverage report:

![bordered bezel](/images/reportNavigator2.png)

This report shows you the code coverage for your entire app as well as the code coverage on a file per file basis. For example, the code coverage for the entire app is 38% (yikes!) whereas code coverage for **DataModel.swift** is 93%.

You'll notice that the report won't show you the specific coverage percentage right away. If you want to know this number, hover your mouse over the progress indicator until it shows up. You can also get code coverage numbers for individual files. To do this, click on the disclosure indicator to the left of the file name to drill down to individual classes and methods.

If you've ever shipped a bug to the App Store you'll instantly realize that this information is extremely valuable. Stop for a minute and ask yourself what exactly it means to have 93% coverage.

Xcode can tell you this as well. Hover on top of **Workout.swift** and click on the right arrow that appears next to it:

![bordered bezel](/images/reportNavigator2.png)

Doing this takes you to the file you clicked on in Xcode's main editor. Notice that there's a "gutter" on the right edge of the editor with small numbers on it, such as 0, 2, 6. The number represents the number of times those lines of code are covered by tests. For example, the getter for `workoutCount` isn't covered at all so there's a 0 next to it.   
The level of granularity you get from Xcode's code coverage reports goes beyond the method level. As you can see, it will tell you which lines _inside_ a method are covered and which are not. This helps you identify edge cases you haven't tested. For instance, if you only test the `if` block in an `if-else` statement, Xcode will pick this up and let you know.

> **Note**: A single code coverage report is a snapshot in time. If you want to know whether your code coverage is improving or getting worse, you'll need to see how these numbers change over time. You can achieve this level of monitoring with Xcode server and Xcode bots. This won't be covered in this chapter but you can learn more about this in XX.

## `@testable` imports and access control

As far as test coverage goes, 38% is not something to brag out. Let's improve that number by adding more tests. Both **Exercise.swift** and **Workout.swift** have corresponding test files but **DataModel.swift** does not. Let's start there.

Go to **File\New\File...** and select the **iOS\Source\Unit Test Case** template:  

![bordered bezel](/images/newUnitTestFile.png)

Create a class called **DataModelTests** as a subclass of **XCTest** and make sure **Swift** is selected. Then click **Next** and then **Create**.

As first order of business, add the following import at the top of **DataModelTests.swift**:

    import Workouts

Your app and your test bundle are in separate bundles so you have to import your app's module before writing any tests against `DataModel`. Next, replace the contents of the file with the following:

```swift
import XCTest
import Workouts

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
```

//There's a crash in the third and fourth unit tests that I think is related to NSCoding. 

Wait a minute...what's going on? After adding more unit tests, Xcode complains every time you reference `DataModel`. The problem lies with Swift access controls, covered next.

### A quick refresher on Swift access controls

Once you have a Swift entity (this can be a class, struct, enumeration, property, etc), its Swift access controls restrict other parts of your code from accessing it based on rules you set up in advance. 

The concept of access controls exists in virtually every programming language, although it may be called something different. In Swift, the access control model is based on the concept of **modules** and **source files**. 

A module is a single unit of code distribution. This can be an application or a framework. In this example, all the source code in the Workout app is one module and all the code in your testing bundle is a separate module.

Swift provides three different levels of access:

1. **Public access** enables access for entities in any source file from your own module as well as any source file any other module that `@imports` your module.
1. **Internal access** enables access for entities in any source file from your own module. Outside module never get access, even if they `@import` your module.
1. **Private access** restricts access to entities in your the defining source file. This is the most restrictive of all access controls levels.

> **Note**: This was a broad overview of Swift's access control model. If you're interested in learning more, you can read Apple's documentation on the subject: https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AccessControl.html  

The default access control is **internal**. Now, you see why your unit tests were riddled with errors? All the entities in **DataModel.swift** are internal to the Workout module. You cannot reference them from the unit testing module, even if you `@import` the Workouts module!

Before Xcode 7, you could get around this problem one of two ways:
1. Add every source file you want to test to your testing target.
1. Make every entity you want to test public.

Both options have serious downsides. You _can_ add every file you want to test to your testing target. If you were wondering, this is how `WorkoutTests` and `ExercisesTests` compile without errors. The downside is that doing this is a manual step that you can forget to do. It also doesn't make much sense conceptually. The testing module should only contain tests!

The second option, marking everything public, is even worse. If you have a large project that consists of several modules, there are probably parts of your code that shouldn't be exposed externally. Marking everything public for the sake of testability is asking for trouble.

Lucky for you, Swift 2.0 introduces a third option. Still in **DataModelTests.swift**, replace the `@import` statement you previously added with the following:

    @testable import Workouts

Magic! All your compiler errors disappear. The `@testable` modifier changes the way the default internal access control works. Normally you don't have visibility of internal entities from outside modules. With `@testable` you do.

> **Note**: `@testable` has no effect on the private access control. As they say in Vegas, what you declare `private` stays `private` :] 

// Run code coverage one more time here

## UI Testing

So far you've explored code coverage reports and `@testable` imports. These are great new features – they give you more information and make it easier to test but they don't really let you do anything you couldn't before. On the other hand, the third and last expansion to Xcode's testing capabilities lets you test your app in ways you didn't think possible. This expansion is of course...UI testing.

Before you can write your first UI test you have to make sure that your project has a UI testing target. This sample project doesn't, so you'll add one right now. In Xcode's menu, click on **File/New/Target**. You'll see this screen:

![bordered bezel](/images/addUITestTarget1.png)

Then, select the **iOS/Test** group on the left-hand column and click on **iOS UI Testing Bundle**.

![bordered bezel](/images/addUITestTarget2.png)

All the default values on this next screen should be correct for this simple sample project. However, if you're working on a project that consists of multiple modules, make sure that the **Target to be Tested** is set to your app's module. Finally, click on **Finish** to create the target. 

Voila! Doing this creates a new **WorkoutsUITests** group in Xcode along with a sample UI testing file called **WorkoutsUITests.swift**.

> **Note**: You'll only have to add a UI testing target if you upgrade an existing project from Xcode 6 or earlier. New projects created with Xcode 7 already come with this type of target. 

Let's jump right into your first test! This test is going to validate one important flow in the application: drilling down from the list of workouts into a particular workout's detail page. For this test, you'll use "Ray's Full Body Workout" as an example.

Open **WorkoutViewController.swift** and replace `viewDidLoad()` with the following:

```swift
override func viewDidLoad() {
  super.viewDidLoad()
  tableView.accessibilityIdentifier = "Workouts Table"
}
```

One of the ways the UI testing framework references individual UI components in your app is by their accessibility information. Setting this `UITableView`'s accessibility identifier to "Workouts Table" will let you reference this table by this same string later on.

> **Note**: If you want to add or improve your existing accessibility information you can do it via Interface Builder or the Accessibility API. Apple's recommended way is doing it via Interface Builder. `UITableView` doesn't have an accessibility panel in Interface Builder so that's why you did it in code. 

Head back to **WorkoutsUITests.swift**. Remove the `tearDown()` and `testExample()` methods and add the following method:

```swift
func testRaysFullBodyWorkout() {
    
  //1
  let app = XCUIApplication()
  let tableQuery = app.descendantsMatchingType(.Table)
  
  //2
  let workoutTable = tableQuery["Workouts Table"]
  let cellQuery = workoutTable.childrenMatchingType(.Cell)
  
  let identifier = "Ray's Full Body Workout"
  let workoutQuery = cellQuery.containingType(.StaticText, identifier: identifier)
  let workoutCell = workoutQuery.element
  workoutCell.tap()
  
  //3
  let navBarQuery = app.descendantsMatchingType(.NavigationBar)
  let navBar = navBarQuery[identifier]
 
  let buttonQuery = navBar.descendantsMatchingType(.Button)
  let backButton = buttonQuery["Workouts"]
  backButton.tap()
}
 ```
This test method is small but it contains classes and concepts you haven't encountered before. You'll read about them shortly. In the meantime, here's what the code does in broad terms:

1. First you get references to all the tables in the app
2. Then you find the workouts table using the "Workouts Table" accessibility identifier you added earlier. After that you simulate a tap on the cell that contains the static text "Ray's Full Body Workout".
3. Assume you're now in the workout detail screen. You then simulate a tap on the back button to go back to the list of workouts. The back button is in the navigation bar and currently says "Workouts".

> **Note**: Since this is your first UI test you wrote it in a very verbose way, detailing every step of the way. As it turns out, this test can be written more concisely. You'll get the chance to refactor it once you get more concepts under your belt.

Before going into the API more carefully, go ahead and run this test. To run `testRaysFullBodyWorkout()` in isolation, tap the diamond-shaped icon next to the method declaration:

![bordered bezel](/images/singleTest.png)

Tapping the diamond icon builds and launches the application. And then...the simulator does something you've probably never see it do before. It becomes possessed! Specifically, it simulates tapping into Ray's Full Body Workout and then tapping back. 

You may be thinking that this is not a real test since it has no assertions. If you've written regular `XCTest` tests before, you know that they rely on one or more assertion such as `XCTAssertTrue()`, `XCTAssertFalse()`, `XCTAssertEquals()` and so on.

Although you _can_ add assertions, you don't have to explicitly assert anything in a UI test. If the test expects to find a specific UI element on the screen (e.g. a button that says "Workouts") but doesn't, the test will fail. In other words, tapping around your app and going through your usual actions implicitly tests your UI.

There are three main classes involved in UI testing: `XCUIApplication`, `XCUIElement` and `XCUIElementQuery`. They're difficult to distinguish in `testRaysFullBodyWorkout()` because of Swift's type inference, but they're there! Here's a short description on what they do:

- `XCUIApplication` is a proxy for your application. You use it to launch and terminate the application as you start and end UI tests. Notice that the `setup()` method in **WorkoutsUITests.swift** launches the app. This means you're launching your `XCUIApplication` before every UI test in the file. `XCUIApplication` is also the root element in the element hierarchy visible to your test.
- `XCUIElement` is a proxy for UI elements in the application. Every `UIKit` class you can think of can be represented by a `XCUIElement`. How? `XCUIElement` can have a type (e.g. `.Cell`, `.Table`, `.WebView`, etc.) as well as an identifier. The identifier usually comes from the element's accessibility information such as its accessibility identifier, label or value. 
>What can you do with an `XCUIElement`? Anything you can think of. You can try tapping, double tapping, swiping in every direction. Just like a UI element, there's no guarantee the `XCUIElement` will respond to these actions, but you can sure try them!
- `XCUIElementQuery` queries a `XCUIElement` for sub-elements matching some criteria. The three most popular ways to query elements is with `descendantsMatchingType(_:)`, `childrenMatchingType(:_)` and `containingType(_:_:)`. 

> **Note**: Remember that `XCUIApplication` and `XCUIElement` are only proxies, not the actual objects. For example The type `XCUIElementType.Button` can either mean a `UIButton` or a `UIBarButtonItem` (which does not descend from `UIButton`) or it can be any other button-like entity!

Let's add one more step to the your current test. When you step into the workout detail page, you're also going to scroll down and tap the **Select & Workout** button. This will bring up an alert view, which your test will dismiss by tapping **OK**. Finally, you'll return to the workout list screen like before. While you're at it, you'll also refactor what the method you implemented previously. 

Go to `testRaysFullBodyWorkout()` and replace the implementation with the following:

```swift
func testRaysFullBodyWorkout() {
    
  let app = XCUIApplication()
    
  //1
  let identifier = "Ray's Full Body Workout"
    
  let workoutQuery =
  app.tables.cells.containingType(.StaticText, identifier: identifier)
    
  workoutQuery.element.tap()
    
  //2
  app.tables.buttons["Select & Workout"].tap()
  app.alerts.buttons["OK"].tap()
    
  //3
  app.buttons["Workouts"].tap()
}
```
Here's what changed in the code:
1. You didn't need to use the accessibility identifier "Workout Table" after all. Instead, you get _all_ tables in the app and then get all of their cells. Notice that you replaced `descendantsMatchingType(.Table)` with convenience method `tables` and `childrenMatchingType(.Cell)` with convenience method `cells`. 

>**Note**: The element query `descendantsMatchingType(_:)` is so common that Apple provided convenience methods for all the common types. `childrenMatchingType(_:)` doesn't have convenience methods but using `descendantsMatchingType(_:)` has the same effect in this case
1. This is the extra step you added to the test. Once in the workout detail screen, you tap on **Select & Workout**. Again, notice you don't need to specify which table you're talking about. You an drill down from the app to its tables to the table's buttons, then disambiguate using the button's title. You do the same with the alert's **OK** button except this time you go through the app's alerts instead of through the app's tables.
1. In the previous implementation of this test, you were first referencing the navigation bar to get to the its back button. Now you query the app's buttons and tap on the one identified by the string "Workouts."

Run `testRaysFullBodyWorkout()` one more time. The same sequence of events plays out, except this time you tap on **Select & Workout** and dismiss the alert view. When you try to come back to the list of workouts...splat. The test fails!

![bordered bezel](/images/testFailure.png)

//Note: It seems that screenshots are not implemented in beta 4. I want to look at those as I explain why it failed. I'll check again in the GM.

Let's figure out why the test failed. Xcode gives you the error message "UI Testing Failure - Multiple matches found". You can get this error when you're expecting one `XCUIElement` but instead get multiple.

Let's take a step back. You have three options when you want to go from a set of query results to single `XCUIElement`:

1. You can use **subscripting** if the element you want has a unique identifier. For example, `buttonsQuery["OK"]`.
1. You can use **indexing** if want an element at a particular index. For example, you can use `tables.cells.elementAtIndex(0)` to get the first cell in a table view.
1. If you're _sure_ a query resolves down to one element, you can use `XCUIElementQuery`'s **`element`** property.

If you use any of the three technique's shown above and end up with more than one `XCUIElement`, the test fails. Why's that? If you then want to tap or swipe on the element, the UI testing framework doesn't know which element you mean. In particular, `testRaysFullBodyWorkout()` failed because the line below resulted in two buttons:

    app.buttons["Workouts"].tap()

Can you find the duplicates? One is in the top left, next to the back button (this is the one you meant to tap). The second one is inside the "Workouts" tab on the bottom left of the screen:

![bordered bezel](/images/testFailure.png)

Whoops! Fix the test by replacing the faulty line with the following:

   app.navigationBars.buttons["Workouts"].tap()

You did need to go through the navigation bar after all! `navigationBars` is the convenience method for `descendantsMatchingType(.NavigationBar)`. 

Adding `navigationBars` between `app` and `buttons` makes it clear to the UI testing framework that you want the "Workouts" button located in a navigation bar. Re-run your UI test to verify that it passes now.

### UI recording

You spent a lot of time and effort writing and refactoring `testRaysFullBodyWorkout()`. Luckily, there is a simpler way to get the job done using UI recording. With UI recording, you can go ahead and "act out" what you want the test to be on the simulator and Xcode auto-magically translates your actions into UI testing code.

Let's see this in action. Delete the current implementation of `testRaysFullBodyWorkout()` and click the UI recording button:

![bordered bezel](/images/uiRecording.png)

The UI recording button builds and launches your app. Once that's done, "act out" the the steps of your tests. Tap on *Ray's Full Body Workout*, scroll down and tap *Select & Workout*. Finally, dismiss the alert view by tapping OK and tap the back button.

Your test method should look like so:

```swift
func testRaysFullBodyWorkout() {
    
  let app = XCUIApplication()
  app.tables["Workouts Table"].staticTexts["Ray's Full Body Workout"].tap()
    
  let tablesQuery = app.tables
  tablesQuery.staticTexts["Jumping Jacks"].tap()
  tablesQuery.buttons["Select & Workout"].tap()
  app.alerts["Woo Hoo! You worked out!"].collectionViews.buttons["OK"].tap()
  app.navigationBars["Ray's Full Body Workout"].buttons["Workouts"].tap()
}
```

Magic! Depending on where you swiped and what version of Xcode you're running, the generated code may be different from what you see in the chapter. You can run the generated test to verify that it simulates your steps one by one.

You'll notice that some of the generated lines of code have tokens that contain several options:

![bordered bezel](/images/uiRecordingTokens.png)

As you can tell, there are many ways of querying the same UI elements. With these tokens, Xcode gives you options to help you disambiguate elements in case there are duplicates. Once you're happy with a particular path, double click on the token to make it final.

> **Note**: Even if you write your tests manually, you can still use UI recording to find out what the testing framework "sees" as you tap around the simulator. This is a good alternative to using the system provided Accessibility inspectors. 

//I have two more tests to add. They're depending on the new designs so I'll hold off until I have the new designs to add them here. I can also make them challenge 1 & 2 if I run out of space

## Where to Go From Here?

You've seen how powerful and useful testing can be in Xcode 7. To summarize what you learned in this chapter, you started by exploring the new code coverage reports. Then, you dove into the new `@testable` feature in Swift 2.0. Finally, you finished the chapter off by exploring UI testing in `XCTest`.

There's one thing to keep in mind as you start writing UI tests. Although UI tests can be easier to write (especially if you're using UI recording), when they fail they are harder to debug than regular unit tests. Knowing _what_ to test is as important as having tests at all! Unfortunately, this is not a situation where one size fits all, but there are some guidelines you can follow. 

For example, you can write UI tests for mission critical flows in your application such as logging in, creating a new account, etc. If you're working on a document-based application you can also write tests for basic tasks such as opening, closing and saving a document.

If you ever find yourself fixing the same bug over and over, think back to this chapter! Check the code coverage for the files that contain the bug. If the code coverage is low or incomplete, consider writing more unit tests or even some UI tests that validate the feature.




