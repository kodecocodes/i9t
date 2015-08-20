# Chapter 2: Introducing App Search

One frustration for many iOS developers is that Apple keeps a lot of the fun features for themselves. They're the ones who get deep integrations with iOS that every developer yearns for. The good news is that after Apple has vetted out a feature for themselves they often bring it to the masses; like with app extensions in iOS 8.

Currently, when a user wants to get to content in your app they have to go through a series of steps. They flip through pages on their home screen to find your app, open it, and search what they're looking for - if you've even implemented a search feature at all, that is! A savvy user may launch your app by using Siri or searching for it in Spotlight, but still they are left looking for their content once the app is launched. Meanwhile, Apple gets to make things like contacts, notes, messages, email, and apps directly searchable within Spotlight. The user simply taps on the search result and are taken straight to the content. No fair!

With iOS 9, Apple brings the ability for third party developers to make *their* content searchable through Spotlight! This also means that users can search within your app using Siri! Not only that, but you also get to make Siri context-aware: By simply saying "Remind me about *this* when I get home.", a user can create a reminder that links to a specific piece of content that they were viewing within *your* app. When the reminder pops up, they can jump straight back to what they were doing. Now you don't need to leave 20 tabs open in Safari in hopes that you get back to them later. Create a reminder, close the tab, and get on with your life!

[TODO: Fact check this with GM on a device, as of beta 5 it only creates a reminder with the activity's title, no link.]

## App search APIs

Before diving into the sample project and writing some code, you first need to be aware that there are three aspects of app search in iOS 9. Each are broken into separate APIs that achieve distinct results, but also work in concert with each other: `NSUserActivity`, Core Spotlight, and web markup.

### NSUserActivity

The first aspect of app search cleverly makes use of the `NSUserActivity` API that was introduced in iOS 8 to enable Handoff.

If you are not aware, Handoff allows a user to continue an activity on another device. As an example, consider that you're reading an email on your iPhone when you sit down at your Mac. A special Mail icon on your Mac's Dock will appear, allowing you to launch Mail and resume reading the same email right on your Mac. This is powered by `NSUserActivity`, which provides the OS with information necessary to resume a task on another device. The communication between devices occurs over a combination of iCloud, Bluetooth and Wi-Fi.

In iOS 9, the `NSUserActivity` class has been given a few new properties to enable search. If a task can be represented as an `NSUserActivity` to be handed off, it might make sense for that task to be searchable and continued on the *same* device. This enables you to index activities, states, and navigation points within an app so that the user can find them again later using Spotlight. For example a travel app might index hotels that the user has viewed, or a news app might index sections that the user has looked at such as politics or sports.

This chapter will not cover Handoff specifically, but you will learn how to make content searchable once it has been viewed.

### Core Spotlight

The second, and perhaps most 'conventional', aspect of app search is Core Spotlight. While it is nice to allow users to search for content they've previously accessed, it may make sense for your app to make a large set of content searchable all in one go. Core Spotlight is what the stock iOS apps like Mail and Notes use to index their content.

In some ways, Core Spotlight is sort of like a database for search information. You are given fine grained control of what, when and how content is added to the search index. You can also update and remove items from the search index. You can index all kinds of content, from files to videos to messages (and much more besides!).

Core Spotlight is the best way to provide full search capabilities of your app's content, including content that is private to the user. In this chapter you will be learning how to use the new Core Spotlight APIs to index all of the content of an app.

&nbsp;

### Web markup

The third aspect of app search is web markup, which is tailored towards apps that mirror their public content from a web site. A good example of this would be Amazon where you can search of any of the products that they sell, or even RayWenderlich.com. Using open standards for marking up web content, you can surface it in Spotlight and Safari search results, and even deep link users into your native app. This chapter will not touch on web markup, but you can find that information in Chapter 3, "Your App On The Web".

## Getting started

In this chapter you will be working with a sample app named _Colleagues_ that simulates a company address book. Rather than every employee being added to your phone's contacts list, the app provides its own directory of your colleagues. To keep things simple, the app uses a local set of data including a folder of avatar images and a JSON file containing all of the employee information. In the real world you would probably have a networking component that fetches contact data from true web-service.

Open the starter project and before you dive into any code, build and run.

![height=35%](/images/app-preview.png)
[TODO: Update after design process]

You will immediately see a list of all employees in the company. It's a small company of around 25 individuals. Select **Brent Reid** from the list to see all of his details. You'll also see a related list of employees who are in the same department. That is the extent of the app's features - it's very simple!

What might make this app infinitely better is search. As it stands you can't even search while you're in the app. You won't be adding search in the app, but you will be adding the ability to search from outside the app using Spotlight!

### Sample project

Take a moment to familiarize yourself with the codebase of the project. There are two targets: **Colleagues** which is the app itself, and **EmployeeKit** which is a framework to facilitate interactions with the employee database.

From the **EmployeeKit** group in Xcode, open **Employee.swift**. This is the model for an employee that has all of the properties you might expect. Employee instances are initialized using a JSON model. These models are stored under the **Database** group in a file named **employees.json**.

Moving on, open **EmployeeService.swift**. At the top of the file you will notice an extension declaration. You will be filling out the implementation of the two methods, marked with `TODO`, later. For now it is important to know that this service provides two public APIs: `employeeWithObjectId()` and `fetchEmployees()`. Both methods are documented. The first provides an `Employee` given its `objectId` and the second returns all employee records from the database.

The rest of the code in the EmployeeKit target is unimportant to the chapter's topic so there's no need to be familiar with it to continue.

Open **AppDelegate.swift** in the **Colleagues** group. Notice that there is only one method in here: `application(_:didFinishLaunchingWithOptions:)`. The implementation switches on `Setting.searchIndexingPreference` which allows the user to change the behavior of search indexing.

Notice that depending on the setting's value, a different service method is called. If you recall, these are the service methods that had `TODO` comments for you to implement later. You don't need to worry about this just yet, but you should be aware of this setting. The setting can be changed in the iOS system **Settings** app under **"Colleagues"**.

That wraps up what you should be aware of for now. The rest of the code is view controller logic which you will be modifying, but it's unnecessary to fully comprehend what is going on there in order to achieve the goal of enabling app search.

## Searching previously viewed records

As mentioned, `NSUserActivity` is the first step one should make towards implementing app search. There are a number of reasons for this:

1. It's dead simple. Creating an `NSUserActivity` instance can be done by setting a few properties.
2. When `NSUserActivity` is used to flag user activities, iOS will rank that content. Content accessed frequently is considered to be more important to the user and search results will reflect that.
3. You get the benefit of providing context to Siri. [TODO: Determine if this has notable benefits in GM]
4. You're one step closer to providing Handoff support.

Time to prove how simple `NSUserActivity` can be to implement!

With the **EmployeeKit group** selected, go to **File\New\File...**. Choose the **iOS\Source\Swift File** template and click **Next**. Name your new file **EmployeeSearch.swift** and verify that the target is set to **EmployeeKit**.

Within the new file, first import `CoreSpotlight`:

    import CoreSpotlight

Your code isn't using this yet, but you'll need it later. Next, still in **EmployeeSearch.swift**, add the following extension to the `Employee` struct:

```swift
extension Employee {
  public static let domainIdentifier = "com.raywenderlich.colleagues.employee"
}
```

This identifier will be used to identify the type of `NSUserActivity` created for employees. Next, below the `domainIdentifier` declaration, add the following computed property:

```swift
public var userActivityUserInfo: [NSObject: AnyObject] {
  return ["id": objectId]
}
```

This dictionary will be used as an attribute for your `NSUserActivity` to identify the activity.

Now add another computed property named `userActivity`:

```swift
public var userActivity: NSUserActivity {
  let activity = NSUserActivity(activityType: Employee.domainIdentifier)
  activity.title = name
  activity.userInfo = userActivityUserInfo
  activity.keywords = [email, department]
  return activity
}
```

This property will be used later to conveniently obtain an `NSUserActivity` instance for an employee. There are a few `NSUserActivity` properties being set:

- `activityType`: The type of activity that this is. You will use this later to identify `NSUserActivity` instances that iOS provides to you. Reverse DNS is the format that Apple suggests using.
- `title`: The name of the activity. This will also appear as the primary name in a search result.
- `userInfo`: A dictionary of values for you to populate how you wish. When the activity is passed back to your app (for example after the user taps a search result in Spotlight) you will receive this dictionary back to assist you in presenting the right information to the user. In the sample project, this will be used to open the app to a specific employee record.
- `keywords`: A set of localized keywords that help the user find the record when searching.

Now your `NSUserActivity` property can be used to make an employee record searchable when it's being viewed by the user. Since you added these definitions in the EmployeeKit framework, you will need to build the project to see them from the app target. Press **Command-B** to build the project.

Open **EmployeeViewController.swift** and add the following at the bottom of the existing `viewDidLoad()` implementation:

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

In this code you are retrieving the `userActivity` property that you just created in your `Employee` extension. You then check the app's search setting.

* If searching is disabled, you mark the activity as not eligible for search.
* If the search setting is set to `ViewedRecords` then you mark the activity as being eligible for search, but also set `relatedUniqueIdentifier` to `nil`. It is required that this be `nil` if you do not have a corresponding Core Spotlight index item. Later, you will give this an actual value when performing a full index of the app's contents.  
* If the search setting is `AllRecords`, you mark the activity as eligible for search.

Finally, you set the view controller's `userActivity` property to your employee's activity.

> **NOTE**: The `userActivity` property on the view controller is inherited from `UIResponder`. Apple added this property in iOS 8 to enable Handoff.

The last step that ensures you'll have the information necessary when a search result is selected is to override `updateUserActivityState()`. Add the following method after `viewDidLoad()`:

```swift
override func updateUserActivityState(activity: NSUserActivity) {
  activity.addUserInfoEntriesFromDictionary(
    employee.userActivityUserInfo)
}
```

The system calls this method at various times in the lifecycle of your `UIResponder` and you are responsible for keeping the activity up to date. In this case you simply provide the `employee.userActivityUserInfo` dictionary you defined earlier which contains the employee's `objectId`.

Great! Now when an employee is viewed, that history will be tracked and become searchable (provided the setting is turned on). In the simulator or on your iOS device, open the **Settings** app and scroll down to **Colleagues**. Change the **Indexing** setting to **Viewed Records**.

[NOTE: As of beta 5, there seems to be a simulator bug where occasionally the contents of the Colleagues settings screen disappears until you force quit and reopen the Settings app. Check this on GM.]

![width=35%](/images/app-screen-3.png)

Now, build and run the app and select **Brent Reid**.

At this point you won't see anything happen, but behind the scenes the activity has been indexed. Exit to the home screen. If you're using the simulator you can press **Command-H**. Bring up Spotlight by either swiping down from the middle of the screen or swiping all the way to the left of your home screen pages. Type **"brent reid"** into the search field.

![width=35%](/images/app-screen-4.png)
[TODO: Update once an App Icon is in place.]

And there's Brent Reid as a result! If you do not see the result, you may need to scroll down past any other results. If you tap on the result, you should see it further up the list next time you perform the same search.

![height=30%](/images/whoa-meme.jpg)

Now, of course this is *awesome*, but the result is a little... bland. Surely you can surface more information than just the employee's name. To add extra details you will need to crack open the `CoreSpotlight` framework. But you won't be doing a full CoreSpotlight index just yet - that comes later.

### Adding more information to search results

`NSUserActivity` has a property named `contentAttributeSet` that is of the type `CSSearchableItemAttributeSet`. This type allows you to describe your content with as many attributes as necessary. Out of the box, Apple has provided a wide range of ways to describe your content through these attributes. You can peruse them in the `CSSearchableItemAttributeSet` class reference. In this section, you'll add an attribute set to your activity to improve the search results.

The desired result is shown below with each component's property name called out:

![width=100%](/images/properties-diagram-1.png)

You've already set the `title` property on `NSUserActivity`, and it's all that's being displayed at the moment. The other three, `thumbnailData`, `supportsPhoneCall`, and `contentDescription`, are all properties of `CSSearchableItemAttributeSet`. It's time to get cracking on building an instance of `CSSearchableItemAttributeSet`.

Open **EmployeeSearch.swift**. At the top, import MobileCoreServices`:

```swift
import MobileCoreServices
```

`MobileCoreServices` is required for a special identifier that will be used to create the `CSSearchableItemAttributeSet` instance. You've also already imported `CoreSpotlight`, which is needed for all of the APIs prefixed with `CS`.

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

When initializing `CSSearchableItemAttributeSet`, a `itemContentType` parameter is required. The `kUTTypeContact` passed in comes from the `MobileCoreServices` framework. You can read about these types on Apple's [UTType Reference](http://apple.co/1NilqiZ) (http://apple.co/1NilqiZ) page.

The attribute set created above contains all the relevant search metadata for the current employee: `title` will be the same as the `NSUserActivity`'s title', `contentDescription` contains the employee's department, title, and phone number, and `thumbnailData` is the result of `loadPicture()` converted to `NSData`.

To get the call button to appear, you must set `supportsPhoneCall` to `true` and provide a set of `phoneNumbers`. Finally, you add the employee's email addresses and set their various skills as keywords. By adding all of these details, Core Spotlight will index each one and surface up results when the user enters any of them. This means that you users can now search for an employee using their name, department, title, phone number, email address and even their skills!

The last step is to set the `contentAttributeSet` of your `NSUserActivity` to use this information. Still in **EmployeeSearch.swift**, add the following line above the `return` in `userActivity`:

```swift
activity.contentAttributeSet = attributeSet
```

Now, build and run! Once the app is running, open **Brent Reid's** record so that the new information is indexed. Now go to the home screen and activate Spotlight and search for "brent reid". If your previous search is still there, you'll need to clear it and search again.

![width=35%](/images/app-screen-5.png)

Voila! Aren't you amazed with how few lines of code it took to pull this off?

Great work! Your users can now use Spotlight to search for colleagues that they've previously viewed. Unfortunately there is one glaring omission... They can't open the app directly to the employee's record! Time to fix that.

### Opening search results

Now that you've got search results appearing, you need to handle what happens when a user taps on one of them. An ideal user experience is to launch the app directly to the relevant content without any fanfare. In fact, the speed at which your app launches and displays useful information to the user is one of the metrics that Apple uses to rank search results.

In the previous section you laid the ground work for this by providing both an `activityType` and a `userInfo` object for your `NSUserActivity` instances.

Open **AppDelegate.swift** and add an empty implementation of  `application(_:continueUserActivity:restorationHandler:)` below `application(_:didFinishLaunchingWithOptions:)`:

```swift
func application(application: UIApplication,
  continueUserActivity userActivity: NSUserActivity,
  restorationHandler: ([AnyObject]?) -> Void) -> Bool {

  return true
}
```

This method is called when a user selects a search result from Spotlight. It also happens to be the same method that is called when Handoff is used to continue an activity from another device.

Add the following logic above `return true` in `application(_:continueUserActivity:restorationHandler:)`:

```swift
guard userActivity.activityType == Employee.domainIdentifier,
  let objectId = userActivity.userInfo?["id"] as? String else {
    return false
}
```

This guard statement verifies the `activityType` is what you defined as an the activity for Employees and then it attempts to extract the `id` from `userInfo`. If either of these fail, then the method returns `false` letting the system know that the activity was not handled.

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

 If the `id` *is* obtained, your objective is to display the `EmployeeViewController` for the matching Employee.

The code above may appear a bit confusing, but recall how the app is designed. There are two view controllers, one that is the list of all employees and another that shows employee details. The above code pops the application's navigation stack back to the list and then pushes to the details view for the employee.

If for some reason the view cannot be presented, the method returns `false`.

Okay, time to build and run! Once the app opens, select **Cary Iowa** from the employees list then go to the home screen. Activate Spotlight and search for **Brent Reid**. When the search result appears, tap it. The app will open and you will quickly see it transition from Cary's record to Brent's. Excellent work!

The next step will be indexing *all* employees to make them searchable even if you've not previously viewed them.

## Indexing with Core Spotlight

Now that previously viewed records are being indexed, you're not far off from indexing the entire employee database. You might be thinking "why didn't I do this first?". Well, `NSUserActivity` is generally an easier first step when making content searchable. Many apps might not even have sets of content that can be indexed with Core Spotlight - but all apps have activities that the user takes part in. Also, by using activities you gain content ranking.

Hypothetically speaking, say that an employee has the same name as a popular actress. When searching in Spotlight for that name, the user will likely be given the the actress's IMDB page as the first result. However, if they frequently visit that employee's record in your app, it is possible that iOS will rank that result higher than IMDB. Remember that users often want to return to records they've previously viewed.

Of course, in your own app you could implement Core Spotlight indexing first if you really wanted to :]

Start by opening **EmployeeSearch.swift** and add the following line to the `attributeSet` computed property, right above the return statement:

```swift
attributeSet.relatedUniqueIdentifier = objectId
```

This assignment is to build a relationship between your `NSUserActivity` and what will soon be an `CSSearchableItem` which you will be inserting into the Core Spotlight index. If you do not relate the two records, your users will begin seeing duplicate search results. You may remember that earlier you set this property to `nil` on your `NSUserActivity` when the app is in 'Viewed Records' mode.

Next you need to create the `CSSearchableItem` that is required to index directly with Core Spotlight. Add the following computed property definition to **EmployeeSearch.swift**, below `attributeSet`:

```swift
var searchableItem: CSSearchableItem {
  let item = CSSearchableItem(uniqueIdentifier: objectId,
    domainIdentifier: Employee.domainIdentifier,
    attributeSet: attributeSet)
  return item
}
```

This is brief because you're already creating the `CSSearchableItemAttributeSet`, which holds most of the interesting metadata. Notice that `uniqueIdentifier` is set to `objectId` to build the inverse relationship with your `NSUserActivity`.

Open **EmployeeService.swift** and import CoreSpotlight at the top of the file:

```swift
import CoreSpotlight
```

Now, within `indexAllEmployees()` replace the `TODO` comment with the following:

```swift
let employees = fetchEmployees()                          // 1
let searchableItems = employees.map { $0.searchableItem } // 2
CSSearchableIndex
  .defaultSearchableIndex()
  .indexSearchableItems(searchableItems) { error in       // 3
  if let error = error {                                  // 4
    print("Error indexing employees: \(error)")
  } else {
    print("Employees indexed.")
  }
}
```

Stepping through the logic...

1. All employees are fetched from the database as an array of `Employee`s.
2. The employee array is mapped to `[CSSearchableItem]`.
3. Using Core Spotlight's default index, the array of `CSSearchableItem`s is indexed.
4. Finally, log a message on success or failure.

And.... That's it! Now when you launch the app with the option "All Records" set for the app's "Indexing" setting all employee records will be indexed and searchable. So, give it a shot!

Head over to the **Settings** app, and change the **Indexing** setting for Colleagues to **All Records**. Then build and run. In Spotlight, try searching for people you see in the list whose records you haven't viewed before. Or try searching for an entire department like "engineering"! You may need to scroll to see the results from Colleagues in the list.

![width=35%](/images/app-screen-6.png)

> **NOTE**: You may see duplicate results due to the fact that you were previously indexing `NSUserActivity` items without the `relatedUniqueIdentifier` set. You can delete the app to clear the index or continue to the next section to learn about removing indexed items.

But what happens when you tap on a result? You'll find that it doesn't take you to the respective record. The reason for this is that you need to handle results indexed directly with Core Spotlight a bit differently to your `NSUserActivity` results.

Open **AppDelegate.swift** and import `CoreSpotlight` at the top of the file:

```swift
import CoreSpotlight
```

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

When a result is selected that was indexed using Core Spotlight directly it will come in with an `activityType` of `CSSearchableItemActionType`. Further more, the unique identifier is stored in the `userInfo` dictionary under the key `CSSearchableItemActivityIdentifier`. Now this logic will handle both cases regardless of how the employees are indexed.

Build and run, then try to select a search result again. Everything should be working as you'd expect!

### Deleting items from the search index

Sometimes things happen and employees leave a company. When scenarios like this happen it'll be necessary to delete items from the Colleagues search index. For this sample app you will simply be deleting then entire index when the app's "Indexing" setting is set to "Disabled".

Open **EmployeeService.swift** and find `destroyEmployeeIndexing()`. Replace the `TODO` comment and add the following logic:

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

Just a single parameterless call and you've destroyed the entire indexed database for your app. Now with this logic in place it is time to test it out. Perform the following test script to see that index deletion is working as intended:

1. Build and run to install the app.
2. Stop the process in Xcode.
3. In the simulator or on your device, go to **Settings > Colleagues** and set **Indexing** to **All Records**.
4. Open the app again. This will start the indexing process.
5. Go back to the home screen and activate Spotlight.
6. Search for a known employee and verify that results appear.
7. Go to **Settings > Colleagues** and set **Indexing** to **Disabled**.
8. Quit the app.
9. Reopen the app. This will invoke deletion of indicies.
10. Go to the home screen and activate Spotlight.
11. Search for a known employee and verify that *no* results appear.

So deleting the entire search index was pretty easy, huh? But what if you want to single out specific items to delete? Good news! There are two other APIs that give you more fine-tuned control over what is deleted: `deleteSearchableItemsWithDomainIdentifiers(_:completionHandler:)` and `deleteSearchableItemsWithIdentifiers(_:completionHandler:)`.

The first will let you delete entire "groups" of indexes based on their domain identifiers while the second lets you narrow down to individual records based on their unique identifiers. This means that it is _required_ that you use globally unique identifiers if you're indexing multiple types of records. If you cannot guarantee uniqueness across types (perhaps when replicating a database that uses auto-incrementing IDs), then a simple solution could be to prefix the record's ID with its type. For example, if you had a contact object with an ID of 123 and an order object also with an ID of 123, you could set their unique identifiers to "contact.123" and "order.123" respectively.

It is also very important to keep your indexes up-to-date with changes. For the Colleagues app you may have an employee that gets a promotion, changes departments, gets a new phone number, or even changes their name. To update indexed items you use the same method that you indexed them with in the first place: `indexSearchableItems(_:completionHandler:)`.

Great work! Once you've got all of the above working you can set the sample project aside. The next sections will discuss some advanced features of app search.

## Private vs public indexing

Depending on your app it might make sense publicly index your content. This benefits both you and your users. For you, your content can be surfaced in results to iOS users who don't even have your app installed. This is a great way to gain new users of your app. The benefit for the user is that they discover new apps that might be of interest to them. For your existing users, your indexing gets better over time since Apple ranks your content as it is viewed and selected from search results.

By default all indexed content is considered private. This is also true for any content that you index using Core Spotlight directly, like you did in the Colleagues sample app. To make content indexed publicly you set the `eligibleForPublicIndexing` property on `NSUserActivity` to `true`.

But there's actually a little more to it than that. Apple has taken a few safeguards to protect both your users' data and the quality of their public indexes. In order for content to become public in Apple's cloud index, it must first be reported by an undefined number of unique users. This means that if you accidentally indexed a single user's private information and set it as public, it would never appear in the public index because only one user would've ever viewed it.

Apple has not provided the exact numbers on this threshold, and putting any money on them doing so would probably be a poor bet. There's also no way to directly test public indexing, so you'll just need to trust that it actually works.

The other approach for making content publicly indexed is using _web markup_ which is covered in the next chapter.

## Advanced features

The Core Spotlight framework provides a couple more advanced features that were not covered in the sample project.

### Spotlight Index App Extensions

In the event that your app receives data from an outside source like an API, it might make sense to index content while users are not using your app. A movie theatre for example may have an app with their movie listing and times, but listings are made available only a few days in advance. It would be a shame if a user searched in Spotlight for movie times and didn't get results from the app because they hadn't opened it in weeks.

If your app has data like this, you will want to implement a **Spotlight Index App Extension**. You can add this extension by adding a new **Spotlight Index Extension** target to your project.

![width=75%](/images/spotlight-extension.png)

Spotlight Index Extensions contain a subclass of `CSIndexExtensionRequestHandler`. This declares conformance to the `CSSearchableIndexDelegate` protocol, which has only two required methods. An extension for the Colleagues app might look something like this:

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

### Batch indexing

You may also find that you need to perform a batch of index operations. Given that your app can be terminated by the user, it might be ideal to perform small batch updates if you plan to index a large number of records. Core Spotlight provides APIs for this too. When using these APIs, you are given the ability to define the client's state after each batch and then retrieve that same client state before performing the next batch.

To use batching, you must not use the the `defaultSearchableIndex`. Rather you need to create your own `CSSearchableIndex` instance. You must also ensure that operations on the index you create happen on a single thread, as concurrent access of an index is not supported.

If the Colleagues app were using a large database, it might be ideal to batch the indexing process. After downloading the entire record set you could effectively "page" through and batch small groups. Your client state might be as simple as the last employee's `objectId` indexed from the batch (assuming the downloaded record set is sorted by `objectId`). Then, before performing the next batch, you can grab another group of records, starting after the `objectId` from the client state property.

Below is a possible implementation for batching employees from the Colleagues app:

```swift
let index = CSSearchableIndex()                                   // 1
index.beginIndexBatch()                                           // 2
index.fetchLastClientStateWithCompletionHandler { state, error in

  let lastIndexedObjectId: String?
  if let state = state,
    objectId = NSString(data: state,
      encoding: NSUTF8StringEncoding) as? String                  // 3
  {
    lastIndexedObjectId = objectId
  } else {
    lastIndexedObjectId = nil
  }

  let batch = self.employeeBatchAfter(lastIndexedObjectId)        // 4
  let items = batch.map{ $0.searchableItem }                      // 5
  index.indexSearchableItems(items, completionHandler: nil)       // 6
  let state = batch
    .last!
    .objectId.dataUsingEncoding(NSUTF8StringEncoding)!
  index.endIndexBatchWithClientState(state) { error in            // 7
    // handle error
  }
}
```

Here's what's going on in this snippet:

1. First create a searchable index.
2. Designate that you will begin batch indexing.
3. Attempt to unwrap the `clientState`. This will be `nil` if it is the first batch.
4. Load the next batch of employee records given an `objectId` or `nil`. Passing `nil` provides the first batch.
5. Map the employee records to an array of `CSSearchableItem`s.
6. Index the items using `indexSearchableItems`, that you used earlier.
7. Designate that you're finished with the batch and provide a new `clientState`, which is the last `objectId` for the processed batch.

Some additional logic would be required to continue this process until all employees have been indexed, but you can see just how simple a batching operation like this can be.

## Where to go from here?

This chapter has covered iOS 9's simple yet powerful implementation for making the content of your app searchable in Spotlight. Another way you can utilize app search is by making key navigation points searchable. Consider a CRM app that has multiple sections such as "Contacts", "Orders", and "Tasks". By indexing an activity when the user lands on one of these screens, you'd make it possible for them to search "Orders" to go directly to that section within your app. How powerful might this be if your app has many levels of navigation? Consider also that Siri can be used to perform the search.

There are many unique ways you might find to bubble up content to your users. Think outside the box and educate your users on this new feature.

To find out more about app search, be sure to watch _Session 709 - Introducing Search APIs_ from WWDC 2015 (<http://apple.co/1gvlfGi>) as there are many little details shown and mentioned. The [App Search Programming Guide](http://apple.co/1J0WBs1) (http://apple.co/1J0WBs1) is also an excellent resource as you implement search in your own apps.

Finally, if your app has a web counterpart then the next chapter of this book, "Your App On The Web", will tell you more about publicly indexing your web content.
