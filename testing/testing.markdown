# Chapter X: What's New In Testing?

One of the most useful things you can do as a software developer is test your code. Testing is a proven software engineering practice that makes software robust and maintainable. Testing your code has many benefits: when you want to change the behavior of your app, either to modify an existing feature or to add a new one, the tests that you previously put in place can tell you if something breaks unintentionally.

Over the past few years, Apple has made it easier to test your iOS apps. Heres's a recap of what's happened in the world of iOS testing since iOS 7:
- In Xcode 5/iOS 7, Apple introduced the first version of the XCTest framework. This framework allows developers to write unit tests without third party libraries.
- In Xcode 6/iOS 8, Apple beefed up XCTest by adding asynchronous testing as well as performance tests.
- This year, with Xcode 7 and iOS 9, Apple introduced code coverage reports and UI testing.

Before this release of Xcode and iOS, developers couldn't test their UI using XCTest. There were some popular third party libraries that you may have heard of to fill in this need: these open source third party libraries included KIF, Subliminal and Calabash.

This chapter builds on previous additions to XCTest that focus on code coverage and UI testing. If you don't know much about XCTest but are interested in UI testing, we recommend you read Chapter 11 in iOS 7 by Tutorials, "Unit Testing in Xcode 5" as well as Chapter 29 in iOS 8 by Tutorials, "What's New with Testing?".

Swift 2.0 also has an important feature related to testing that you'll read about in this chapter — the addition of @testable imports, which solves issues with testing and access control developers previously had. Are you ready to write some tests?

## Introducng the RW workout app

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

- Model: The project relies on two main model objects, Exercise.swift and Workout.swift. An exercise model object holds its name, the name of its image file, instructions to perform the exercise and its duration. The duration of an exercise is determined at exercise creation and it's readonly after that. An exercise also keep track of whether it is a build-in exercise or if it was created by the user. This will be important later on.

Similarly, a workout model object also holds its name and whether it is a built-in workout or if it was created by the user. It also holds an array of its exercises as well as the total duration of the workout - a sum of the duration of each exercise plus an optional rest interval between exercises. 

If a user creates an exercise or a workout, it's saved to disk do the user doesn't lose data between app launches. Both Exercise and Workout conform to NSCoding to persist user data on disk. DataModel helps store and retrieve information from disk. It also helps answer queries such as "give me all exercises" or "give me all workouts"

- WorkoutTests: The sample app already includes some tests in its testing target. Exercises.swift and WorkoutsTests.swift contain unit tests for their respective model objects. DataModelTests.swift is supposed to test DataModel...but if you take a closer look you'll see that the file doesn't include any unit tests.

- View Controllers: WorkoutViewController.swift, WorkoutDetailViewController.swift and AddWorkoutViewController.swift all do what their name suggests. WorkoutViewController shows you a list of all workouts, both built-in and user-created. When you tap on a specific workout, WorkoutDetailViewController displays the workouts information as well as lets you perform the exercise. AddWorkoutViewController lets you add a new workout to the list of workouts.

Similarly, ExerciseViewController displays a list of all exercises in the app. From here you can add a new exercise or tap into an existing exercise, taking you to ExerciseDetailViewController. 

> **Note**: Even though the view controller source files are much longer than the model object source files, notice how they don't have any tests. This is a problem! That's a lot of UI code that has no test coverage. You'll learn how to measure and test this code in this chapter.

## Code Coverage

So your sample project comes with tests, but how do you know if you're have enough tests and that you're testing the right stuff? That's where code coverage comes in. New in Xcode 7, you can now get coverage reports to see what is tested and what isn't. Let's try it out.

Code coverage doesn't come turned on by default. Click on the Workouts scheme and select Edit Scheme...

![bordered bezel](/images/codeCoverage1.png)

Then select the Test action and click on the Code Coverage/Gather coverage data checkbox.

![bordered bezel](/images/codeCoverage2.png)

That's all you need to do to turn on code coverage reports. Let's see what the code coverage currently is by running the unit tests. If you're been writing XCTest unit tests for a while this may be second nature to you. On the other hand, if this is your first time running unit tests, you'll be glad to know that there are no less than three ways to run the tests in your testing target:

- Long click the Run button and click on Test from the drop down menu.
- In Xcode's menu, select Product/Test
- Use the shortcut Command+U

Pick your favorite method and run your unit tests. Xcode will build your app, launch it in the simulator or a device depending on where you're building to, and your tests will run. In the Test Navigator you should see that there are 8 total tests, with one failing (whoops!):

![bordered bezel](/images/testNavigator.png)

Don't worry about the failing test. You'll fix it in a few moments. For now let's focus on your coverage report. Switch to the Report Navigator and click on the latest Test action.


![bordered bezel](/images/reportNavigator1.png)

You're currently viewing the Test view of the test report. This shows you a list of your unit tests along with a report of the passes and failures. From here, click on the Coverage view (circled above) to switch to the code coverage report:

![bordered bezel](/images/reportNavigator2.png)

This report shows you the code coverage for your entire app as well as the code coverage per file. For example, the code coverage for the entire app is 38% (yikes!) whereas code coverage for DataModel.swift is 93%.

You'll notice that the report won't show you the specific coverage percentage. If you want to this number, simply hover your mouse over the progress indicator until it shows up. You can also get code coverage numbers for individual classes. Simply click on the disclosure indicator to the left of the class name to drill down to individual methods.

If you've ever shipped a bug to the App Store you'll instantly realize that this information is extremely valuable. However, stop for a minute and ask yourself what exactly it means to have 93% coverage.

Xcode can tell you this as well. Hover on top of Workout.swift and click on the right arrow that appears next to it:

![bordered bezel](/images/reportNavigator2.png)

Doing this takes you to the class you clicked on in Xcode's main editor. Notice that there's a " gutter" on the right edge of the editor with little numbers on it, such as 0, 2, 6. The number represents the number of times those lines of code are covered by tests. For example, the getter for workoutCount isn't covered at all so there's a 0 next to it.   

The level of granularity you get from Xcode's code coverage reports goes beyond the method level. As you can see, it will tell you which lines within a method are covered and which are not. This is helpful to help you identify edge cases you haven't tests. For instance, if you only test the if block in an if-else statement, Xcode will pick this up and let you know.

> **Note**: A single code coverage report is a snapshot of a particular point in time. If you want to know if you're code coverage is improving or getting worse over time you'll need to see how these numbers change over time. You can achieve this with Xcode server and Xcode bots, but won't be covered in this chapter.

### Improving unit testing access control with @testable

As far as test coverage goes, 38% is not something to brag out. Let's improve that by adding some more tests. As far as model classes go, both Exercise.swift and Workout.swift have test files but DataModel.swift does not. Let's start there.

Select the WorkoutTests group and click on File/New/File... to create a new file. 

![bordered bezel](/images/newUnitTestFile.png)

With the iOS/Source group selected on the left hand side, select Unit Test Case Class. Name your new file DataModelTests, click Next and then Create. As first order of business, add the following import at the top of DataModelTests.swift:

    import Workouts

Your app is in a different module than your tests so you have to import your app's module before writing any tests against DataModel. Next, replace the contents of the file with the following:

//Add DataModelTests here

Wait a minute...what's going on? After pasting your unit tests, Xcode complains in every place you reference the class DataModel. The problem has to do with Swift access controls, covered next.

#### A quick refresher on Swift access controls

Swift access controls restrict access to parts of your code from other files and Swift modules. If you can write Objective-C, you'll remember that everything that you put in your .m implementation file was "private" and if you wanted to make it "public" to other classes you had to public the method declaration in the header file.

> **Note**: Actually, everything in Objective-C was always public. Even if you didn't publish a property or a method in the header file, you were still able to send a message to the class and the class would run it if it was implemented. 

Swift works in a similar way, except that the Swift access control model is based on the concept of modules and source files. A module is a single unit of code distribution, an application or a framework. For example, all the source code in the Workout app is a module and all the code in your testing target is another module.

Swift provides three different access level for entities within your code:

- Public access enables entities from any source file from your own module as well as any source file from another module that @imports your module.
- Internal access enables entities to be used within any source file from your own module, but not in any source file outside your module (even if they @import your module).
- Private access restricts the use of an entity to its own defining source file. This is the most restrictive of all access controls.

> **Note**: You just read a very broad overview of Swift's access control model. As always, there are many caveats to keep in mind. You can read about Swift's access control model in Apple's documentation: https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AccessControl.html  

The default access control is internal. You see why your unit tests were riddled with errors? All the entities in DataModel.swift are internal to the Workout module. When you try to reference them in the unit testing module, it's as if they didn't exist.

In the past, you had two options to get around this problem:
- Add every file you want to test to your testing target.
- Make every entity you want to test public.

Both options have serious downsides. You can add every file you want to test to your testing target, but this is a manual step that you can forget to do. It also doesn't make much sense conceptually. The testing module should only contain tests!

The second option, marking everything public, is even worse. If you have a large project that consists of several modules, there are probably parts of your code that shouldn't be used externally. Marking everything public for the sake of testability is asking for trouble.

Lucky for you, Swift 2.0 introduces a third option. Still in DataModelTests.swift, replace the import statement you previously added with the folllwing:

    @testable import Workouts

Magic! All your problems go away simply by adding @testable in front of your import statement. The @testable modifier changes the way the internal access control works. Normally you don't have visibility of internal entities from outside modules. With @testable you do.

> **Note**: @testable has no effect on the private access control. What is private remains private to the defining source file. 

// Run code coverage one more time here

## UI Testing

So far you've explored code coverage reports and @testable imports. There's one more expansion to Xcode's testing capabilities to explore, and it's a big one: UI testing.

Before you can start writing UI tests in Xcode you first have to add a UI testing target. Click on File/New/Target to add the new target. With the iOS/Test group selected on the left-hand column, click on iOS UI Testing Bundle:

![bordered bezel](/images/addUITestTarget1.png)

All the default values on the next screen are correct. If you have multiple modules in your project, make sure that the Target to be Tested is set to your app:

![bordered bezel](/images/addUITestTarget2.png)

Voila! Doing this creates a new WorkoutsUITests group in Xcode with a sample UI testing file called WorkoutsUITests.

> **Note**: If you create a new project with Xcode 7, you'll already have a UI testing target. On the other hand, if you're upgrading an existing project from Xcode 6 or earlier you will have to add a UI testing target as you just did.

Let's jump right into your first test. Your first test is going to validate the number of exercises in a particular workout. For example, in the Workouts list screen it says that Ray's Full Body Workout consists of 10 separate exercises. You can verify in the Workout details screen if there are 10 exercises listed under "EXERCISES".

The first step is to get a reference to the list of workouts. The UI testing framework gets its information from Accessibility. If the workout list cannot be unique identified by Accessibility it means you won't be able to reference it in your test. Let's fix this first.

Open WorkoutViewController.swift and add replace viewDidLoad() with the following:

```swift
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.accessibilityIdentifier = "Workouts Table"
  }
```

Doing this tags the UITableView in the workout list view controller with a string identifier of "Workouts Table".

> **Note**: Apple's preferred method of improving accessibility information is by using Interface Builder. UITableView doesn't have an accessibility panel in Interface Builder so that's why you did it in code. 

Head back to WorkoutsUITests.swift. Remove the tearDown() and testExample() methods and add the following one:

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
There method you just added is small but it contains several new concepts that you'll learn about shortly. In the meantime, here's what the code does in broad terms:

- First you get all the application's tables
- Then you find the workouts table using the "Workouts Table" accessibility identifier you added earlier. Then you get a hold of the cell you want to tap on using it's text, "Ray's Full Body Workout". Finally you call tap() on the cell to simulate a tap
- Assuming the transition completed successfully, you now get a reference to the navigation bar that corresponds to the workout you just tapped on. You do this by also using the text that was on the cell, which is now on the navigation bar.
- Finally, you identify the back button (which currently says "Workouts") and tap on it to go back.

> **Note**: Since this is your first UI test you wrote it in a very verbose way, detailing every step of the way. As it turns out, your test can be written more concisely. You'll get the chance to refactor it once you get a few more concepts under your belt.

Before going into the API more carefully, go ahead and run this test. To run testRaysFullBodyWorkout() in isolation, tap the diamond-shaped icon next to the method declaration:

![bordered bezel](/images/singleTest.png)

Tapping the diamond icon builds and launches the application. And then...the simulator does something you've probably never see it do before. It becomes possessed! Specifically, it simulates tapping into Ray's Full Body Workout and then tapping back. 

> **Note**: You may be thinking that this is not a real test since it has no assertions. Regular XCTest unit tests always rely on one or more assertion macros such as XCTAssertTrue, XCTAssertFalse, XCTAssertEquals and so on.

Although you can, you don't have to assert anything explicitly in an UI test. If the test cannot find a particular element on the screen that it was expecting, it's considered a failure. Therefore simply tapping around and going through your usual actions implicitly tests your UI.

There are three main classes involved in UI testing: XCUIApplication, XCUIElement and XCUIElementQuery. They're difficult to distinguish in testRaysFullBodyWorkout() because of Swift's type inference, but they're there! 

- XCUIApplication is a proxy for your application. You use it to launch your application to start a test using its launch() method. The setup() method in your test file contains a call to launch(), which launches the app every time a new UI test is about to run. XCUIApplication is also the root of the element hierarchy that you can test.
- XCUIElement is a proxy for UI elements in the application. XCUIElement can have a type (e.g. Cell, Table, WebView, etc.) as well as an identifier. The identifier usually comes from the element's accessibility information such as its accessibility identifier, label or value. What can you do with a XCUIElement? Anything you can think of. You can try tapping, double tapping, swiping in every direction. 
- XCUIElementQuery resolves to collections of accessible elements. The three most popular ways to query elements is with descendantsMatchingType(_:), childrenMatchingType(:_) and containingType(_:_:).

> **Note**: Remember that XCUIApplication and XCUIElement are only proxies, not the actual objects by a different names. For example The type XCUIElementType.Button can either mean a UIButton or a UIBarButtonItem (which does not descend from UIButton) or it can be any other button-like entity!

Let's add one more step to the your current test. When you step into the workout detail page, you're also going to scroll down and tap on the "Select & Workout" button. This will bring up an alert view, which your test will dismiss by tapping "OK". Finally, you'll return to the workout list screen like before.

While you're at it, you'll also refactor what the method you implemented previously. Go to testRaysFullBodyWorkout() and replace the implementation with the following:

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
- You didn't need the workout list table accessibility identifier. You could have gone straight to the app's tables and then to their cells. Notice that you essentially replaced descendantsMatchingType(.Table) with tables and childrenMatchingType(.Cell) with cells. 

The most commonly used query is descendantsMatchingType(_:) so Apple provided convenience methods for all the common types. childrenMatchingType(_:) doesn't have convenience methods but using descendantsMatchingType(_:) has the same effect in this case
- This is the extra step you added to the test. Once in the workout detail screen, tap the "Select & Workout" button. Again notice you don't need to specify which table you're talking about. You an go directly from the app to its tables to its buttons, then disambiguate using the button's title. You do the same with the alert's "OK" button except this time you go through the app's alerts instead of through the app's tables.
- Before, to get to the back button you were going trough the navigation bar. Now you simply query all the app's buttons and tap on the one identified by the string "Workouts."

Run the test testRaysFullBodyWorkout() one more time. The same sequence of events plays out, except this time you tap on "Select & Workout" and dismiss the alert view. When you try to come back to the list of workouts...splat. The test fails!

![bordered bezel](/images/testFailure.png)

//Note: It seems that screenshots are not implemented in beta 4. Once they are I want to look at those as I explain why it failed.

Let's figure out why the test failed. The error message is "UI Testing Failure - Multiple matches found:". You have three options when you want to go from a set of query results to an individual XCUIElement:

- You can use subscripting if you have a  unique identifier. For example, buttons["OK"].
- You can use indexing if want an element at a particular index. For example in a table view you can use, tables.cells.elementAtIndex(?) to get the first cell.
- If you're sure the query returns only one element, you can use XCUIElementQuery's  element property.

If you use any of the three technique's above and end up with more than one XCUIElement, the test fails. Your test failed because the line below resulted in two buttons:

    app.buttons["Workouts"].tap()

One is in the top left, next to the back button (this is the one you meant to tap). The second one is inside the "Workouts" tab down below:

![bordered bezel](/images/testFailure.png)

Fix the test by replacing the faulty line with the following:

   app.navigationBars.buttons["Workouts"].tap()

Adding navigationBars between app and buttons makes it clear to the UI testing framework that you want the "Workouts" button located in a navigation bar. Re-run your UI test to verify that it passes now.

### UI recording, a Skynet product

You spent a lot of time and effort writing and refactoring testRaysFullBodyWorkout(). The good news is that there is a simpler way to get the job done using UI recording. With UI recording, all you have to do is turn it on and interact with the simulator. Xcode will auto-magically translate your actions into UI testing code.

Let's see this in code. Delete the current implementation inside testRaysFullBodyWorkout() and click the UI recording button:

![bordered bezel](/images/uiRecording.png)

Clicking the UI recording button will build your app one more time and launch the simulator. Now follow the steps of your tests. Tap on Ray's Full Body Workout, scroll down and tap on Select & Workout. Finally, dismiss the alert view by tapping OK and hit the back button.

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

Magic! Depending on where you swiped and what version of Xcode you're running, the generated code may be different from what you see in the chapter. You can run the test again to verify that it simultes your steps one by one.

Some of the generated lines of code have tokens that contain several options:

![bordered bezel](/images/uiRecordingTokens.png)

As you can tell, there are many ways of querying the same objects. With these tokens, Xcode is giving you options to help you disambiguate elements in case there are duplicates. Once you're happy with one path, double click on the token to make it final.

> **Note**: Even if you write your tests manually, one of the most useful things about UI recording is that it lets you see what the system is "seeing" as you tap around the simulator. This is a good alternative to using the system provided Accessibility inspectors. 

//I have two more tests to add. They're depending on the new designs so I'll hold off until I have the new designs to add them here. I can also make them challenge 1 & 2 if I run out of space

When you're writing UI tests, there's one thing to keep in mind. Although UI tests are easier to write if you're using UI recording, once they fail they are harder to debug than regular unit tests. Knowing what to test is as important as having tests :]

## Where to Go From Here?

You've seen how powerful and useful testing can be in Xcode 7. To summarize what you learned in this chapter, you started by exploring the new code coverage reports. Then, you dove into the new @testable feature in Swift 2.0. Finally, you finished the chapter off by exploring UI testing in XCTest.

Going through the testing features, as you have done in the chapter, is the easy part. What's difficult is figuring out what to test! I'm sure you, like every other developer, would prefer to spend your time shipping features rather than writing tests. Unfortunately, there is no easy answer but there are some guidelines you can follow. You can write UI tests for mission critical flows in your application such as logging in, creating a new account, etc. If you're working on a document-based application you can also write tests for doing basic tasks such as opening a document, closing a document and saving a document.

If you ever find yourself fixing the same bug over and over, think back to this chapter! Check the code coverage levels for the class that keeps causing you heartburn. If it's low or incomplete, consider writing some regular unit tests or even some UI tests that validate the feature.




