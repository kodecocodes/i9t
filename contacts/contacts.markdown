```metadata
author: Evan Dekhayser
number: 11
title: Contacts
```

# Chapter 11: Contacts

A long time ago, in an operating system far, far away, developers accessed a user's contacts on their iOS device with a C API and had to deal with the pain of using ancient structs and Core Foundation types in an object-oriented world.

Actually, this wasn't so long ago and far away — this antiquated Address Book framework was still in use as of iOS 8!

Apple deprecated the Address Book framework in iOS 9 — hoorah! In its stead, they introduced two powerful object-oriented frameworks to manage user contacts: **Contacts** and **ContactsUI**. This chapter will show you how to use these frameworks to do the following:

1. Use the ContactsUI framework to display and select contacts.
2. Add contacts to the user's contact store.
3. Search the user’s contacts and filter using `NSPredicate`.

Along the way, you'll learn about best practices for dealing with the user’s contacts and how to get the most out of the Contacts framework.

## Getting started

In this chapter, you'll create the **RWConnect** app, which is a social network for iOS developers. The app has a friends list to help you keep in touch with all the great developers you know via email.

>**Note**: You should use the simulator instead of a real device to test your app in this chapter; you'll have to reset your device in order to test the app permissions, and you don't want to reset your personal iPhone, do you?

Open the starter project **RWConnect-Starter** and run it on the iPhone 6 Simulator; you'll see a table view with four friends listed, each with a name, picture, and email:

![iphone](/images/1-StarterProjectScreenshot.png)

You'll add more features to your app as you progress through the chapter to make your friends list more...friendly! :]

Time to look at the code behind the app. Open **Friend.swift**; it contains a struct `Friend`, which represents each friend in your app. Take note of `defaultContacts()`, which returns the contacts you see in the table.

Now open **FriendsViewController.swift**; you can see that you create the `friendsList` property with the results of `defaultContacts()` to retrieve the sample friends at launch.

The `UITableViewDataSource` methods in the view controller are straightforward; the table has one section with a cell for each friend in `friendsList`. Each cell displays the email address and photo of the respective friend.

Your first task is to use the ContactsUI framework to display your friends' contact information.

## Displaying a contact

Open **Main.storyboard** and select the table view cell in **FriendsViewController**.

In the **Attributes Inspector**, open the dropdown menu next to **Accessory** and select **Disclosure Indicator** as shown below:

![bordered width=45%](/images/2-AccessoryChoice.png)

The table view cell now displays an arrow to indicate there's more information available about this user:

![bordered width=50%](/images/3-DisclosureIndicator.png)

Before you can display the friend to the user, you'll need to convert the `Friend` instance into a `CNContact`.

### Convert friends to CNContacts

The Contacts framework represents contacts as instances of `CNContact`, which contain the contact's properties such as `givenName`, `familyName`, `emailAddresses`, and `imageData`.

Open **Friend.swift** and add the following import statement:

```swift
import Contacts
```

Now, add this extension with the computed property `contactValue`:

```swift
extension Friend {
  var contactValue: CNContact {
    // 1
    let contact = CNMutableContact()
    // 2
    contact.givenName = firstName
    contact.familyName = lastName
    // 3
    contact.emailAddresses = [
      CNLabeledValue(label: CNLabelWork, value: workEmail)
    ]
    // 4
    if let profilePicture = profilePicture{
      let imageData =
        UIImageJPEGRepresentation(profilePicture, 1)
      contact.imageData = imageData
    }
    // 5
    return contact.copy() as! CNContact
  }
}
```

Here's a line-by-line explanation of the code above:

1. You create an instance of `CNMutableContact` with no arguments.
2. Next, you update the contact's properties from the equivalent properties of the `Friend` instance.
3. `emailAddresses` is an array of `CNLabeledValue` objects. This means each email address has a corresponding label. There are many types of labels available for contacts, but in this case you're sticking with `CNLabelWork`.
4. If the `Friend` has a profile picture, set the contact's image data to the profile picture's JPEG representation.
5. Finally, return an immutable copy of the contact.

> **Note**: `CNMutableContact` is the mutable counterpart of `CNContact`. While the properties of `CNContact` are read-only, the properties of `CNMutableContact` can be changed. For this reason, you create a mutable contact, set its properties, then return an immutable copy when done. Note that `CNContact`, like most immutable objects, is thread-safe, while `CNMutableContact` is not.

With this method implemented, you can convert any `Friend` to a `CNContact`. Now that you can convert from one type to another, you can move on to displaying the contact.


### Showing the contact's information

Switch to **FriendsViewController.swift** and add the following import statements:

```swift
import Contacts
import ContactsUI
```

Also, add the following extension to the bottom of the file:

```swift
//MARK: UITableViewDelegate
extension FriendsViewController {
  override func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      tableView.deselectRowAtIndexPath(indexPath,
        animated: true)
      // 1
      let friend = friendsList[indexPath.row]
      let contact = friend.contactValue
      // 2
      let contactViewController =
        CNContactViewController(forUnknownContact: contact)
      contactViewController.navigationItem.title = "Profile"
      contactViewController.hidesBottomBarWhenPushed = true
      // 3
      contactViewController.allowsEditing = false
      contactViewController.allowsActions = false
      // 4
      navigationController?
        .pushViewController(contactViewController,
          animated: true)
  }
}
```

Here's what you're doing in the code above:

1. Use the index path of the selected cell to get the selected friend and convert it to an instance of `CNContact`.
2. Instantiate `CNContactViewController`; this is from the ContactsUI framework and displays a contact onscreen. You instantiate the view controller using its `forUnknownContact` initializer because the contact isn't part of the user's contact store. Also, you customize the behaviors of the navigation bar and tab bar to make the app look just right.
3. You set `allowsEditing` and `allowsActions` to `false` so the user can only view the contact's information.
4. Finally, push this view controller onto the navigation stack.

Build and run your app; tap on one of the table view cells and the ContactsUI framework will display the friend's information as shown below:

![width=50%](/images/4-ContactViewController.png)

What good is a friends list if you can't add more friends? You can use the ContactsUI class `CNContactPickerViewController` to let your user select contacts to use in the app.

## Picking your friends

Open **Main.storyboard** and go to **FriendsViewController**. In the **Object library**, drag a **Bar Button Item** to the right side of the navigation bar, as shown below:

![bordered width=50%](/images/5-BarButtonDrag.png)

In the **Attributes inspector**, click in the text field next to **Image** and type **AddButton**:

![bordered width=40%](/images/6-ButtonAdd.png)

Switch to the **Assistant Editor** and change it to **Automatic**, as shown below:

![bordered width=50%](/images/7-AssistantAutomatic.png)

In the storyboard, select the bar button item you just dragged in, then **Control-Drag** into the `FriendsViewController` implementation in the **Assistant Editor**. Create a new action named **addFriends** that accepts a **UIBarButtonItem** as a parameter:

![bordered width=40%](/images/8-addAction.png)

When the user presses the Add button, you'll present the **CNContactPickerViewController** so the user can import their friends from their contacts list.

To do this, add the following code to `addFriends(_:)`:

```swift
let contactPicker = CNContactPickerViewController()
presentViewController(contactPicker, animated: true, completion: nil)
```

Build and run your app; press the **Add** button in the navigation bar and you'll see your **CNContactPickerViewController** appear:

![iphone](/images/9-PickerFirstView.png)

Currently, the user cannot import contacts. When the user selects a contact, the picker view controller just shows more information about the contact.

In order to fix this problem, you need to take advantage of the methods of `CNContactPickerDelegate`.

### Conforming to CNContactPickerDelegate

The `CNContactPickerDelegate` protocol has five optional methods, but you'll be interested in `contactPicker(_:didSelectContacts:)`; when you implement this method, `CNContactPickerViewController` knows you want to support multiple selection.

Create the following extension of `FriendsViewController` in **FriendsViewController.swift**:

```swift
extension FriendsViewController: CNContactPickerDelegate {
  func contactPicker(picker: CNContactPickerViewController,
    didSelectContacts contacts: [CNContact]) {

  }
}
```

`FriendsViewController` now conforms to `CNContactPickerDelegate`. You have an empty implementation of `contactPicker(_:didSelectContacts:)`, which you'll fill with code that does the following things:

1. Creates new `Friend` instances from `CNContact`s
2. Adds the new `Friend` instances to your friends list

To create a `Friend` from a `CNContact`, you'll need a new initializer for `Friend` that takes a `CNContact` instance as a parameter.

### Creating a friend from a CNContact

Open **Friend.swift** and add the following initializer in its extension:

```swift
init(contact: CNContact){
  firstName = contact.givenName
  lastName = contact.familyName
  workEmail = contact.emailAddresses.first!.value as! String
  if let imageData = contact.imageData{
    profilePicture = UIImage(data: imageData)
  } else {
    profilePicture = nil
  }
}
```

When you set `workEmail` you force unwrap the first email address found. Because RWConnect uses email to keep in touch with your friends, all of your contacts must have email addresses. If force unwrapping like this makes you twitchy, don't worry — you'll fix it later! :]

### Adding new friends to the friends List

Return to **FriendsViewController.swift** and add the following lines to `contactPicker(_:didSelectContacts:)`:

```swift
let newFriends = contacts.map { Friend(contact: $0) }
for friend in newFriends {
  if !friendsList.contains(friend){
    friendsList.append(friend)
  }
}
tableView.reloadData()
```

This code transforms each contact the picker returns into a Friend and adds it to the friends list. To show these changes, you simply tell the table view to reload.

Go back to `addFriends(_:)`, and add the following line just before the call to `presentViewController(_:animated:completion:)`:

```swift
contactPicker.delegate = self
```

This oft-forgotten line assigns the friends view controller as at the contact picker's delegate.

Build and run your project; you can now select multiple contacts:

![iphone](/images/10-PickerMultiSelect.png)

Press the **Done** button, and you'll have a few more friends than you did before!

![width=32%](/images/11-ContactsAddedFromPicker.png)

However, if you select contacts that don't have an associated email address, the app will crash. :[

![width=30%](/images/What'sTheProblem.png)

Recall that you force-unwrapped the first email from the contact's email addresses in the `init(contact:)` initializer of `Friend`; a missing email address means the app will crash. Is there a way to make sure that the user can only select contacts with emails? You betcha!

Add the following line before `presentViewController(_:animated:completion:)`:

```swift
contactPicker.predicateForEnablingContact =
  NSPredicate(format: "emailAddresses.@count > 0")
```
The contact picker's `predicateForEnablingContacts` let you decide which contacts can be selected. In this case, you want to restrict the list of contacts to those with email addresses.

Build and run your app again; press the Add button and you'll see that any contacts without email addresses are grayed out:

![iphone](/images/12-GrayedOutContacts.png)

Now that you can create friends from your contacts, it's only natural to want to create contacts from your friends! Jump right on to the next section to discover how!

## Saving friends to the user's contacts

When the user slides left on a table view cell, you'll show a "Create Contact" action to add a friend to the user's contact store.

Add the following code inside the table view delegate extension you added to **FriendsViewController.swift**:

```swift
override func tableView(tableView: UITableView,
  editActionsForRowAtIndexPath indexPath: NSIndexPath)
  -> [UITableViewRowAction]? {
    let createContact = UITableViewRowAction(style: .Normal,
      title: "Create Contact") { rowAction, indexPath in
        tableView.setEditing(false, animated: true)
        // TODO: Add the contact
    }
    createContact.backgroundColor = BlueColor
    return [createContact]
}
```

The above code creates a single row action for the table view cells named "Create Contact" with a blue background color.

Build and run your app; slide left on a table view cell and you'll see the row action appear like so:

![width=32%](/images/13-RowAction.png)

Before you access or modify a user's contacts, it's imperative that you request their permission first; your apps should always respect the user's privacy settings. For this reason, permission functionality is built into the Contacts framework. You can't access the user's contacts without their permission.

> **Note**: When you used `CNContactPickerViewController`, you didn't have to ask for the user's permission. Why? `CNContactPickerViewController` is **out-of-process**, meaning that your app has no access to the contacts shown in the picker, and the user doesn't have to grant permission for this action. If the user selects contacts and presses **Done**, they've given you implicit permission to use their contacts.

### Asking for permission

To ask the user for permission, replace the `TODO` comment in the row action you created earlier with the following code:

```swift
let contactStore = CNContactStore()
contactStore.requestAccessForEntityType(CNEntityType.Contacts) {
  userGrantedAccess, _ in

}
```

Here you create a `CNContactStore` instance; this represents the user's address book which contains all their contacts. Once you initialize the contact store, you call the instance method `requestAccessForEntityType(:completion:)`.

The completion handler takes a boolean value that indicates whether the user granted permission to access their contacts.

The system presents an alert asking the user for permission the first time you call this method. Each time after that, you call the completion with the user's stored preference. The only way the user can revoke their permission is through the Settings app.

You'll first handle the condition when the user does **not** grant permission. The best practice in this case is to explain the issue to the user and give them the option to open the Settings app.

Add the following method to `FriendsViewController`:

```swift
func presentPermissionErrorAlert() {
  dispatch_async(dispatch_get_main_queue()) {
    let alert =
      UIAlertController(title: "Could Not Save Contact",
        message: "How am I supposed to add the contact if " +
        "you didn't give me permission?",
        preferredStyle: .Alert)

    let openSettingsAction = UIAlertAction(title: "Settings",
      style: .Default, handler: { alert in
        UIApplication.sharedApplication()
          .openURL(
            NSURL(string: UIApplicationOpenSettingsURLString)!)
    })
    let dismissAction = UIAlertAction(title: "OK",
      style: .Cancel, handler: nil)
    alert.addAction(openSettingsAction)
    alert.addAction(dismissAction)
    self.presentViewController(alert, animated: true,
      completion: nil)
  }
}
```

The above method presents an alert to the user indicating the app can't save the contact. The first UIAlertAction opens the Settings app using the `UIApplicationOpenSettingsURLString` key.

> **Note**: The request access completion block executes on "an arbitrary queue", so you wrap this method in a `dispatch_async` block to ensure the UI code executes on the main thread. The documentation recommends that you work with the contacts store on the handler thread and dispatch to the main thread for UI changes.

Return to the `requestAccessForEntityType(:completion:)` completion handler and add the following code:

```swift
guard userGrantedAccess else {
  self.presentPermissionErrorAlert()
  return
}
```

The `guard` statement checks that the user granted permission; if not, you display an alert using `presentPermissionErrorAlert()`.

Build and run the app in the simulator; select the **Create Contact** row action for a contact and you'll be prompted for permission to access your contacts:

![width=32%](/images/14-PermissionAlert.png)

Select **Don't Allow**; you'll see your custom alert presented like so:

![width=32%](/images/15-YouRejectedMe.png)

Press **Settings** on your alert and you'll be taken to the Settings app where you can modify your permission if you so desire:

![width=32%](/images/16-AppSettingsPage.png)

The `guard` statement neatly handles the case where the user does not grant permission. The next logical step is to handle the case where the user grants permission and save the friend to the user's contact store.

### Saving friends to contacts

Add the following method to `FriendsViewController`:

```swift
func saveFriendToContacts(friend: Friend) {
  // 1
  let contact = friend.contactValue.mutableCopy()
    as! CNMutableContact
  // 2
  let saveRequest = CNSaveRequest()
  // 3
  saveRequest.addContact(contact,
    toContainerWithIdentifier: nil)
  do {
    // 4
    let contactStore = CNContactStore()
    try contactStore.executeSaveRequest(saveRequest)
    // Show Success Alert
  } catch {
    // Show Failure Alert
  }
}
```

Taking each numbered comment in turn:

1. First, `addContact` of the Contacts framework expects a mutable contact so you have to convert the Friend parameter into a `CNMutableContact`.
2. Next, create a new `CNSaveRequest`; you use this object to communicate new, updated, or deleted contacts to the `CNContactStore`.
3. Then tell `CNSaveRequest` you want to add the friend to the user's contacts.
4. Finally, try to execute the save request. If the method succeeds, then execution continues and you can assume the save request succeeded; otherwise, you throw an error.

> **Note**: The `catch` block doesn't create a custom alert for every possible thrown error; instead, you use a generic error message. To handle specific error cases, you catch a `CNErrorCode`. These aren't documented, but their declarations exist for your perusal in **CNError.h**.

Now you need to notify the user of the state of their request.

Add the following code to display the alert at `// Show Success Alert`:

```swift
dispatch_async(dispatch_get_main_queue()) {
  let successAlert = UIAlertController(title: "Contacts Saved",
    message: nil, preferredStyle: .Alert)
  successAlert.addAction(UIAlertAction(title: "OK",
    style: .Cancel, handler: nil))
  self.presentViewController(successAlert, animated: true,
    completion: nil)
}
```

Next, add the following code at `// Show Failure Alert`:

```swift
dispatch_async(dispatch_get_main_queue()) {
  let failureAlert = UIAlertController(
    title: "Could Not Save Contact",
    message: "An unknown error occurred.",
    preferredStyle: .Alert)
  failureAlert.addAction(UIAlertAction(title: "OK",
  style: .Cancel, handler: nil))
  self.presentViewController(failureAlert, animated: true,
    completion: nil)
}
```

Return to `tableView(_:editActionsForRowAtIndexPath:)` and add the following code after the `guard` block:

```swift
let friend = self.friendsList[indexPath.row]
self.saveFriendToContacts(friend)
```

Here you pass the friend to add into your save method.

Since you've already granted permission for this app, you'll need to reset the simulator to force the app to prompt for permissions again. This way, you can test all possible permission situations in your app. Select **iOS Simulator/Reset Content and Settings...** as shown below:

![bordered width=35%](/images/17-ResetTheSimulator.png)

Build and run your app; slide left on any contact and tap **OK** when prompted for permission. The app should show the following confirmation:

![width=32%](/images/18-ContactSaved.png)

Now press **Command-Shift-H** in the simulator and open the Contacts app. You'll see your friend appear in your contact list:

![iphone](/images/19-RayIsInMyContacts.png)

Sharp-eyed readers will note you can add the same contact multiple times. You'll add some code to prevent against that.

### Checking for existing contacts

Add the following to the top of `saveFriendToContacts(_:)`:

```swift
//1
let contactFormatter = CNContactFormatter()
//2
let contactName = contactFormatter
  .stringFromContact(friend.contactValue)!
//3
let predicateForMatchingName = CNContact
  .predicateForContactsMatchingName(contactName)
//4
let matchingContacts = try! CNContactStore()
  .unifiedContactsMatchingPredicate(predicateForMatchingName,
    keysToFetch: [])
//4
guard matchingContacts.isEmpty else {
  dispatch_async(dispatch_get_main_queue()) {
    let alert = UIAlertController(
      title: "Contact Already Exists", message: nil,
      preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Cancel,
      handler: nil))
    self.presentViewController(alert, animated: true,
      completion: nil)
  }
  return
}
```

It looks like a lot of detailed code, but it breaks down quite simply:

1. The `CNContactFormatter` class generates locale-aware display names from stored contacts, much as `NSDateFormatter` does with dates.
2. Next, you use the formatter to create the name string based on the contact's given and family name, as well as any titles and suffixes.
3. You then create a predicate for searching the contacts store based on the name string generated in the previous step.
4. `CNContactStore` lets you query the user's contacts for those matching the predicate. In this case, you used `CNContact`'s `predicateForContactsMatchingName(_:)` method to create an `NSPredicate` that finds contacts having a name similar to the provided string.
4. You only save the contact if there aren't any matches; the `guard` statement stops the process in the event of name matches.

> **Note**: `unifiedContactsMatchingPredicate(_:keysToFetch:)` has a `keysToFetch` parameter that you ultimately ignore by passing in an empty array. However, if you were to try to access or modify the fetched contacts, you'd see an error thrown as the keys weren't fetched. For example, if you wanted to access the fetched contacts' first names you'd have to add `CNContactGivenNameKey` to `keysToFetch`.

Build and run your app; try to add a contact that already exists and the app prevents you from doing so.

You're done! You've dramatically improved RWConnect — and learned a ton about the new Contacts framework in the process!

## Where to go from here?

At this point you've learned just about everything you need to use the Contacts and ContactsUI frameworks in your own apps. However, there is more to learn about the two frameworks if you want to dig even deeper.

To learn more, be sure to visit the Contact framework guide at [http://apple.co/1LuCodW](http://apple.co/1LuCodW).

You can also check out the WWDC 2015 Session 223: Introducing the Contacts Framework for iOS and OS X [http://apple.co/1MQVNZV](http://apple.co/1MQVNZV).
