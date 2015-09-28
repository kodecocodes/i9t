```metadata
author: Chris Wagner
number: 2
title: Introducing App Search
```

# Tutorial: Introducing App Search

There's been a big hole in Spotlight on iOS for a long time. Although users can use it to find you app, they can't see _inside_ it — to all the content that they really care about. Currently, when users want to get to content in an app, they have to flip through pages on their home screen to find it, open it and then search for what they're looking for — assuming you actually implemented a search feature in the first place!

An especially savvy user could launch your app by using Siri or searching for it in Spotlight, but neither of these tools help the user find what they want inside a non-Apple app. Meanwhile, Apple makes things like contacts, notes, messages, email and apps directly searchable within Spotlight. The user simply taps on the search result and goes straight to the content. No fair!

Sometimes it seems like Apple keeps all the fun features to itself, like using Spotlight. The good news is that after Apple developers finish playing around with a feature and feel it's ready for showtime, it often lets the masses play too, like it did with app extensions in iOS 8.

With iOS 9, Apple is passing a very exciting feature off to the rest of us; third party developers now have the ability to make _their_ content searchable through Spotlight!

## App search APIs

App search in iOS 9 comprises three main aspects. Each is broken into separate APIs that achieve distinct results, but they also work in concert with one another:

-	NSUserActivity
-	Core Spotlight
-	Web markup

### NSUserActivity

Being a clever little feature, this aspect of app search makes use of the same `NSUserActivity` API that enables Handoff in iOS 8.

In iOS 9, `NSUserActivity` has been augmented with some new properties to enable search. Theoretically speaking, if a task can be represented as an `NSUserActivity` to be handed off to a _different_ device, it can be stored in a search index and later continued on the _same_ device. This enables you to index activities, states and navigation points within your app, allowing the user to find them later via Spotlight.

For example, a travel app might index hotels the user has viewed, or a news app might index the topics the user browsed.

> **Note**: This tutorial will not specifically cover Handoff, but you’ll learn how to make content searchable once it’s viewed.

### Core Spotlight

The second, and perhaps most "conventional" aspect of app search is Core Spotlight, which is what the stock iOS apps like Mail and Notes use to index content. While it's nice to allow users to search for previously accessed content, you might take it a step further by making a large set of content searchable in one go.

You can think of Core Spotlight as a database for search information. It provides you with fine-grained control of what, when and how content is added to the search index. You can index all kinds of content, from files to videos to messages and beyond, as well as updating and removing search index entries.

Core Spotlight is the best way to provide full search capabilities of your app's private content.

This tutorial will focus on what is required to get Spotlight results by using `NSUserActivity` described above. The full version of this tutorial in iOS 9 by Tutorials shows how to fully index your content by using Core Spotlight.

### Web markup

The third aspect of app search is web markup, which is tailored towards apps that mirror their public content from a web site. A good example is Amazon, where you can search the millions of products it sells, or even raywenderlich.com. Using open standards for marking up web content, you can show it in Spotlight and Safari search results and even create deep links within your app.

This tutorial will not cover web markup, but you can learn all about it in Chapter 3, "Your App On The Web" of iOS 9 by Tutorials.


## Getting started

You'll work with a sample app named _Colleagues_ that simulates a company address book. It provides an alternative to adding every coworker to your contacts, instead providing you with a directory of your colleagues. To keep things simple, it uses a local dataset, comprising of a folder of avatar images and a JSON file that contains employee information. In the real world, you would have a networking component that fetches contact data from a web-service. This is a tutorial, so JSON it is. Open the starter project, and before you do anything, build and run the app.

![height=35%](/images/app-preview.png)

You'll immediately see a list of employees. It's a small startup, so there's only 25 staff. Select **Brent Reid** from the list to see all of his details. You'll also see a list of employees who are in the same department. And that is the extent of the app's features — it's very simple!

Search would make this app infinitely better. As it stands, you can't even search while you're _in_ the app. You won't add in-app search, but instead add the ability to search from _outside_ the app with Spotlight!

### Sample project

Take a moment to familiarize yourself with the project's codebase. There are two targets: **Colleagues** which is the app itself, and **EmployeeKit** which is a framework to facilitate interactions with the employee database.

From the **EmployeeKit** group in Xcode, open **Employee.swift**. This is the model for an employee that has all the properties you might expect. Employee instances are initialized using a JSON model, which are stored under the **Database** group in a file named **employees.json**.


Moving on, open **EmployeeService.swift**. At the top of the file is an extension declaration, and there is a method named `destroyEmployeeIndexing()` marked with `TODO`. You'll fill out this method's implementation later. This method will destroy any indexing that has occurred.

There's more to the EmployeeKit target, but it's not related to app searches, so there's no need to go into it now. By all means though, feel free to poke around!

Open **AppDelegate.swift** in the **Colleagues** group. Notice there is only one method in here: `application(_:didFinishLaunchingWithOptions:)`. This implementation checks if `Setting.searchIndexingPreference` is set to `.Disabled`, if so it will destroy any search indexing that has occurred.

You don't need to do anything other than just be aware of this setting. You can change the setting in the iOS system **Settings** app under **"Colleagues"**.

That concludes your tour. The rest of the code is view controller logic that you'll modify, but you don't need to know all of it to work with app search.

## Searching previously viewed records

When implementing app search, `NSUserActivity` is the first thing to work with because:
1.	It's dead simple. Creating an `NSUserActivity` instance is as easy as setting a few properties.
2.	When you use `NSUserActivity` to flag user activities, iOS will rank that content so that search results prioritize frequently accessed content.
3.	You're one step closer to providing Handoff support.

Time to prove how simple `NSUserActivity` can be to implement!

### Implement `NSUserActivity`

With the **EmployeeKit group** selected, go to **File \ New \ File...**. Choose the **iOS \ Source \ Swift File** template and click **Next**. Name your new file **EmployeeSearch.swift** and verify that the target is set to **EmployeeKit**.

Within the new file, first import `CoreSpotlight`:

    import CoreSpotlight

Next, still in **EmployeeSearch.swift**, add the following extension to the `Employee` struct:

```swift
extension Employee {
  public static let domainIdentifier = "com.raywenderlich.colleagues.employee"
}
```

This reverse-DNS formatted string identifies the type of `NSUserActivity` created for employees. Next, add the following computed property below the `domainIdentifier` declaration:

```swift
public var userActivityUserInfo: [NSObject: AnyObject] {
  return ["id": objectId]
}
```

This dictionary will serve as an attribute for your `NSUserActivity` to identify the activity. Now add another computed property named `userActivity`:

```swift
public var userActivity: NSUserActivity {
  let activity = NSUserActivity(activityType: Employee.domainIdentifier)
  activity.title = name
  activity.userInfo = userActivityUserInfo
  activity.keywords = [email, department]
  return activity
}
```


This property will come into play later to conveniently obtain an `NSUserActivity` instance for an employee. It creates new `NSUserActivity` and sets a few properties:
- `activityType`: The type of activity that this represents. You'll use this later to identify `NSUserActivity` instances that iOS provides to you. Apple suggests using reverse DNS formatted strings.
- `title`: The name of the activity — this will also appear as the primary name in a search result.
- `userInfo`: A dictionary of values for you to use however you wish. When the activity is passed to your app, such as when the user taps a search result in Spotlight, you'll receive this dictionary. You'll use it to store the unique employee ID, allowing you to display the correct record when the app starts.
- `keywords`: A set of localized keywords that help the user find the record when searching.

Next up, you are going to use this new `userActivity` property to make employee records searchable when the user views them. Since you added these definitions in the EmployeeKit framework, you'll need to build the framework so that Xcode is aware they can be used from the Colleagues app.

Press **Command-B** to build the project.

Open **EmployeeViewController.swift** and add the following to the bottom of `viewDidLoad()`:

```swift
let activity = employee.userActivity

switch Setting.searchIndexingPreference {
case .Disabled:
  activity.eligibleForSearch = false
case .ViewedRecords:
  activity.eligibleForSearch = true
}

userActivity = activity
```

This retrieves `userActivity` — the property you just created in the `Employee` extension. Then it checks the app's search setting.
- If search is disabled, you mark the activity as ineligible for search.
- If the search setting is set to `ViewedRecords`, then you mark the activity as eligible for search.
- Finally, you set the view controller's `userActivity` property to your employee's activity.

> **NOTE**: The `userActivity` property on the view controller is inherited from `UIResponder`. It's one of those things Apple added with iOS 8 to enable Handoff.

The last step is to override updateUserActivityState(). This ensures that when a search result is selected you'll have the information necessary.

Add the following method after `viewDidLoad()`:

```swift
override func updateUserActivityState(activity: NSUserActivity) {
  activity.addUserInfoEntriesFromDictionary(
    employee.userActivityUserInfo)
}
```

During the lifecycle of `UIResponder`, the system calls this method at various times and you're responsible for keeping the activity up to date. In this case, you simply provide the `employee.userActivityUserInfo` dictionary that contains the employee's `objectId`.

Great! Now when you pull up an employee, that bit of history will be tracked and become searchable, provided the setting is turned on.

In the simulator or on your device, open the **Settings** app and scroll down to **Colleagues**. Change the **Indexing** setting to **Viewed Records**.

![width=35%](/images/app-screen-3.png)

Now, build and run the app and select **Brent Reid**.

Okay, so it doesn't look like anything spectacular happened, but behind the scenes, Brent's activity is being added to the search index. Exit to the home screen (⇧⌘H) and bring up Spotlight by either swiping down from the middle of the screen or swiping all the way to the left of your home screen pages. Type **brent reid** into the search.

![width=35%](/images/app-screen-4.png)

And there's Brent Reid! If you don't see him, you may need to scroll past other results. And if you tap on it, it should move up the list next time you perform the same search.

![height=30%](/images/whoa-meme.jpg)

Now, of course this is _awesome_, but the result is a little...bland.

Surely you can do more than give a name? Time to crack open the **Core Spotlight** framework and discover how.

### Adding more information to search results

`NSUserActivity` has a property named `contentAttributeSet`. It is of the type `CSSearchableItemAttributeSet`, which allows you to describe your content with as many attributes as necessary. Review the `CSSearchableItemAttributeSet` class reference to see the many ways to describe your content with these attributes.

Below is the desired result, complete with each component's property name called out:

![width=100%](/images/properties-diagram-1.png)

You've already set `title` on `NSUserActivity`, and at the moment it's all you see. The other three, `thumbnailData`, `supportsPhoneCall` and `contentDescription` are all properties of `CSSearchableItemAttributeSet`.

Open **EmployeeSearch.swift**. At the top, import `MobileCoreServices`:

    import MobileCoreServices

`MobileCoreServices` is required for a special identifier that you'll use to create the `CSSearchableItemAttributeSet` instance. You've already imported `CoreSpotlight`, which is required for all of the APIs prefixed with `CS`.

Still in **EmployeeSearch.swift**, add a new computed property named `attributeSet` to the `Employee` extension:

```swift
public var attributeSet: CSSearchableItemAttributeSet {
  let attributeSet = CSSearchableItemAttributeSet(
    itemContentType: kUTTypeContact as String)
  attributeSet.title = name
  attributeSet.contentDescription = "\(department), \(title)\n\(phone)"
  attributeSet.thumbnailData = UIImageJPEGRepresentation(
    loadPicture(), 0.9)
  attributeSet.supportsPhoneCall = true

  attributeSet.phoneNumbers = [phone]
  attributeSet.emailAddresses = [email]
  attributeSet.keywords = skills

  return attributeSet
}
```

When initializing `CSSearchableItemAttributeSet`, an `itemContentType` parameter is required. You then pass in `kUTTypeContact` from the `MobileCoreServices` framework. (Read about these types on Apple's [UTType Reference](http://apple.co/1NilqiZ) (http://apple.co/1NilqiZ) page.)

The attribute set contains the relevant search metadata for the current employee: `title` is the same as the title from `NSUserActivity`, `contentDescription` contains the employee's department, title and phone number, and `thumbnailData` is the result of `loadPicture()` converted to `NSData`.

To get the call button to appear, you must set `supportsPhoneCall` to `true` and provide a set of `phoneNumbers`. Finally, you add the employee's email addresses and set their various skills as keywords.

Now that these details are included, Core Spotlight will index each and pull the results during a search. This means that your users can now search for coworkers by name, department, title, phone number email and even skills!

Still in **EmployeeSearch.swift**, add the following line above the `return` in `userActivity`:

    activity.contentAttributeSet = attributeSet

Here you tell the `contentAttributeSet` from `NSUserActivity` to use this information.

Build and run. Open **Brent Reid's** record so the index can do its thing. Now go to the home screen pull up Spotlight and search for "brent reid". If your previous search is still there, you'll need to clear it and search again.

![width=35%](/images/app-screen-5.png)

Voila! Aren't you amazed with how little code it took to pull this off?

Great work! Now Spotlight can search for colleagues the user previously viewed. Unfortunately, there is one glaring omission...try opening the app from the search result. Nothing.

### Opening search results

The ideal user experience is to launch the app directly to the relevant content without any fanfare. In fact — it's a requirement — Apple uses the speed at which your app launches and displays useful information as one of the metrics to rank search results.

In the previous section, you laid the groundwork for this by providing both an `activityType` and a `userInfo` object for your `NSUserActivity` instances.

Open **AppDelegate.swift** and add this empty implementation of  `application(_:continueUserActivity:restorationHandler:)` below `application(_:didFinishLaunchingWithOptions:)`:

```swift
func application(application: UIApplication,
  continueUserActivity userActivity: NSUserActivity,
  restorationHandler: ([AnyObject]?) -> Void) -> Bool {

  return true
}
```

When a user selects a search result, this method is called — it's the same method that's called by Handoff to continue an activity from another device.

Add the following logic above `return true` in `application(_:continueUserActivity:restorationHandler:)`:

```swift
guard userActivity.activityType == Employee.domainIdentifier,
  let objectId = userActivity.userInfo?["id"] as? String else {
    return false
}
```

This `guard` statement verifies the `activityType` is what you defined as an activity for Employees, and then it attempts to extract the `id` from `userInfo`. If either of these fail, then the method returns `false`, letting the system know that the activity was not handled.

Next, below the `guard` statement, replace `return true` with the following:

```swift
if let nav = window?.rootViewController as? UINavigationController,
  listVC = nav.viewControllers.first as? EmployeeListViewController,
  employee = EmployeeService().employeeWithObjectId(objectId) {
    nav.popToRootViewControllerAnimated(false)

    let employeeViewController = listVC
      .storyboard?
      .instantiateViewControllerWithIdentifier("EmployeeView") as!
        EmployeeViewController

    employeeViewController.employee = employee
    nav.pushViewController(employeeViewController, animated: false)
    return true
}

return false
```

If the `id` is obtained, your objective is to display the `EmployeeViewController` for the matching Employee.

The code above may appear a bit confusing, but think about the app's design. There are two view controllers, one is the list of employees and the other shows employee details. The above code pops the application's navigation stack back to the list and then pushes to the specific employee's details view.

If for some reason the view cannot be presented, the method returns `false`.

Okay, time to build and run! Select **Cary Iowa** from the employees list, and then go to the home screen. Activate Spotlight and search for **Brent Reid**. When the search result appears, tap it. The app will open and you'll see it fade delightfully from Cary to Brent. Excellent work!

### Deleting items from the search index

Back to the premise of your app. Imagine that an employee was fired for duct taping the boss to the wall after a particularly rough day. Obviously, you won't contact that person anymore, so you need to remove him and anybody else that leaves the company from the Colleagues search index.

For this sample app, you'll simply delete the entire index when the app's indexing setting is disabled.

Open **EmployeeService.swift** and add the following import statement at the top of the file.

```swift
import CoreSpotlight
```

Next, find `destroyEmployeeIndexing()`. Replace the `TODO` with the following logic:

```swift
CSSearchableIndex
  .defaultSearchableIndex()
  .deleteAllSearchableItemsWithCompletionHandler { error in
  if let error = error {
    print("Error deleting searching employee items: \(error)")
  } else {
    print("Employees indexing deleted.")
  }
}
```

This single parameterless call destroys the entire indexed database for your app. Well played!

Now to test out the logic; perform the following test to see if index deletion works as intended:
1.	Build and run to install the app.
2.	Stop the process in Xcode.
3.	In the simulator or on your device, go to **Settings \ Colleagues** and set **Indexing** to **Viewed Records**.
4.	Open the app again and select a few employees so that they are indexed.
5.	Go back to the home screen and activate Spotlight.
6.	Search for one of the employees you viewed and verify the entry appears.
7.	Go to **Settings \ Colleagues** and set **Indexing** to **Disabled**.
8.	Quit the app.
9.	Reopen the app. This will purge the search index.
10. Go to the home screen and activate Spotlight.
11. Search for one of the employees you viewed and verify that *no* results appear for the Colleagues app.

So deleting the entire search index was pretty easy, huh? But what if you want to single out a specific item? Good news — these two APIs give you more fine-tuned control over what is deleted:
- `deleteSearchableItemsWithDomainIdentifiers(_:completionHandler:)` lets you delete entire "groups" of indexes based on their domain identifiers.
- `deleteSearchableItemsWithIdentifiers(_:completionHandler:)` allows you work with individual records using their unique identifiers.

This means that globally unique identifiers (within an app group) are _required_ if you're indexing multiple types of records.

> **Note**: If you can't guarantee uniqueness across types, like when replicating a database that uses auto-incrementing IDs, then a simple solution could be to prefix the record's ID with its type. For example, if you had a contact object with an ID of 123 and an order object with an ID of 123, you could set their unique identifiers to **contact.123** and **order.123** respectively.

## Where to go from here?

This tutorial has covered iOS 9's simple yet powerful approach to indexing the content inside your app using user activities. Searching isn't limited to _content_ though — you can also use it to index navigation points within an app.

Consider a CRM app that has multiple sections such as _Contacts_, _Orders_ and _Tasks_. By creating user activities whenever a user lands on one of these screens, you'd make it possible for them to search for _Orders_ and be directly to that section of your app. How powerful would this be if your app has many levels of navigation?

There are many unique ways to bubble up content to your users. Think outside the box and remember to educate your users about this powerful function.

This tutorial was an abbreviated version of Chapter 2, "Introducing App Search" from iOS 9 by Tutorials. If you'd like to learn about indexing large data sets with Core Spotlight or web content with iOS 9 please check out the book!
