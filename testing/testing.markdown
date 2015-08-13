# Chapter X: What's New In Testing?

"How did this feature break _again_?" If you've been writing code for any length of time, you have probably asked yourself that question at least once. As any experienced programmer will tell you, writing code "right" the first time is difficult. And even _if_ you get it right the first time, as you add more code to your project you can accidentally introduce bugs in parts of your application that previously worked flawlessly.

Wouldn't it be great if you could add little "scaffolds" as you write code? These would prevent your code from failing after you've moved on to something else. At the very least they would tell you if something doesn't work anymore. The good news is you can. You can write tests!

Testing is a proven software engineering practice that helps make software robust and maintainable and it should be a part of every developer's toolkit. Today it's easy to add unit tests to an iOS project, but it wasn't always that way.

Over the past few years, Apple has made it easier to test iOS apps. Heres's a short recap of what's happened in the world of iOS testing since iOS 7:

- With Xcode 5, Apple introduced the first version of the **XCTest** framework, a more modern implementation of the previous SenTestingKit framework. This laid the groundwork for future features and better Xcode integration, including the Test Navigator.
- When Xcode 6 came out, Apple beefed up XCTest by adding asynchronous testing and performance testing.
- This year, Xcode 7 introduced code coverage reports and UI testing.

Before Xcode 7 you couldn't use XCTest to test your user interface or write functional tests, although you could have used third party libraries such as KIF, Frank, or Calabash to fill this gap. The problem is that these libraries weren't integrated into Xcode and you'd sometimes find yourself fighting an uphill battle.

This chapter focuses on the latest additions to XCTest. If you're interested in UI testing but don't know much about XCTest you should first read chapter 11 in _iOS 7 by Tutorials_, _"Unit Testing in Xcode 5"_ and chapter 29 in _iOS 8 by Tutorials_, _"What's New with Testing?"_.

Swift 2.0 also has an important feature related to testing that you'll read about in this chapter: the addition of `@testable` imports. This solves issues related to tests and access control that many developers faced with earlier versions of Swift. But enough preamble... are you ready to write some tests?

## Getting started

This chapter's sample project is a fitness app for iOS aptly named **Workouts**. Go to this chapter's files and find the **Workouts-Starter** project. Open **Workouts.xcodeproj** and then build and run the starter project.

![iphone bordered](/images/walkthrough0.png)

The app has two tabs: **Exercises** and **Workouts**. In the exercises tab, you can browse the list of built-in exercises (all-time favorites like push-ups and crunches) or create your own. In the workout tab, you can also browse the built-in workouts or create your own workout. A workout is simply a sequential list of exercises.

Take a minute to browse through the app. To 'perform' a workout, tap the **Workouts** tab and select a workout (for example, _Ray's Full Body Workout_). Next, in the workout detail screen scroll to the bottom and tap **Select and Perform**. Fortunately, for the purposes of this tutorial you don't actually need to perform any exercises! You'll simply see this congratulatory alert controller instead.

![bordered width=40%](/images/walkthrough1.png)

You can also try creating your own exercises and workouts by tapping **Add New Workout (+)** or **Add New Exercises** in their respective sections of the app.

Now head back to Xcode and take a look at the project's files in the project navigator. The starter project is organised into a number of groups. Here's a quick summary of the most important ones:

- **Model:** The project relies on two model objects, `Exercise` and `Workout`. Each holds the data it needs to display on the screen, such as a name, image file name, or its duration. Sets of exercises and workouts are stored within an instance of `DataModel`.

- **View Controllers**: `WorkoutViewController` shows you a list of all workouts, both built-in and user-created. When you tap on a specific workout, `WorkoutDetailViewController` displays the workout's information and allows you to perform the workout. `AddWorkoutViewController` lets you add a new workout to the list of workouts.

// TODO: Fix para formatting - deckle bug raised
Similarly, `ExerciseViewController` displays a list of all exercises in the app. From here you can add a new exercise or tap into an existing exercise, taking you to `ExerciseDetailViewController`.

- **WorkoutTests:** The sample app already includes some unit tests in its testing target. **Exercises.swift** and **WorkoutsTests.swift** contain unit tests for their corresponding model objects.

> **Note**: Even though the view controller source files are much longer than the model object source files, notice how they don't have any tests. This is a problem! That's a lot of UI code that has no test coverage. You'll learn how to measure and test this code later in the chapter. //TODO: Will you?

&nbsp;

## Code coverage

As you've just seen, the starter project already comes with some tests. However, how do you know if you have _enough_ tests and whether you're testing the right parts of your project? That's where code coverage comes in. New in Xcode 7, you can now get coverage reports to see how much code in any given file is 'exercised' by your tests. Let's try it out.

Code coverage doesn't come turned on by default. In the starter project, select **Product\Scheme\Edit Scheme...** . Then select the **Test** action and click on the **Code Coverage - Gather coverage data** checkbox.

![bordered width=85%](/images/codeCoverage2.png)

That's all you need to do to turn on code coverage reports. Easy, huh? To check your current levels of code coverage you have to run your test target. You'll be running your unit tests constantly in this chapter so let's do a quick refresher on how to do this. There are three ways to run the tests in your testing target:

1. Long click Xcode's **Run** button and click on **Test** from the drop down menu.
2. Select **Product\Test** from Xcode's menu.
3. Use the shortcut **Command+U**

Pick your favorite of the three and run your unit tests. Xcode will build and launch your app and your tests will run. In the **Test Navigator** you should see that there are 6 total tests:

![bordered width=50%](/images/testNavigator.png)

Let's focus on your code coverage report. Switch to the **Report Navigator** and click on the latest **Test** action.

![bordered width=50%](/images/reportNavigator-test1.png)

You're currently seeing the **Tests** view of the test report. This shows you a list of your unit tests along with their pass / failure status. From here, click on the **Coverage** tab to switch to the code coverage report:

![bordered width=65%](/images/reportNavigator1.png)

This report shows you the code coverage for your entire app as well as the code coverage on a per file basis. For example, the code coverage for the entire app is 35% (yikes!) whereas code coverage for **DataModel.swift** is 90%. 

You'll notice that the report won't show you the specific coverage percentage right away. If you want to know this number, hover your mouse over the progress indicator until it shows up. You can also get code coverage numbers for individual classes and methods. To do this, click on the disclosure indicator to the left of the file name to see its contents.

Xcode can even tell you the coverage of each line in a file. Hover on top of **Workout.swift** and click on the small right-facing arrow that appears next to its name:

![bordered width=20%](/images/codeCoverage2-5.png)

Doing this takes you to the file you clicked on in Xcode's main editor. Notice that there's a "gutter" on the right edge of the editor with small numbers on it:

![bordered width=70%](/images/codeCoverage3.png)

The number represents the number of times those lines of code are executed by tests. The getter for `workoutCount` has a 0 next to it because it isn't tested at all.

The level of granularity you get from Xcode's code coverage reports goes beyond the method level. As you can see, it will tell you which lines _inside_ a method are covered and which are not. This helps you identify edge cases you haven't tested. For instance, if you only test the `if` block in an `if-else` statement, Xcode will pick this up and let you know.

> **Note**: A single code coverage report is a snapshot in time. If you want to know whether your code coverage is improving or getting worse, you'll need to see how these numbers change over time. You can do this using Xcode server and Xcode bots. This won't be covered in this chapter but you can learn more about this in session 410 from WWDC 2015: _Continuous Integration and Code Coverage in Xcode_ (<http://apple.co/1J1n1Kd>).

## @testable imports and access control

As far as test coverage goes, 38% is not something to brag out. Let's improve that number by adding more tests. Both **Exercise.swift** and **Workout.swift** have corresponding test files but **DataModel.swift** does not. Let's start there.

In the project navigator, click the **WorkoutsTests** group. Choose **File\New\File...** and select the **iOS\Source\Unit Test Case Class** template.

Name the class **DataModelTests** and ensure it's a subclass of **XCTest** and that sure **Swift** is selected. Click **Next** and then **Create**.

As first order of business, add the following `import` at the top of **DataModelTests.swift**:

    import Workouts

Your app and your test bundle are in separate bundles so you have to import your app's module before writing any tests against `DataModel`. Next, delete the entire implementation for the `DataModelTests` class and replace it with the following:

```swift
class DataModelTests: XCTestCase {
  var dataModel: DataModel!

  override func setUp() {
    super.setUp()

    dataModel = DataModel()
  }

  func testSampleDataAdded() {
    XCTAssert(dataModel.allWorkouts.count > 0)
    XCTAssert(dataModel.allExercises.count > 0)
  }

  func testAllWorkoutsEqualsWorkoutsArray() {
    XCTAssertEqual(dataModel.workouts,
      dataModel.allWorkouts)
  }

  func testAllExercisesEqualsExercisesArray() {
    XCTAssertEqual(dataModel.exercises,
      dataModel.allExercises)
  }

  func testContainsUserCreatedWorkout() {
    XCTAssertFalse(dataModel.containsUserCreatedWorkout)

    let workout1 = Workout()
    dataModel.addWorkout(workout1)

    XCTAssertFalse(dataModel.containsUserCreatedWorkout)

    let workout2 = Workout()
    workout2.userCreated = true
    dataModel.addWorkout(workout2)

    XCTAssert(dataModel.containsUserCreatedWorkout)

    dataModel.removeWorkoutAtIndex(dataModel.allWorkouts.count - 1)
    XCTAssertFalse(dataModel.containsUserCreatedWorkout)
  }

  func testContainsUserCreatedExercise() {
    XCTAssertFalse(dataModel.containsUserCreatedExercise)

    let exercise1 = Exercise()
    dataModel.addExercise(exercise1)

    XCTAssertFalse(dataModel.containsUserCreatedExercise)

    let exercise2 = Exercise()
    exercise2.userCreated = true
    dataModel.addExercise(exercise2)

    XCTAssert(dataModel.containsUserCreatedExercise)

    dataModel.removeExerciseAtIndex(dataModel.allExercises.count - 1)
    XCTAssertFalse(dataModel.containsUserCreatedExercise)
  }
}
```

Uh oh... Errors ahoy! What's going on? After adding more unit tests, Xcode complains every time you reference `DataModel`. The problem is related to Swift access control, which you'll learn about next.

### A quick refresher on Swift access control

The concept of access control exists in virtually every programming language, although it may be called something different. Access control allows you to restrict access to sections of code from within other sections code. In Swift, the access control model is based on the concept of _modules_ and _source files_.

A _module_ is a single unit of code distribution. This can be an application or a framework. In this example, all the source code in the Workout app is one module and all the code in your testing bundle is a separate module. A _source file_ is a single Swift source code file within a module (for example **Workout.swift**).

Swift provides three different levels of access:

1. **Public access** enables access to entities in any source file from your own module as well as any source file any other module that `import`s your module.
2. **Internal access** enables access for entities in any source file from your own module. Outside module never get access, even if they `import` your module.
3. **Private access** restricts access to entities from anywhere other than the source file where they're defined. This is the most restrictive of all access controls levels.

> **Note**: This was a broad overview of Swift's access control model. If you're interested in learning more, you can read Apple's documentation on the subject: http://apple.co/1DH0v9y

The default access control is **internal**. Now do you see why your unit tests were riddled with errors? All the entities in **DataModel.swift** are internal to the **Workout** module. You cannot reference them from the unit testing module, even if you `import` the Workouts module!

### @testable imports

Before Xcode 7, you could get around this problem one of two ways:

1. Add every source file you want to test to your testing target as well as your main target. If you were wondering, this is how `WorkoutTests` and `ExercisesTests` currently compile without errors.
2. Make every entity you want to test `public`.

Both options have downsides. Adding files to both targets is a manual step that you can easily forget to do. It also doesn't make much sense conceptually. The testing module should only contain tests!

The second option, marking everything `public`, is even worse. If you have a large project that consists of several modules, there are probably parts of your code that shouldn't be exposed externally. Marking everything `public` for the sake of testability is asking for trouble.

Lucky for you, Swift 2.0 introduces a third option: `@testable`.

When you import a module, you can mark it as `@testable`, which changes the way that the default `internal` access control works. Normally you don't have visibility of internal entities from outside modules. With `@testable` you do! Here's how to implement it in the Workouts app. First, you'll need to remove `Workout` and `Exercise` from the tests target.

In Xcode, select **Workout.swift** in the project navigator. In the **File Inspector**, uncheck **WorkoutsTests** in the **Target Membership** section.

![bordered width=35%](images/testable1.png)

Do the same for **Exercise.swift**: click the file in the project navigator, and then uncheck **WorkoutsTests** in the **Target Membership** section of the **File Inspector**.

Now to use `@testable`. Open **DataModelTests.swift**, replace the `import Workouts` line at the top of the file with the following:

    @testable import Workouts

Do the same with the `import` statement at the top of **WorkoutTests.swift** and **ExerciseTests.swift**.

Magic! All your compiler errors disappear. Run your tests again to check that they all pass.

> **Note**: `@testable` has no effect on the private access control. As they say in Vegas, what you declare `private` stays `private` :]

Once the tests have finished, head back to the code coverage report: in the **Report navigator**, select the most recent **Test** run, and then click **Coverage** in the main panel. Check out the coverage % for **DataModel.swift**: 100%! Nice work.

## UI testing

So far you've explored code coverage reports and `@testable` imports. These are great new features – they give you more information and definitely make it easier to test your apps.

The third and last addition to Xcode's testing capabilities lets you test your app in ways you didn't think possible: through _UI testing_.

Before you can write your first UI test you have to make sure that your project has a UI testing target. The sample project doesn't, so you'll add one right now. In Xcode's menu, click on **File\New\Target...**. Choose the **iOS\Test\iOS UI Testing Bundle** template and click **Next**.

![bordered bezel](/images/addUITestTarget1.png)

All the default values on the next screen should be correct for this simple sample project. However, if you're working on a project that consists of multiple modules, make sure that the **Target to be Tested** is set to your app's module. Finally, click on **Finish** to create the target.

![bordered bezel](/images/addUITestTarget2.png)

Voila! Doing this creates a new **WorkoutsUITests** group in Xcode along with a sample UI testing file called **WorkoutsUITests.swift**.

> **Note**: You'll only have to add a UI testing target if you upgrade an existing project from Xcode 6 or earlier. New projects created with Xcode 7 already come with a UI testing target by default.

Let's jump right into your first test! This test is going to validate one important flow in the application: drilling down from the list of workouts into a particular workout's detail page. For this test, you'll use _"Ray's Full Body Workout"_ as an example.

As a first step, open **WorkoutViewController.swift** and replace `viewDidLoad()` with the following:

```swift
override func viewDidLoad() {
  super.viewDidLoad()
  tableView.accessibilityIdentifier = "Workouts Table"
}
```

One of the ways the UI testing framework references individual UI components in your app is by their accessibility information. Setting this `UITableView`'s accessibility identifier to "Workouts Table" will let use the string as a reference to the table later on.

> **Note**: If you want to add or improve your existing accessibility information you can either do it via Interface Builder or the Accessibility API. Apple's recommended way is doing it via Interface Builder. However, `UITableView` doesn't have an accessibility panel in Interface Builder so that's why you did it in code.

Head over to **WorkoutsUITests.swift**. Remove the `tearDown()` and `testExample()` methods and add the following method:

```swift
func testRaysFullBodyWorkout() {
  let app = XCUIApplication()
  // 1
  let tableQuery = app.descendantsMatchingType(.Table)

  // 2
  let workoutTable = tableQuery["Workouts Table"]
  let cellQuery = workoutTable.childrenMatchingType(.Cell)

  let identifier = "Ray's Full Body Workout"
  let workoutQuery = cellQuery.containingType(.StaticText, identifier: identifier)
  let workoutCell = workoutQuery.element
  workoutCell.tap()

  // 3
  let navBarQuery = app.descendantsMatchingType(.NavigationBar)
  let navBar = navBarQuery[identifier]

  let buttonQuery = navBar.descendantsMatchingType(.Button)
  let backButton = buttonQuery["Workouts"]
  backButton.tap()
}
 ```
This test method is fairly small but it contains classes and concepts you haven't encountered before. You'll read about them shortly. In the meantime, here's what the code does in broad terms:

1. First you get references to all of the tables in the app.
2. Then you find the Workouts table using the "Workouts Table" accessibility identifier you added earlier. After that you simulate a tap on the cell that contains the static text "Ray's Full Body Workout".
3. You then simulate a tap on the back button to go back to the list of workouts. The back button is in the navigation bar and currently says "Workouts".

> **Note**: This test is written in a very verbose way. As it turns out, this test can be written much more concisely. You'll get the chance to refactor it shortly once you get more concepts under your belt.

Go ahead and run this test. To run it in isolation, tap the diamond-shaped icon next to the method declaration:

![bordered width=70%](/images/singleTest.png)

Once the app has built and launched, the simulator does something you've probably never see it do before. It becomes possessed! Specifically, it simulates tapping into Ray's Full Body Workout and then tapping the back button.

You may be thinking that this is not a real test since it has no assertions. If you've written regular XCTest tests before, you know that they rely on one or more assertion such as `XCTAssertTrue`, `XCTAssertFalse` or `XCTAssertEquals`.

Although you _can_ add assertions, you don't have to explicitly assert anything in a UI test. If the test expects to find a specific UI element on the screen (for example a button that says "Workouts") but doesn't, the test will fail. In other words, tapping through your app _implicitly_ tests your UI.

There are three main classes involved in UI testing: `XCUIApplication`, `XCUIElement` and `XCUIElementQuery`. They're difficult to distinguish in `testRaysFullBodyWorkout()` because of Swift's type inference, but they're there! Here's a short description on what they do:

- `XCUIApplication` is a _proxy_ for your application. You use it to launch and terminate the application as you start and end UI tests. Notice that `setup()` in **WorkoutsUITests.swift** launches the app. This means you're launching your `XCUIApplication` before every UI test in the file. `XCUIApplication` is also the root element in the element hierarchy visible to your test.
- `XCUIElement` is a proxy for UI elements in the application. Every `UIKit` class you can think of can be represented by a `XCUIElement` in the context of a UI test. How? `XCUIElement` can have a type (e.g. `.Cell`, `.Table`, `.WebView`, etc.) as well as an identifier. The identifier usually comes from the element's accessibility information such as its accessibility identifier, label or value.

  What can you do with an `XCUIElement`? Pretty much anything you can think of. You can tap, double tap, and swipe in every direction. You can also type text into elements like text fields.
- `XCUIElementQuery` queries a `XCUIElement` for sub-elements matching some criteria. The three most popular ways to query elements is with `descendantsMatchingType(_:)`, `childrenMatchingType(:_)` and `containingType(_:_:)`.

> **Note**: Remember that `XCUIApplication` and `XCUIElement` are only _proxies_, not the actual objects. For example the type `XCUIElementType.Button` can either mean a `UIButton` or a `UIBarButtonItem` (which does not descend from `UIButton`) or it can be any other button-like entity!

Let's add one more step to the your current test. When the test steps into the workout detail page, it's also going to scroll down and tap the **Select & Workout** button. This brings up an alert controller, so your test will dismiss by tapping **OK**. Finally, it'll return to the workout list screen like before. You'll also refactor what the test to make it more concise.

In **WorkoutsUITests.swift**, go to `testRaysFullBodyWorkout()` and replace the entire method with the following:

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

That's a lot shorter than what it was before! Here's what changed in the code:

1. You didn't need to use the accessibility identifier "Workout Table" after all. Instead, you get _all_ tables in the app and then get all of their cells. Notice that you replaced `descendantsMatchingType(.Table)` with convenience method `tables` and `childrenMatchingType(.Cell)` with convenience method `cells`.
> **Note**: The element query `descendantsMatchingType(_:)` is so common that Apple provided convenience methods for all the common types. `childrenMatchingType(_:)` doesn't have convenience methods but using `descendantsMatchingType(_:)` has the same effect in this case
2. This is the extra step for this test. Once in the workout detail screen, the test taps on **Select & Workout**. Again, notice you don't need to specify _which_ table you're talking about. You can drill down from the app to its tables to the tables' buttons, then disambiguate using the button's title. You do the same with the alert's **OK** button except this time you go through the all of app's alerts instead of through all of the app's tables.
3. In the previous implementation of this test, you were first referencing the navigation bar to get to its back button. Now you directly query the app's buttons and tap on the one identified by the string "Workouts."

Run `testRaysFullBodyWorkout()` one more time. The same sequence of events plays out, except this time the test taps on **Select & Workout** and dismisses the alert controller. However, when it tries to return to the list of workouts... splat! The test fails.
![bordered width=70%](/images/testFailure.png)

[NOTE FOR AUTHOR: Debug screenshots are now implemented as of beta 5. However, I'm not sure if you're going to have much room to explain this!]

Let's figure out why the test failed. Xcode gives you the error message **"UI Testing Failure - Multiple matches found"**. You get this error when you're expecting one `XCUIElement` but instead get multiple.

How do you fix this? You have three options when you want to drill down from a set of query results to single `XCUIElement`:

1. You can use **subscripting** if the element you want has a unique identifier. For example, `buttonsQuery["OK"]`.
2. You can use **indexing** if the element you want is located at a particular index. For example, you can use `tables.cells.elementAtIndex(0)` to get the first cell in a table view.
3. If you're _sure_ a query resolves down to one element, you can use `XCUIElementQuery`'s **`element`** property.

If you use any of the three techniques shown above and end up with more than one `XCUIElement`, the test fails. This is because the UI testing framework has no way of knowing which element you actually want to interact with. In our case, `testRaysFullBodyWorkout()` failed because the query in the final line of the test resulted in two buttons:

    app.buttons["Workouts"]

Can you find the duplicates? One is in the top left, next to the back button (this is the one you meant the test to tap). The second one is inside the "Workouts" tab at the bottom left of the screen:

![bordered iphone](/images/duplicates.png)
[TODO: Update after design process. If necessary, crop together an image showing just the navigation bar and the tab bar to save space]

Whoops! Fix the test by replacing the final line of `testRaysFullBodyWorkout()` with the following:

    app.navigationBars.buttons["Workouts"].tap()

`navigationBars` is the convenience method for `descendantsMatchingType(.NavigationBar)`. Adding `navigationBars` between `app` and `buttons` makes it clear to the UI testing framework that you want the "Workouts" button located in a navigation bar. Re-run your UI test to verify that it passes now.

### UI recording

You spent a lot of time and effort writing and refactoring `testRaysFullBodyWorkout()`. It's great to know how to write UI tests from scratch, but there is an easier way to get the job done: _UI recording_. With UI recording, you can simply "act out" the steps of your test in the simulator and Xcode will auto-magically translate your actions into UI testing code.

Let's see this in action. Delete the current contents of `testRaysFullBodyWorkout()`. Place your cursor inside the empty method, then click the **Record UI Test** button at the bottom of the editor:

![bordered width=55%](/images/uiRecording.png)

The UI recording button builds and launches your app. Once that's done, "act out" the the steps of your tests. Tap on **Ray's Full Body Workout**, then scroll down and tap **Select & Workout**. Dismiss the alert controller by tapping **OK** and finally tap the **back** button. Tap the **record** button again, or the **stop** button to stop recording.

Your generated test method should look something like this:

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

Magic! Depending on exactly where you swiped and which version of Xcode you're running, the generated code may be a bit different from what you see above chapter. Run the generated test to verify that it simulates your steps one by one.

You'll notice that some of the generated lines of code have 'tokens' that contain several options. Click one to see the available options:

![bordered width=90%](/images/uiRecordingTokens.png)

There are many ways of querying the same UI elements, and in some cases Xcode can only make guesses about the steps you want your test to take. With these tokens, Xcode gives you options to help you disambiguate elements. Once you're happy with a particular path, double click on the token to make it final.

> **Note**: Even if you write your tests manually, you can still use UI recording to find out what the testing framework "sees" as you tap around the simulator. This is a good alternative to using the system provided Accessibility Inspectors.

[TODO FOR AUTHOR: Adding final tests. Looking at the samples, it seems that these are to show using an XCTAssert in a UI test. Both tests look fairly similar, so I'd recommend only including one here if you have space? Or make the second a challenge?]

[TODO: Fit me in somewhere:]
So UI tests are pretty neat, huh? There are a couple of things to keep in mind as you start writing them. Although UI tests _can_ be easier to write (especially if you're using UI recording), when they fail they can be harder to debug than regular unit tests. They can also be quite 'brittle'; if you make changes to your UI, you may need to update a lot of tests.

Finally, knowing _what_ to test is as important as having tests at all! Unfortunately, this is not a situation where one size fits all, but there are some guidelines you can follow. For example, you can write UI tests for mission critical flows in your application such as logging in or creating a new account. If you're working on a document-based application you can also write tests for basic tasks such as opening, closing and saving a document.

## Where to go from here?

You've seen how powerful and useful testing can be in Xcode 7. You've explored code coverage reports, taken a look at Swift 2.0's new `@testable` modifier, and you've written and recorded UI tests. As always, you can check out the final project for this chapter to see how everything came together.

If you ever find yourself fixing the same bug over and over, think back to this chapter! Check the code coverage for the files that contain the bug. If the code coverage is low or incomplete, consider writing more unit tests or even some UI tests that validate the feature.

There are a couple of WWDC sessions from 2015 that are worth looking at to find out more about the topics covered in this chapter:

- Session 406 - UI Testing in XCode: <http://apple.co/1N1Eg0I>
- Session 410 - Continuous Integration and Code Coverage in Xcode: <http://apple.co/1J1n1Kd>

You can also read _Chapter 29, What’s New with Testing_ in our _iOS 8 by Tutorials_ book, and the _Unit Testing in Xcode 5_ chapter in _iOS 7 by Tutorials_.
