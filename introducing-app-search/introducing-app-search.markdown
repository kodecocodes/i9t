# Chapter 2: Introducing App Search

One frustration for many iOS developers is that Apple gets to have all of the fun. They're the ones who get deep integrations with iOS that every developer yearns for. The good news is that after Apple has vetted out a feature for themselves they often bring it to the masses; like with App Extensions in iOS 8.

Currently, when a user wants to get to content in your app they have to go through a series of steps. They flip through pages on their home screen to find your app, open it, and search what they're looking for. A savvy user may launch your app by using Siri or searching for it in Spotlight, but still they are left searching for their content once the app is launched. Meanwhile, Apple gets to make things like contacts, notes, messages, email, apps and other things directly searchable within Spotlight. The user simply taps on the search result and are taken straight to the content—no fair!

New with iOS 9 Apple brings the ability for third party developers to make *their* content searchable through Spotlight! This also means that users can search within your app using Siri! Not only do you get to make your content searchable with Siri, you also get to make Siri more aware of your content. By saying "Remind me about *this* when I get home." a user can create a reminder that links to the record they are viewing in *your* app! When the reminder pops up, they can go directly back to what they were doing. Now you don't need to leave 20 tabs open in Safari in hopes that you get back to them later. Create a reminder, close the tab, and get on with your life!

> **TODO**: Fact check this with GM on a device.

## Trifecta of App Search

Before diving into a sample project and code you first need to be aware that there are three aspects of App Search. Each are broken into separate APIs that achieve distinct results, but also work in concert with each other.

### NSUserActivity

The first aspect is `NSUserActivity`. Apple has taken a clever yet brilliant approach to App Search by tying it into `NSUserActivity` that is used to enable Handoff in iOS 8.

If you are not aware, Handoff allows a user to continue an activity on another device. As an example, consider that you're reading an email on your phone when you sit down at your Mac. A special Mail icon on your Mac's Dock appears that allows you to launch Mail and resume reading the message. This is powered by `NSUserActivity` who provides the OS with information necessary to resume the task on another device. The communication between devices occurs over a combination of iCloud, Bluetooth and WiFi.

The `NSUserActivity` class was given a few new properties to enable App Search that you will learn about in this chapter. Apple has determined through usage metrics that users want to get back to content they've previously viewed. If a task can be represented as an `NSUserActivity` to be handed off, it might make sense for that task to be searchable and continued on the *same* device. This chapter will not cover Handoff specifically, but you will learn how to make content searchable once it has been viewed.

### CoreSpotlight

The second aspect is Core Spotlight, while it is nice to allow users to search for content they've previously accessed, it may make sense for your app to make *all* content searchable. CoreSpotlight is what the stock iOS apps like Mail and Notes use to index their content. Through this API you are given fine grained control of what, when and how content is indexed. You can also update and remove items from the search index. CoreSpotlight is the best way to provide full search capabilities of your app's content, including content that is private to the user. In this chapter you will be learning how to use the new CoreSpotlight APIs to index all of the content of an app.

### Web Markup

The third aspect is Web Markup which is tailored towards apps that mirror their public content from a web site. A good example of this would be Amazon where you can search of any of the products that they sell, or even RayWenderlich.com. This chapter will not touch on Web Markup, but will find that information in Chapter 3, "Your App On The Web".

## Sample Project

For this chapter you will be working with a sample app named Colleagues that simulates what a company address book might look like. Rather than every employee being added to your phone's address book, the app provides a directory of your colleagues. To keep things simple, the app uses a local set of data that resides in the app bundle as a folder of avatar images and a JSON file containing all of the employee information. In the real-world you would prefer to have a networking component that downloads a bundle of data like this or one that accesses a true web-service.

### New Employee Orientation

Start by opening the Starter Project, and before diving into any code, build and run.

![height=35%](/images/app-preview.png)

You will immediately see a list of all employees in the company, it's a small company of around 25 individuals. Selecting **Brent Reid** from the list displays all of his details and also a related list of employees who are in the same department. That is the extent of the app, very simple. What might make this app infinitely better is searching, as it stands you can't even search while you're in the app. You won't be adding search in the app, but you will be adding the ability to search from outside the app using Spotlight!

#### Code Walk

Take a moment to familiarize yourself with the codebase of the project. There are two targets, Colleagues which is the app itself, and EmployeeKit — a framework to facilitate interactions with the employee database.

From the **EmployeeKit** group in Xcode, open **Employee.swift**. This is the model for an employee that has all of the properties you might expect, having just viewed Brent Reid's record. Employee instances are initialized using a JSON model (these models are stored under the Database group in a file named employees.json).

Moving on, open **EmployeeService.swift**. At the top of the file you will notice an extension declaration. You will be filling out the implementation of the two methods, marked with "TODO", later. For now it is important to know that this service provides two public APIs, `employeeWithObjectId()` and `fetchEmployees()`. Both methods are documented; the first provides an Employee given its `objectId` and the second returns all employee records from the database.

The rest of the code in the EmployeeKit target is unimportant to the chapter's topic so there's no need to be familiar with it to continue. Select the **Colleagues** group in Xcode that contains the code for the app itself.

Open **AppDelegate.swift**, notice that there is only one method in here `application(_:didFinishLaunchingWithOptions:launchOptions)`. The implementation switches on `Setting.searchIndexingPreference` which is in place to allow the user to change the behavior of search indexing. Notice that depending on the setting's value, a different service method is called. If you recall, these are the service methods that had "TODO" comments for you to implement later. No need to worry about that just yet, but you should be aware of this setting. The setting can be changed in the Settings iOS App under "Colleagues".

That wraps up what you should be aware of for now, the rest of the code is view controller logic which you will be modifying, but it's unnecessary to fully comprehend what is going on there in order to achieve the goal of enabling App Search.

## Search Previously Viewed Records

As mentioned, `NSUserActivity` is the first step one should make towards implementing App Search. There are a number of reasons for this.

1. It's dead simple; creating an `NSUserActivity` instance can be done by setting a few properties.
1. As a user navigates content where `NSUserActivity` instances are flagged as the current activity, iOS will rank that content. Content that accessed frequently is considered to be more important to the user and search results will reflect that.
1. You get the benefit of providing context to Siri.
1. You're one step closer to providing Handoff support.

Time to prove how simple `NSUserActivity` can be to implement.

Add a new Swift file named **EmployeeExt.swift** under the **EmployeeKit** group and verify that the target is set to **EmployeeKit**.

Define an extension on `Employee` with a static String named `domainIdentifier`.

```swift
extension Employee {
  public static let domainIdentifier = "com.raywenderlich.colleagues.employee"
}
```

This string will be used to identify the type of `NSUserActivity` created for Employees. Next, add a computed property named `userActivityUserInfo`.

```swift
public var userActivityUserInfo: [NSObject: AnyObject] {
  return ["id": objectId]
}
```

This is a dictionary that will be used as an attribute for your `NSUserActivity` that you will add now.

```swift
public var userActivity: NSUserActivity {
  let activity = NSUserActivity(activityType: Employee.domainIdentifier)
  activity.title = name
  activity.userInfo = userActivityUserInfo
  activity.keywords = [email, department]
  return activity
}
```

This property will later be used to conveniently obtain an `NSUserActivity` instance for an Employee. There are a few `NSUserActivity` properties being used:

- `activityType`: The type of activity that this is, you will use this later to identify `NSUserActivity` instances that iOS provides to you. Reverse-DNS is the format that Apple suggests using.
- `title`: The name of the activity, it will also appear as the primary name in a search result.
- `userInfo`: A dictionary of values for you to use when the activity is passed back to you, this will be used later to open the app to a specific employee record.
- `keywords`: A set of localized keywords that help the user find the record when searching.

Now your `NSUserActivity` property you can be used when an employee record is being viewed to make the record searchable. Open **EmployeeViewController.swift** and add the following at the bottom of the `viewDidLoad()` method.

```swift
let activity = employee.userActivity
if case .Disabled = Setting.searchIndexingPreference {
  activity.eligibleForSearch = false
} else {
  activity.eligibleForSearch = true
}

userActivity = activity
```

In this code you are retrieving the `userActivity` property that you just created on `Employee` via an `extension`. You then check the app's setting. If searching is disabled, mark the activity as not eligible for search, otherwise mark it true. Finally, set the view controller's `userActivity` property to your value.

> **NOTE**: The `userActivity` property on the view controller is inherited from `UIResponder`, in iOS 8 Apple added this property for Handoff support.

The last step to ensure that you'll have the information necessary when a search result is selected is to override `updateUserActivityState()`

```swift
override func updateUserActivityState(activity: NSUserActivity) {
  activity.addUserInfoEntriesFromDictionary(
    employee.userActivityUserInfo)
}
```

The system calls this method at various times in the lifecycle of your `UIResponder` and you are responsible for keeping the activity up to date, in this case you simply provide the `employee.userActivityUserInfo` dictionary you defined earlier that contains the employee's `objectId`.

Great! Now when an employee is viewed, that history will be tracked and become searchable (provided the setting is turned on). So go ahead and enable the **Viewed Records** setting. You will find the setting in the Settings app under **Colleagues**.

![iphone](/images/app-screen-3.png)

Now, build and run the app and select **Brent Reid**.

At this point you won't see anything happen, but behind the scenes the activity was indexed. Now, go to the Home screen (if you're using the Simulator you can type **CMD+H**). Bring up Spotlight by either swiping down from the middle of the screen or swiping all the way to the left of your home screen pages. Type "brent reid" into the search field.

![width=35%](/images/app-screen-4.png)
> **TODO**: Update once an App Icon is in place.

And there's Brent Reid as a result! If you do not see the result, you may need to scroll passed any other results.

![height=30%](/images/whoa-meme.jpg)

Now, of course this is *awesome*, but the result is a little... bland. Surely you can surface more information rather than just the employee's name. To get the extra details to appear, you will need to crack open the CoreSpotlight framework APIs. But you won't be doing a full CoreSpotlight index just yet.

`NSUserActivity` has a property named `contentAttributeSet` that is of the type `CSSearchableItemAttributeSet`. This type allows you to describe your content with as many attributes as necessary. Out of the box, Apple has provided a wide range of ways to describe your content through these attributes. You can peruse them in the `CSSearchableItemAttributeSet` class reference.

The desired result is shown below with each component's property name called out.

![width=100%](/images/properties-diagram-1.png)

The `title` property is the only one on `NSUserActivity` and this is what you've gotten to displayed. The other three, `thumbnailData`, `supportsPhoneCall`, and `contentDescription` are all properties of `CSSearchableItemAttributeSet`. So, its time to get cracking on building an instance of `CSSearchableItemAttributeSet`.

Import CoreSpotlight and MobileCoreServices at the top of **EmployeeExt.swift**.

```swift
import CoreSpotlight
import MobileCoreServices
```

`CoreSpotlight` is needed for all of the APIs prefixed with `CS` and `MobileCoreServices` is required for a special identifier that will be used to create the `CSSearchableItemAttributeSet` instance.

Add a new computed property named `attributeSet` to **EmployeeExt.swift**.

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

When initializing `CSSearchableItemAttributeSet` an `itemContentType` parameter is required, the `kUTTypeContact` passed in comes from the `MobileCoreServices` framework. You can read about these types on Apple's [UTType Reference](http://apple.co/1NilqiZ)(http://apple.co/1NilqiZ) page.

After initializing you need to fill in the rest of the details, `title` will be the same as it is on the `NSUserActivity`. Next, `contentDescription` contains the employee's department, title followed by a new line and then their phone number. The `thumbnailData` property is of the type `NSData`, not an actual `UIImage`, using `UIImageJPEGRepresentation()` you can convert the result of `loadPicture()`.

To get the call button to appear `supportsPhoneCall` must be set to `true`, you also need to provide a Set of `phoneNumbers`. Finally add the employee's email address as a Set and `skills` as `keywords`. By adding all of these details, CoreSpotlight will index each one and surface up results when the user enters any of them. This means that you users can now search for an employee using their name, department, title, phone number, email address and even their skills!

The last step is to take this new property and set it to `contentAttributeSet` of `NSUserActivity`. Still working in **EmployeeExt.swift** go to the definition of `userActivity`.

```swift
activity.contentAttributeSet = attributeSet
```

Update the definition so that `contentAttributeSet` is set before the `return`. Now, build and run! Once the app is running, open **Brent Reid's** record so that the new information is indexed. Now go to the home screen and activate Spotlight and search for "brent reid".

![width=35%](/images/app-screen-5.png)

Voila! Are you amazed with how few lines of code it took to pull this off?

Great work! Your users can now search for colleagues using Spotlight that they've previously viewed. Unfortunately there is one glaring omission... They can't open the app directly to the record! Time to fix that.

### Opening Search Results

Now that you've got search results appearing, an ideal user experience is to take the user directly to that content without any fanfare when they select it. In the previous section you laid the ground work for this by providing an `activityType` as well as `userInfo` on your `NSUserActivity` instances.

Open **AppDelegate.swift** and add an empty implementation of the `application(application:continueUserActivity:restorationHandler:)` method.

```swift
func application(application: UIApplication,
  continueUserActivity userActivity: NSUserActivity,
  restorationHandler: ([AnyObject]?) -> Void) -> Bool {

  return true
}
```

This method is called when a user selects a search result from Spotlight, it also happens to be the same method that is called when Handoff is used to continue an activity from another device. The first order of business is to verify the activity type and if it is what you're expecting, extract the information you planted in `userInfo`. Add the following logic above `return true` in the `application(application:continueUserActivity:restorationHandler:)` method.

```swift
let objectId: String
if userActivity.activityType == Employee.domainIdentifier,
  let activityObjectId = userActivity.userInfo?["id"] as? String {
  objectId = activityObjectId
} else {
  return false
}
```

This logic verifies the `activityType` is what you defined as an the activity for Employees, then it attempts to extract the `id` from `userInfo`. If both succeed, `objectId` is set to be used next. Otherwise the method returns `false` letting the system know that the activity was not handled. When the `objectId` *is* obtained your objective is to display the `EmployeeViewController` for the Employee with that `objectId`.

The code below may appear a bit confusing, but recall how the app is designed. There are two view controllers, one that is the list of all employees and another that shows employee details. You will need to pop the application's navigation stack back to the list and then push to the details view for the employee. Replace `return true` with the following.

```swift
if let nav = window?.rootViewController as? UINavigationController,
  listVC = nav.viewControllers.first as? EmployeeListViewController,
  employee = EmployeeService().employeeWithObjectId(objectId)
{
  nav.popToRootViewControllerAnimated(false)

  let employeeViewController = listVC
    .storyboard?
    .instantiateViewControllerWithIdentifier("EmployeeView") as! EmployeeViewController

  employeeViewController.employee = employee
  nav.pushViewController(employeeViewController, animated: false)
  return true
} else {
  return false
}
```

As described, this logic works its way through the app's view hierarchy to push to an `EmployeeViewController` for the selected search result. If for some reason the view cannot be presented, return `false`.

Okay, time to build and run! Once the app opens, select **Cary Iowa** then go to the home screen. Activate Spotlight and search for **Brent Reid**, when the result appears select it. The app will open and you will quickly see it transition from Cary's record to Brent's. Excellent work! The next step will be indexing *all* employee to make them searchable without having previously viewed them.

## Index All The Things!

Now that previously viewed records are being indexed, you're not far off from indexing the entire employee database. You might be thinking, why didn't I do this first? Well, recall that `NSUserActivity` is the first step you should take when making content searchable. By using activities you gain content ranking.

Hypothetically speaking, say that an employee the same name as a popular actress. When searching in Spotlight for that name, the user will likely be given the the actress's IMDB page as the first result. However, if they frequently visit that employee's record in your app, it is possible that iOS will rank that result higher than IMDB. Remember that a common usage pattern is users returning to records they've previously viewed.

Start by opening **EmployeeExt.swift** and add the following line to the computed property `attributeSet`, right above the return statement.

```swift
attributeSet.relatedUniqueIdentifier = objectId
```

This assignment is to build a relationship between this `NSUserActivity` and what will soon be an `CSSearchableItem` that you will be inserting into the CoreSpotlight index. If you do not relate the two records, your users will begin seeing duplicate search results.

Next you need to create the `CSSearchableItem` that is required to index directly with CoreSpotlight. Add the following computed property definition to **EmployeeExt.swift**.

```swift
var searchableItem: CSSearchableItem {
  let item = CSSearchableItem(uniqueIdentifier: objectId,
    domainIdentifier: Employee.domainIdentifier,
    attributeSet: attributeSet)
  return item
}
```

This is brief because you're already creating the `CSSearchableItemAttributeSet`. Notice that `uniqueIdentifier` is set to `objectId` to build the inverse relationship with your `NSUserActivity`.

Open **EmployeeService.swift** and import CoreSpotlight at the top of the file.

```swift
import CoreSpotlight
```

Now, locate the `indexAllEmployees()` method. Remove the TODO comment and add the following.

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

1. All employees are fetched from the database as `[Employee]`
2. The Employee array is mapped to `[CSSearchableItem]`
3. Using CoreSpotlight's default index, the array of `CSSearchableItem`s is indexed
4. Log an message on success or failure

And.... That's it! Now when you launch the app with the option "All Records" set for the app's "Indexing" setting all employee records will be indexed and searchable. So, give it a shot!

Set the **Indexing** setting to **All Records** and then build and run. Try searching for people you see in the list that you haven't looked at yet. Or try searching for an entire department like "engineering"! (You will likely need to scroll to see the results from your app.)

But what happens when you tap on a result? You'll find that it doesn't take you to the respective record. The reason for this is that you need to handle results indexed directly with CoreSpotlight a bit differently. Open **AppDelegate.swift** and import CoreSpotlight at the top of the file.

```swift
import CoreSpotlight
```

Then replace the logic that extracts `objectId` in `application(application:continueUserActivity:restorationHandler:)` with the following.

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

Notice the new `else if` branch. When a result is selected that was indexed using CoreSpotlight directly it will come in with an `activityType` defined as `CSSearchableItemActionType`. Further more, the unique identifier is stored in the `userInfo` dictionary under the key `CSSearchableItemActivityIdentifier`. Now this logic will handle both cases regardless of how the employees are indexed.

Build and run, then try to select a record again.


![width=35%](/images/app-screen-6.png)

> **NOTE**: You may see duplicate results due to the fact that you were previously indexing `NSUserActivity` items without the `relatedUniqueIdentifier` set. You can delete the app to clear the index or continue to the next section to learn about removing indexed items.

## Delete All The Indicies!

Sometimes things happen and employees leave the company, when scenarios like this happen it is necessary to delete items from the index. For this sample app you will simply be deleting then entire index when the app's "Indexing" setting is set to "Disabled". The same approach can be used to delete individual records as needed.

Open **EmployeeService.swift** and find the `destroyEmployeeIndexing()` method, remove the TODO comment and add the following logic.

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

Just one parameterless call and you can destroy the entire indexed database for your app. Now this is great for a setting like the app has, but again, what if you want to single out specific items to index? Good news, there are two other APIs that give you finer tuned control over what is deleted; `deleteSearchableItemsWithDomainIdentifiers(_:completionHandler:)` and `deleteSearchableItemsWithIdentifiers(_:completionHandler:)`.

The first will let you delete an entire "group" of indexes based on their domain identifier while the second lets you narrow down on the exact identifier that you provided for an individual record. This means that it is a good idea to use globally unique identifiers if you're indexing multiple types of records. This could be as simple as prefixing the record's Id with its type if you cannot guarantee the uniqueness across types, such as when you're replicating a database that uses auto-incrementing Ids. (e.g. "contact.123" vs "order.123")

Now with this logic in place it is time to test it out. Perform the following test script to see that index deletion is working as intended.

1. Build and Run to install the app
1. Stop the process in Xcode
1. Go to Settings > Colleagues > Set **Indexing** to **All Records**
1. Open the App (invokes indexing)
1. Go to the Home screen and activate Spotlight
1. Search for a known employee, verify that results appear
1. Go to Settings > Colleagues > Set **Indexing** to **Disabled**
1. Quit the App
1. Open the App (invokes deletion of indicies)
1. Go to the Home screen and activate Spotlight
1. Search for a known employee, verify that *no* results appear

Great work! Once you've got all of the above working you can set the sample project aside. The next sections will discuss some best practices and advanced features of App Search.

## Private vs Public Indexing

Depending on your app it might make sense to make a public index your content. This benefits both you and your users. For you, your content can be surfaced in results to iOS users who don't even have your app installed. This is a great way to gain new users of your app. The benefit for the user is that they discover new apps that might be of interest to them. For your existing users, your indexing gets better over time as Apple will rank your content as it is viewed and selected from search results.

By default all indexed content is considered private, this is also true for any content that you index using CoreSpotlight directly like you did in the Colleagues sample app. To make content indexed publicly you use the `eligibleForSearch` property on `NSUserActivity` by setting it to `true`. But it's not as cut and dry as it may sound. Apple has taken a few safe guards to protect both your user's data and the quality of their public indexes. In order for content to become public in Apple's indexing service, it must first be reported by an undefined number of unique users. Apple has not provided the exact numbers and putting any money on them doing so would probably be a poor bet.

The other approach for making content publicly indexed is using Web Markup which is covered in the next chapter.

## Batch Indexing



## Spotlight Index App Extensions

## Best Practices

## Where to go from here?
