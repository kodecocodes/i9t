# Chapter 2: Introducing App Search

There's been a big hole in app searches for a long time. Currently, when users want to get to content in an app, they have to flip through pages on their home screen to find it, open it and then search for what they're looking for – if you even implemented a search feature, that is! 

An especially savvy user could launch your app by using Siri or searching for it in Spotlight, but neither of these tools help the user find what they want inside a non-Apple app. Meanwhile, Apple makes things like contacts, notes, messages, email and apps directly searchable within Spotlight. The user simply taps on the search result and goes straight to the content. No fair!

Sometimes it seems like Apple keeps all the fun features to itself, like using Spotlight and Siri. The good news is that after Apple developers finish playing around with a feature and feel it's ready for showtime, it often lets the masses play too, like it did with app extensions in iOS 8. 

With iOS 9, Apple is passing a very exciting feature off to the rest of us; third party developers now have the ability to make _their_ content searchable through Spotlight! This also means that users can search within your app with Siri. Not only that, but you also get to make Siri context-aware. By simply saying, "Remind me to log my hours when I get home", users can create a reminder that links to a specific piece of content they were viewing within _your_ app. When the reminder pops up, they can jump straight back into what they were doing. 

With iOS 9, you don't have to leave 20 tabs open in Safari and hope that you get back to them later. Create a reminder, close the tab and get on with your life!

[TODO: Fact check this with GM on a device, as of beta 5 it only creates a reminder with the activity's title, no link.]

## App search APIs

App search in iOS 9 comprises three main aspects. Each is broken into separate APIs that achieve distinct results, but they also work in concert with on another: 

-	NSUserActivity
-	Core Spotlight
-	Web markup

### NSUserActivity

Being a clever little feature, this aspect of app search makes use of the same `NSUserActivity` API that enables handoff in iOS 8.

Just in case you don’t know, Handoff allows a user to start an activity on one device and pick it up on another. For example, imagine you're reading an email on your iPhone as you sit down at your Mac. A special Mail icon on your Mac's Dock will appear, allowing you to launch Mail and resume reading that same email on your Mac. This is powered by `NSUserActivity`, which provides the OS with the information necessary to resume a task on another device. It’s not voodoo – this is enabled by a dance between iCloud, Bluetooth and Wi-Fi.

In iOS 9, `NSUserActivity` has been given a few new properties to enable search. Theoretically speaking, if a task can be represented as an `NSUserActivity` to be handed off, it makes sense for that task to be searchable and continued on the _same_ device. It enables you to index activities, states and navigation points within your app so the user can find them later via Spotlight. 

For example, a travel app might index hotels the user has viewed, or a news app might index sections the user just browsed, such as politics or sports.

> **Note**: This chapter will not specifically cover Handoff, but you’ll learn how to make content searchable once it’s viewed.

### Core Spotlight

The second, and perhaps most "conventional" aspect of app search is Core Spotlight, which is what the stock iOS apps like Mail and Notes use to index content. While it's nice to allow users to search for previously accessed content, you might take it a step further by making a large set of content searchable in one go. 

Core Spotlight is sort of like a database for search information. With this new power, you have fine-grain control of what, when and how content is added to the search index. You can also update and remove items and index all kinds of content, from files to videos to messages and beyond.

Core Spotlight is the best way to provide full search capabilities of your app's content, including content that is private to the user. You'll learn how to use the new Core Spotlight APIs to index all of the content of an app.

### Web markup

The third aspect of app search is web markup, which is tailored towards apps that mirror their public content from a web site. A good example is Amazon, where you can search the millions of products it sells, or even RayWenderlich.com. Using open standards for marking up web content, you can show it in Spotlight and Safari search results and even create deep links within your app. 

This chapter will not cover web markup, but you can find that information in Chapter 3, "Your App On The Web". 

[TODO: Chapter 3 reference]

## Getting started

You'll work with a sample app named _Colleagues_ that simulates a company address book. It provides an alternative to adding every coworker to your contacts because the app provides a directory of your colleagues. To keep things simple, it uses a local set of data, including a folder of avatar images and a JSON file that contains employee information. In the real world, you would probably have a networking component that fetches contact data from true web-service. But this is a tutorial, so JSON it is. Open the starter project, and before you do anything, build and run the app.

![height=35%](/images/app-preview.png)

[TODO: Update after design process]

You'll immediately see a list of employees. It's a small startup, so there's only 25 staff. Select **Brent Reid** from the list to see all of his details. You'll also see a list of employees who are in the same department. And that is the extent of the app's features – it's very simple!

Search  would make this app infinitely better. As it stands, you can't even search while you're _in_ the app. You won't add search, but you'll add the ability to search from outside the app with Spotlight!

### Sample project

Take a moment to familiarize yourself with the project's codebase. There are two targets: **Colleagues** which is the app itself, and **EmployeeKit** which is a framework to facilitate interactions with the employee database.

From the **EmployeeKit** group in Xcode, open **Employee.swift**. This is the model for an employee that has all the properties you might expect. Employee instances are initialized using a JSON model, which are stored under the **Database** group in a file named **employees.json**.


Moving on, open **EmployeeService.swift**. At the top of the file is an extension declaration, and there are two methods marked with `TODO`. You'll fill out these two method's implementation later. This service provides two documented public APIs: 
- `employeeWithObjectId()`: provides an `Employee` given its `objectId`
- `fetchEmployees()`: returns all employee records from the database.

There's more to the EmployeeKit target, but it's not related to app searches, so there's no need to go into it now. By all means though, feel free to poke around!

Open **AppDelegate.swift** in the **Colleagues** group. Notice there is only one method in here: `application(_:didFinishLaunchingWithOptions:)`. This implementation switches on `Setting.searchIndexingPreference`, which allows the user to change the behavior of search indexing.

Notice that the setting's value changes which method is called. If you recall, these are the service methods that had `TODO` comments to mark things you'll do later. You don't need to do anything other than just be aware of this setting. By the way, you can change the setting in the iOS system **Settings** app under **"Colleagues"**.

That concludes your tour. The rest of the code is view controller logic that you'll modify, but you don't need to know all of it to work with app search.

## Searching previously viewed records

When implementing app search, `NSUserActivity` is the first thing to work with because:
1.	It's dead simple. Creating an `NSUserActivity` instance is as easy as setting a few properties.
2.	When you use `NSUserActivity` to flag user activities, iOS will rank that content so that search results reflect content that is accessed frequently.
3.	You get the benefit of providing context to Siri. [TODO: Determine if this has notable benefits in GM]
4.	You're one step closer to providing Handoff support.

Time to prove how simple `NSUserActivity` can be to implement!

### Implement `NSUserActivity`

With the **EmployeeKit group** selected, go to **File \ New \ File...**. Choose the **iOS \ Source \ Swift File** template and click **Next**. Name your new file **EmployeeSearch.swift** and verify that the target is set to **EmployeeKit**.

Within the new file, first import `CoreSpotlight`:
    
    import CoreSpotlight

Your code doesn't need this yet but it will later. 

Next, still in **EmployeeSearch.swift**, add the following extension to the `Employee` struct:


```swift
extension Employee {
  public static let domainIdentifier = "com.raywenderlich.colleagues.employee"
}
```

This identifier identifies the type of `NSUserActivity` created for employees. Next, add the following computed property below the `domainIdentifier` declaration:

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


This property will come into play later to conveniently obtain an `NSUserActivity` instance for an employee, and it set a few properties:
- `activityType`: The type of activity that this is. You'll use this later to identify `NSUserActivity` instances that iOS provides to you. Reverse DNS is the format Apple suggests using.
- `title`: The name of the activity – this will also appear as the primary name in a search result.
- `userInfo`: A dictionary of values for you to populate how you wish. When the activity passes back to your app, like after the user taps a search result in Spotlight, you'll receive this dictionary back to assist you with presenting the right information to the user. You'll use it to open the app to a specific employee record.
- `keywords`: A set of localized keywords that help the user find the record when searching.

Now you have an `NSUserActivity` property to make employee records searchable when the user views them. Since you added these definitions in the EmployeeKit framework, you'll need to build the project to see them from the app target. 

Press **Command-B** to build the project.

[Author TODO: do we need a screencap here? No room?]

Open **EmployeeViewController.swift** and add the following to the bottom of `viewDidLoad()`:

```swift
let activity = employee.userActivity

switch Setting.searchIndexingPreference {
case .Disabled:
  activity.eligibleForSearch = false
case .ViewedRecords:
  activity.eligibleForSearch = true
  activity.contentAttributeSet?.relatedUniqueIdentifier = nil
case .AllRecords:
  activity.eligibleForSearch = true
}

userActivity = activity
```

This retrieves `userActivity` – the property you just created in the `Employee` extension. Then it checks the app's search setting.
- If search is disabled, you mark the activity as ineligible for search.
- If the search setting is set to `ViewedRecords`, then you mark the activity as eligible for search, but also set `relatedUniqueIdentifier` to `nil`; if you don't have a corresponding Core Spotlight index item, then this must be `nil`. You'll give it a value when you perform a full index of the app's contents.  
- If the search setting is `AllRecords`, you mark the activity as eligible for search.
- Finally, you set the view controller's `userActivity` property to your employee's activity.

> **NOTE**: The `userActivity` property on the view controller is inherited from `UIResponder`. It's one of those things Apple added with iOS 8 to enable Handoff.

The last step ensures that when a search result is selected, you'll have the information necessary is to override `updateUserActivityState()`. 

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

[NOTE: As of beta 5, there seems to be a simulator bug where occasionally the contents of the Colleagues settings screen disappears until you force quit and reopen the Settings app. Check this on GM.]

![width=35%](/images/app-screen-3.png)

Now, build and run the app and select **Brent Reid**.

Okay, so it doesn't look like anything spectacular, but behind the scenes, your search is being indexed. Exit to the home screen and bring up Spotlight by either swiping down from the middle of the screen or swiping all the way to the left of your home screen pages. Type **brent reid** into the search.

![width=35%](/images/app-screen-4.png)

And there's Brent Reid! If you don't see him, you may need to scroll past other results. And if you tap on it, it should move up the list next time you perform the same search.

![height=30%](/images/whoa-meme.jpg)

Now, of course this is _awesome_, but the result is a little...bland. 

Surely, you can do more than give a name, and if you crack open the `CoreSpotlight` framework you can. 

### Adding more information to search results

`NSUserActivity` has a property named `contentAttributeSet`. It is of the type `CSSearchableItemAttributeSet`, which allows you to describe your content with as many attributes as necessary. Review the `CSSearchableItemAttributeSet` class reference to see the many ways to describe your content with these attributes. 

Below is the desired result, complete with each component's property name called out:

![width=100%](/images/properties-diagram-1.png)

You've already set `title` on `NSUserActivity`, and at the moment it's all you see. The other three, `thumbnailData`, `supportsPhoneCall` and `contentDescription` are all properties of `CSSearchableItemAttributeSet`. 

Next up: Create an instance of `CSSearchableItemAttributeSet`.

Open **EmployeeSearch.swift**. At the top, import MobileCoreServices`:

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

When initializing `CSSearchableItemAttributeSet`, a `itemContentType` parameter is required. You then pass in `kUTTypeContact` from the `MobileCoreServices` framework. (Read about these types on Apple's [UTType Reference](http://apple.co/1NilqiZ) (http://apple.co/1NilqiZ) page.)

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

The ideal user experience is to launch the app directly to the relevant content without any fanfare. By the way, Apple uses the speed at which your app launches and displays useful information as one of the metrics to rank search results.

In the previous section, you laid the groundwork for this by providing both an `activityType` and a `userInfo` object for your `NSUserActivity` instances.

Open **AppDelegate.swift** and add this empty implementation of  `application(_:continueUserActivity:restorationHandler:)` below `application(_:didFinishLaunchingWithOptions:)`:

```swift
func application(application: UIApplication,
  continueUserActivity userActivity: NSUserActivity,
  restorationHandler: ([AnyObject]?) -> Void) -> Bool {

  return true
}
```

When a user selects a search result, this method is called – it's the same method that's called by Handoff to continue an activity from another device.

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

The code above may appear a bit confusing, but think about that app's design. There are two view controllers, one is the list of employees and the other shows employee details. The above code pops the application's navigation stack back to the list and then pushes to the specific employee's details view.

If for some reason the view cannot be presented, the method returns `false`.

Okay, time to build and run! Select **Cary Iowa** from the employees list, and then go to the home screen. Activate Spotlight and search for **Brent Reid**. When the search result appears, tap it. The app will open and you'll see it flash from Cary to Brent. Excellent work!

## Indexing with Core Spotlight

Now that previously viewed records are indexed, you're close to indexing the entire database. 

Why didn't you do this first? Well, `NSUserActivity` is generally an easy first step to make content searchable. Many apps don't have sets of content that can be indexed with Core Spotlight, but _all_ apps have activities. Also, user activity affects what shows up in the list, so it's an easy way to put your app in the "spotlight".

Say that an employee shares a name with a famous actress. The user will likely see the actress's IMDB page as the first result the first time she searches. However, if she frequently visits that employee's record in Colleagues, it's likely that iOS will rank that result higher than IMDB for her. 

It's not a hard-set rule to implement `NSUserActivity` first; it's simply an easy point of entry. There's no reason why you couldn't implement Core Spotlight indexing first. 

Start by opening **EmployeeSearch.swift** and add the following line to `attributeSet`, right above the return statement:

    attributeSet.relatedUniqueIdentifier = objectId

This assignment creates a relationship between your `NSUserActivity` and what will soon be a `CSSearchableItem` you'll insert into the Core Spotlight index. If you don't relate the two records, there will be duplicate search results. You may remember you set this property to `nil` on your `NSUserActivity` when the app is in _Viewed Records_ mode.

Next, you need to create the `CSSearchableItem`, which is required to index directly with Core Spotlight. Add the following computed property definition to **EmployeeSearch.swift**, below `attributeSet`:

```swift
var searchableItem: CSSearchableItem {
  let item = CSSearchableItem(uniqueIdentifier: objectId,
    domainIdentifier: Employee.domainIdentifier,
    attributeSet: attributeSet)
  return item
}
```

This is brief because you already made the `CSSearchableItemAttributeSet` to hold most of the metadata. Notice that `uniqueIdentifier` is set to `objectId` to build the inverse relationship with your `NSUserActivity`.

Open **EmployeeService.swift** and import CoreSpotlight at the top of the file:

    import CoreSpotlight

Now, within `indexAllEmployees()` replace the `TODO` comment with the following:
```swift
// 1
let employees = fetchEmployees()
//2                
let searchableItems = employees.map { $0.searchableItem } 
CSSearchableIndex
  .defaultSearchableIndex()
//3
  .indexSearchableItems(searchableItems) { error in       
//4
  if let error = error {                                  
    print("Error indexing employees: \(error)")
  } else {
    print("Employees indexed.")
  }
}
```

Stepping through the logic...
1.	All employees are fetched from the database as an array of `Employee`.
2.	The employee array is mapped to `[CSSearchableItem]`.
3.	Using Core Spotlight's default index, the array of `CSSearchableItem`s is indexed.
4.	Finally, log a message on success or failure.

And...that's it! Now when you launch the app with the option **All Records** set for the app's Indexing setting, all employee records become searchable. 

Head over to the **Settings** app, and change the **Indexing** setting for Colleagues to **All Records**. Then build and run. In Spotlight, search for people in the list that you haven't looked at or search for an entire department, like engineering. You may need to scroll to see the results from Colleagues in the list.

![width=35%](/images/app-screen-6.png)

> **NOTE**: You could see duplicate results because you were previously indexing `NSUserActivity` items without the `relatedUniqueIdentifier` set. You can delete the app to clear the index or continue to the next section to learn about removing indexed items.

### Make the results do something

But what happens when you tap on a result? Not much! You need to handle results indexed with Core Spotlight a bit differently than you did for `NSUserActivity` results.

Open **AppDelegate.swift** and import `CoreSpotlight` at the top of the file:

    import CoreSpotlight

Then replace `guard` statement in `application(_:continueUserActivity:restorationHandler:)` with the following:

```swift
let objectId: String
if userActivity.activityType == Employee.domainIdentifier,
  let activityObjectId = userActivity.userInfo?["id"] as? String {
  // Handle result from NSUserActivity indexing
  objectId = activityObjectId
} else if userActivity.activityType == CSSearchableItemActionType,
  let activityObjectId = userActivity
    .userInfo?[CSSearchableItemActivityIdentifier] as? String  {
  // Handle result from CoreSpotlight indexing
  objectId = activityObjectId
} else {
  return false
}
```

[FPE/AUTHOR TODO: Please replace the comments with numbered comments that are explained below, or just remove them. Thanks! ~WL]

When the user selects a result that Core Spotlight indexed directly, it'll come in with an `activityType` of `CSSearchableItemActionType`. Furthermore, the unique identifier is stored in the `userInfo` dictionary under the key `CSSearchableItemActivityIdentifier`. This logic handles both cases, regardless of how the employees are indexed.

Build and run, then try to select an employee. The app should open to the chosen result, as you'd expect.

### Deleting items from the search index

Back to the premise of your app. Say that an employee was fired for duct taping the boss to the wall after a particularly rough day. Obviously, you won't need to contact that person anymore, so you need to remove him and anybody else that leaves the company from the Colleagues search index. 

For this sample app, you'll simply delete the entire index when the app's indexing setting is disabled.

Open **EmployeeService.swift** and find `destroyEmployeeIndexing()`. Replace the `TODO` with the following logic:

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
3.	In the simulator or on your device, go to **Settings \ Colleagues** and set **Indexing** to **All Records**.
4.	Open the app again. This will start the indexing process.
5.	Go back to the home screen and activate Spotlight.
6.	Search for a known employee and verify the entry appears.
7.	Go to **Settings \ Colleagues** and set **Indexing** to **Disabled**.
8.	Quit the app.
9.	Reopen the app. This will invoke deletion of indicies.
10. Go to the home screen and activate Spotlight.
11. Search for a known employee and verify that *no* results appear.

So deleting the entire search index was pretty easy, huh? But what if you want to single out a specific item? Good news – these two APIs give you more fine-tuned control over what is deleted: 
- `deleteSearchableItemsWithDomainIdentifiers(_:completionHandler:)` lets you delete entire "groups" of indexes based on their domain identifiers. 
- `deleteSearchableItemsWithIdentifiers(_:completionHandler:)` lets you work only with individual records based on their unique identifiers.

This means that globally unique identifiers are _required_ if you're indexing multiple types of records. 

> **Note**: If you can't guarantee uniqueness across types, like when replicating a database that uses auto-incrementing IDs, then a simple solution could be to prefix the record's ID with its type. For example, if you had a contact object with an ID of 123 and an order object with an ID of 123, you could set their unique identifiers to **contact.123** and **order.123** respectively.

It is also very important to keep indexes up-to-date with changes. In the case of Colleagues you need to handle promotions, department changes, new phone numbers or even name changes. To update indexed items, use the same method that you indexed them with in the first place:     

    `indexSearchableItems(_:completionHandler:)`.

Great work! Once you have all of the above working, you can set the sample project aside. The next sections will discuss some advanced features of app search.

## Private vs. public indexing

Sometimes it makes sense to publicly index your content because both you and the users benefit. 

For you, your content can show in search results to iOS users that don't even have your app. Talk about a great way to get more downloads! The user gets to discover new, interesting apps. For everybody, your indexing improves with time since Apple ranks your content based on views and selections.

By default, all indexed content is considered private. This is also true for any content that you index directly with Core Spotlight, like you did with Colleagues. To make content indexed publicly you set the `eligibleForPublicIndexing` property on `NSUserActivity` to `true`.

But there's actually a little more to it than that. Apple has taken a few safeguards to protect user privacy and the quality of its public indexes. In order for content to become public in Apple's cloud index, it must first be reported by an undefined number of unique users. This means that if you accidentally index a user's private information and set it as public, it would never appear in the public index because only one user would've ever viewed it.

Apple has not provided the exact numbers on this threshold, and making a bet on that number would be a poor idea. :] There's also no way to directly test public indexing, so you'll just need to trust that it actually works.

The other approach for making content publicly indexed is using _web markup_, which is covered in the next chapter.

## Advanced features

The Core Spotlight framework provides a couple more advanced features you'll want to know about.

### Spotlight Index App Extensions

If an app receives data from an outside source like an API, it might make sense to index content while users are not using your app. A movie theatre may have an app with movie listings and times, but listings are only made available a few days in advance. It would be a shame if a user searched in Spotlight for movie times and didn't get results from the app because they hadn't opened it in weeks.

If your app has data like this, you'll want to implement a **Spotlight Index App Extension**. To add this extension, simply add a new **Spotlight Index Extension** target to your project.

![width=75%](/images/spotlight-extension.png)

Spotlight index extensions contain a subclass of `CSIndexExtensionRequestHandler`. This declares conformance to the `CSSearchableIndexDelegate` protocol, which has only two required methods. As an example, an extension for Colleagues might look like this:

```swift
class IndexRequestHandler: CSIndexExtensionRequestHandler {

  override func searchableIndex(searchableIndex: CSSearchableIndex,
    reindexAllSearchableItemsWithAcknowledgementHandler
      acknowledgementHandler: () -> Void)
  {
    // Reindex all employees with the provided index
    acknowledgementHandler()
  }

  override func searchableIndex(searchableIndex: CSSearchableIndex,
    reindexSearchableItemsWithIdentifiers identifiers: [String],
      acknowledgementHandler: () -> Void)
  {
    // Reindex any employees with the given identifiers
    // and the provided index
    acknowledgementHandler()
  }

}
```
[FPE/Author TODO: Similar to the last comment, the above comments are a step away from our normal style. Please change them to numbers with corresponding explanations or delete them.]

### Batch indexing

You may need to perform a batch of index operations, and given that your app can be terminated by the user, it might be ideal to perform small batch updates if you need to index a large number of records. 

Core Spotlight provides APIs for this too. They provide the ability to define the client's state after each batch, and then retrieve that same client state before performing the next batch.

You can't use the `defaultSearchableIndex` to use batching; you need to create your own `CSSearchableIndex` instance. You must also ensure that operations on the index happen on a single thread, as concurrent access of an index is not supported.

If Colleagues used a large database, it would be ideal to batch index. After downloading the entire record set, you could effectively "page" through and batch small groups. Your client state might be as simple as the last employee's `objectId` indexed from the batch, assuming the downloaded record set is sorted by `objectId`. Then, before performing the next batch, you'd grab another group of records that start after the `objectId` from the client state property.

Below is a sample implementation for batching employees from Colleagues:
```swift
//1
let index = CSSearchableIndex()                                   
//2
index.beginIndexBatch()                                           
index.fetchLastClientStateWithCompletionHandler { state, error in
  let lastIndexedObjectId: String?
  if let state = state,
    objectId = NSString(data: state,
// 3
      encoding: NSUTF8StringEncoding) as? String                
  {
    lastIndexedObjectId = objectId
  } else {
    lastIndexedObjectId = nil
  }
//4
  let batch = self.employeeBatchAfter(lastIndexedObjectId)         
// 5
  let items = batch.map{ $0.searchableItem }                      
// 6
  index.indexSearchableItems(items, completionHandler: nil)      
  let state = batch
    .last!
    .objectId.dataUsingEncoding(NSUTF8StringEncoding)!
// 7
 index.endIndexBatchWithClientState(state) { error in            
    // handle error
  }
}
```

Here's what's going on in this snippet:
1.	Create a searchable index.
2.	Designate that you'll begin batch indexing.
3.	Attempt to unwrap the `clientState`. This will be `nil` if it's the first batch.
4.	Load the next batch of employee records given an `objectId` or `nil`. Passing `nil` provides the first batch.
5.	Map the employee records to an array of `CSSearchableItem`.
6.	Index the items using the same `indexSearchableItems` you used earlier.
7.	Designate that you're finished with the batch and provide a new `clientState`, which is the last `objectId` for the processed batch.

Some additional logic would be required to continue this process until all employees have been indexed, but from this example, you can see how simple a batching operation can be.

## Where to go from here?

This chapter has covered iOS 9's simple yet powerful implementation to make your app's content searchable in Spotlight. Another way you can utilize app search is by making key navigation points searchable. 

Consider a CRM app that has multiple sections such as _Contacts_, _Orders_ and _Tasks_. By indexing an activity when the user lands on one of these screens, you'd make it possible for them to search for _Orders_ and go directly to that section of your app. How powerful would this be if your app has many levels of navigation? Siri can also be used to perform the search.

There are many unique ways to bubble up content to your users. Think outside the box and remember to educate your users about this powerful function.

To find out more about app search, be sure to watch _Session 709 - Introducing Search APIs_ from WWDC 2015 (<http://apple.co/1gvlfGi>) because there are many little nuances to know. The [App Search Programming Guide](http://apple.co/1J0WBs1) (http://apple.co/1J0WBs1) is also an excellent reference for implementing search in your own apps.

Finally, if your app has a web counterpart, then the next chapter of this book, "Your App On The Web", will tell you more about publicly indexing your web content.

